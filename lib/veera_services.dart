import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:record/record.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// The user can try the UI without credentials. Configure these at build time
/// for a connected Supabase project; never put Gemini or Sarvam keys here.
const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const supabasePublishableKey = String.fromEnvironment(
  'SUPABASE_PUBLISHABLE_KEY',
);

bool get veeraCloudConfigured =>
    supabaseUrl.isNotEmpty && supabasePublishableKey.isNotEmpty;

Future<void> initializeVeeraCloud() async {
  if (veeraCloudConfigured) {
    await Supabase.initialize(
      url: supabaseUrl,
      publishableKey: supabasePublishableKey,
    );
  }
}

class AgentReply {
  const AgentReply(this.text, {this.source = 'VEERA guide', this.live = false});
  final String text;
  final String source;
  final bool live;
}

class VeeraServices {
  static Future<bool> prepareCloudSession() async {
    if (!veeraCloudConfigured) return false;
    try {
      final auth = Supabase.instance.client.auth;
      if (auth.currentSession == null) await auth.signInAnonymously();
      return auth.currentSession != null;
    } catch (_) {
      return false;
    }
  }

  static final _sensitivePattern = RegExp(
    r'\b(period|periods|menstrual|menstruation|cycle|pregnan|bleed|bleeding|cramp|cramps|pain|injur|injured|injury|dizzy|faint|unsafe|abuse|self.?harm|suicid)\b|மாதவிடாய்|ரத்தப்போக்கு|வலி|காயம்|மயக்கம்|தற்கொலை|துன்புறுத்தல்|பாதுகாப்பில்லை',
    caseSensitive: false,
  );

  static String _intentFor(String text) {
    final t = text.toLowerCase();
    if (t.contains('scheme') ||
        t.contains('grant') ||
        t.contains('fund') ||
        t.contains('scholar'))
      return 'funding';
    if (t.contains('event') ||
        t.contains('competition') ||
        t.contains('trial') ||
        t.contains('tournament') ||
        t.contains('camp'))
      return 'competitions';
    if (t.contains('application') ||
        t.contains('apply') ||
        t.contains('eligibility') ||
        t.contains('document'))
      return 'applications';
    if (t.contains('recover') || t.contains('rest')) return 'recovery';
    if (t.contains('train') || t.contains('workout') || t.contains('practice'))
      return 'training';
    if (t.contains('travel') || t.contains('support')) return 'support';
    return 'opportunities';
  }

  /// Do not send health or safeguarding content to Gemini. Route it to an
  /// on-device, supportive response and invite human help instead.
  static AgentReply localSensitiveReply(String text) {
    final t = text.toLowerCase();
    if (RegExp(r'\b(unsafe|abuse|self.?harm|suicid)\b').hasMatch(t)) {
      return const AgentReply(
        'I’m glad you told me. Your safety matters. Please reach a trusted adult, coach you trust, or local emergency support now. I cannot contact them for you from this app. If there is immediate danger, move to a safer place and contact emergency services.',
        source: 'Private on-device support',
      );
    }
    return const AgentReply(
      'I’m sorry you’re dealing with that. I can’t assess symptoms or prescribe a training change. You can choose to pause or ease today, and talk with a trusted coach or qualified health professional. Your private check-in is not sent to the AI service.',
      source: 'Private on-device support',
    );
  }

  static Future<AgentReply> ask(String text, {required bool allowCloud}) async {
    final trimmed = text.trim();
    if (_sensitivePattern.hasMatch(trimmed))
      return localSensitiveReply(trimmed);
    if (!allowCloud || !veeraCloudConfigured) return _fallback(trimmed);
    try {
      if (!await prepareCloudSession()) return _fallback(trimmed);
      final result = await Supabase.instance.client.functions
          // Send only a bounded, non-personal intent. Free text never leaves
          // the device, even when cloud AI is enabled.
          .invoke('veera-agent', body: {'intent': _intentFor(trimmed)})
          .timeout(const Duration(seconds: 18));
      final data = result.data;
      if (data is Map && data['answer'] is String) {
        return AgentReply(
          data['answer'] as String,
          source: (data['source'] as String?) ?? 'VEERA opportunity guide',
          live: true,
        );
      }
    } catch (_) {
      // Provider, network, timeout, or unconfigured project: use a local answer.
    }
    return _fallback(trimmed);
  }

  static Future<List<Map<String, dynamic>>> fetchOpportunities() async {
    if (!veeraCloudConfigured) return const [];
    try {
      final rows = await Supabase.instance.client
          .from('opportunities')
          .select(
            'title,kind,sport,district,eligibility,benefit,deadline,source_name,source_url,verified_at',
          )
          .eq('status', 'verified')
          .order('deadline', ascending: true)
          .limit(30);
      return List<Map<String, dynamic>>.from(rows);
    } catch (_) {
      return const [];
    }
  }

  static AgentReply _fallback(String text) {
    final t = text.toLowerCase();
    if (t.contains('scheme') ||
        t.contains('grant') ||
        t.contains('fund') ||
        t.contains('scholar')) {
      return const AgentReply(
        'I can help you compare grants, scholarships, travel support, and equipment aid. Check the provider, eligibility, deadline, and official application link before sharing documents. Live listings are unavailable right now; ask your coach or district sports office to verify current opportunities.',
        source: 'Offline opportunity checklist',
      );
    }
    if (t.contains('event') ||
        t.contains('competition') ||
        t.contains('trial') ||
        t.contains('tournament')) {
      return const AgentReply(
        'For an event, confirm the organizer, age and sport category, venue, registration deadline, fees, and travel arrangements. Live listings are unavailable right now, so verify dates with the official organizer before making plans.',
        source: 'Offline event checklist',
      );
    }
    if (t.contains('train') ||
        t.contains('recovery') ||
        t.contains('workout')) {
      return const AgentReply(
        'I can help you organize questions for your coach and explain general recovery ideas. Your coach should set or change your training plan. Tell them how you feel and what support would help today.',
        source: 'Offline athlete guide',
      );
    }
    return const AgentReply(
      'I can help find events and financial support, organize an application checklist, or prepare a draft for you to review. For live details, connect the app to the team’s verified opportunity catalogue.',
      source: 'Offline VEERA guide',
    );
  }
}

/// Voice input uses Sarvam only after the athlete taps the microphone.
/// The microphone stream stays in memory and is sent once as a short clip;
/// there is no audio-file save or app-side transcript history.
class VeeraVoiceInput {
  final AudioRecorder _recorder = AudioRecorder();
  StreamSubscription<Uint8List>? _subscription;
  final List<Uint8List> _chunks = [];
  bool _recording = false;
  bool get isRecording => _recording;

  Future<bool> start() async {
    if (!await _recorder.hasPermission()) return false;
    _chunks.clear();
    final stream = await _recorder.startStream(
      const RecordConfig(
        encoder: AudioEncoder.pcm16bits,
        sampleRate: 16000,
        numChannels: 1,
      ),
    );
    _subscription = stream.listen(_chunks.add);
    _recording = true;
    return true;
  }

  Future<String> stopAndTranscribe() async {
    await _recorder.stop();
    await _subscription?.cancel();
    _recording = false;
    if (!veeraCloudConfigured || _chunks.isEmpty) return '';
    final raw = BytesBuilder(copy: false);
    for (final chunk in _chunks) {
      raw.add(chunk);
    }
    final pcm = raw.takeBytes();
    _chunks.clear();
    try {
      final response = await Supabase.instance.client.functions
          .invoke(
            'sarvam-transcribe',
            body: {'audioBase64': base64Encode(_wav(pcm)), 'consent': true},
          )
          .timeout(const Duration(seconds: 30));
      if (response.data is Map)
        return (response.data['transcript'] as String?) ?? '';
    } catch (_) {
      return '';
    }
    return '';
  }

  Uint8List _wav(Uint8List pcm) {
    final header = ByteData(44);
    void ascii(int offset, String value) {
      for (var i = 0; i < value.length; i++) {
        header.setUint8(offset + i, value.codeUnitAt(i));
      }
    }

    ascii(0, 'RIFF');
    header.setUint32(4, pcm.length + 36, Endian.little);
    ascii(8, 'WAVE');
    ascii(12, 'fmt ');
    header.setUint32(16, 16, Endian.little);
    header.setUint16(20, 1, Endian.little);
    header.setUint16(22, 1, Endian.little);
    header.setUint32(24, 16000, Endian.little);
    header.setUint32(28, 32000, Endian.little);
    header.setUint16(32, 2, Endian.little);
    header.setUint16(34, 16, Endian.little);
    ascii(36, 'data');
    header.setUint32(40, pcm.length, Endian.little);
    return Uint8List.fromList([...header.buffer.asUint8List(), ...pcm]);
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
    await _recorder.dispose();
  }
}
