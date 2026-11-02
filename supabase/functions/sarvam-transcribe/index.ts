const cors = {
  'access-control-allow-origin': '*',
  'access-control-allow-headers': 'authorization, x-client-info, apikey, content-type',
  'access-control-allow-methods': 'POST, OPTIONS',
};
const json = (body: unknown, status = 200) => new Response(JSON.stringify(body), {
  status, headers: { ...cors, 'content-type': 'application/json', 'cache-control': 'no-store' },
});

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') return new Response('ok', { headers: cors });
  if (req.method !== 'POST') return json({ error: 'POST required' }, 405);
  try {
    const body = await req.json();
    if (body.consent !== true || typeof body.audioBase64 !== 'string' || body.audioBase64.length > 3_000_000) {
      return json({ error: 'Explicit voice consent and a short audio clip are required.' }, 400);
    }
    const apiKey = Deno.env.get('SARVAM_API_KEY');
    if (!apiKey) return json({ error: 'Voice service is not configured.' }, 503);
    const bytes = Uint8Array.from(atob(body.audioBase64), (c) => c.charCodeAt(0));
    if (bytes.length < 44 || String.fromCharCode(...bytes.slice(0, 4)) !== 'RIFF') return json({ error: 'Expected WAV audio.' }, 400);
    const form = new FormData();
    form.append('file', new Blob([bytes], { type: 'audio/wav' }), 'voice.wav');
    form.append('model', 'saaras:v4');
    form.append('mode', 'transcribe');
    form.append('with_timestamps', 'false');
    const response = await fetch('https://api.sarvam.ai/speech-to-text', {
      method: 'POST', headers: { 'api-subscription-key': apiKey }, body: form, signal: AbortSignal.timeout(25000),
    });
    if (!response.ok) return json({ error: 'Speech recognition is temporarily unavailable.' }, 502);
    const result = await response.json();
    return json({ transcript: typeof result.transcript === 'string' ? result.transcript : '' });
  } catch (_) {
    return json({ error: 'Could not transcribe this clip.' }, 502);
  }
});
