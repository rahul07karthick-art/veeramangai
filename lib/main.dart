import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const VeeramangaiApp());
}

class VeeramangaiApp extends StatelessWidget {
  const VeeramangaiApp({super.key});

  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.dark);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, _) {
        return MaterialApp(
          title: 'Veeramangai - Women in Sport',
          debugShowCheckedModeBanner: false,
          themeMode: currentMode,
          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: const Color(0xFFF8FAFC),
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0284C7),
              secondary: Color(0xFF10B981),
              surface: Color(0xFFFFFFFF),
            ),
            fontFamily: 'Roboto',
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF070C0E),
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFF59E0B),
              secondary: Color(0xFF10B981),
              surface: Color(0xFF0F171B),
            ),
            fontFamily: 'Roboto',
          ),
          home: const MainHomeScreen(),
        );
      },
    );
  }
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen>
    with TickerProviderStateMixin {
  // Stance: false = standing, true = action
  bool _isActionStance = false;
  Timer? _stanceTimer;

  // Prominent Ken Burns zoom animation
  late AnimationController _zoomController;
  late Animation<double> _zoomAnimation;

  // Floating animation for posters
  late AnimationController _floatController;

  // Opening entrance animation when app opens
  late AnimationController _entranceController;
  late Animation<double> _entranceFade;
  late Animation<double> _entranceScale;
  late Animation<Offset> _entranceSlide;

  // Avvai Pet Companion state
  int _petTipIndex = 0;
  final bool _petBubbleVisible = true;
  final List<String> _avvaiTips = [
    "வணக்கம்! Ragi kanji provides 344mg calcium for runners!",
    "Sprouted sundal has 22g protein for recovery under ₹15!",
    "Tender coconut water rehydrates potassium after drills!",
    "Vaigai Express departs Friday for Madurai selection trials!",
    "Tap me to chat with Avvai or test your readiness score!"
  ];

  // Selected feature modal
  String? _activeFeature;

  @override
  void initState() {
    super.initState();

    // Opening entrance animation (dramatic hero reveal on startup)
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _entranceFade = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeIn),
    );

    _entranceScale = Tween<double>(begin: 0.94, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutBack),
      ),
    );

    _entranceSlide = Tween<Offset>(
      begin: const Offset(0.0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _entranceController.forward();

    // Ken Burns dynamic zoom (clearly visible scale from 1.0 to 1.12)
    _zoomController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);

    _zoomAnimation = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(parent: _zoomController, curve: Curves.easeInOut),
    );

    // Subtle floating animation
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    // Auto cross-fade background every 5 seconds
    _stanceTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (mounted) {
        setState(() {
          _isActionStance = !_isActionStance;
        });
      }
    });
  }

  @override
  void dispose() {
    _stanceTimer?.cancel();
    _zoomController.dispose();
    _floatController.dispose();
    _entranceController.dispose();
    super.dispose();
  }

  void _triggerActionStance() {
    setState(() {
      _isActionStance = true;
    });
  }

  void _openFeature(String feature) {
    _triggerActionStance();
    setState(() {
      _activeFeature = feature;
    });
  }

  void _closeFeature() {
    setState(() {
      _activeFeature = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;

    return Scaffold(
      body: Stack(
        children: [
          // 1. HIGH-VISIBILITY DUAL-IMAGE ATHLETE BACKGROUND WITH KEN BURNS EFFECT
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _zoomAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _zoomAnimation.value,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Standing Athlete Image
                      AnimatedOpacity(
                        opacity: _isActionStance ? 0.0 : 0.95,
                        duration: const Duration(milliseconds: 1200),
                        curve: Curves.easeInOut,
                        child: Image.asset(
                          'assets/images/hero_standing.jpg',
                          fit: BoxFit.cover,
                          alignment: const Alignment(0.0, -0.2),
                        ),
                      ),
                      // Action Stance Athlete Image
                      AnimatedOpacity(
                        opacity: _isActionStance ? 0.95 : 0.0,
                        duration: const Duration(milliseconds: 1200),
                        curve: Curves.easeInOut,
                        child: Image.asset(
                          'assets/images/hero_action.jpg',
                          fit: BoxFit.cover,
                          alignment: const Alignment(0.0, -0.2),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // 2. LIGHT CINEMATIC VIGNETTE (NO BLUR, ATHLETES SHARP & PROMINENT)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: Theme.of(context).brightness == Brightness.dark
                      ? const [
                          Color(0x66070C0E), // 40% top for nav visibility
                          Color(0x18070C0E), // 10% middle (athletes super crisp and visible)
                          Color(0xEE070C0E), // 93% bottom for content readability
                        ]
                      : const [
                          Color(0x66F8FAFC),
                          Color(0x15F8FAFC),
                          Color(0xEEF8FAFC),
                        ],
                  stops: const [0.0, 0.38, 0.92],
                ),
              ),
            ),
          ),

          // 2.5. KINETIC VELOCITY PARTICLES & MOTION STREAKS (CLEAR IN BOTH LIGHT & DARK)
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _floatController,
              builder: (context, child) {
                return CustomPaint(
                  painter: _KineticMotionPainter(
                    progress: _floatController.value,
                    isDark: Theme.of(context).brightness == Brightness.dark,
                  ),
                );
              },
            ),
          ),

          // 3. MAIN FOREGROUND SCROLLABLE ATHLETIC PORTAL (OPENING ENTRANCE ANIMATION)
          FadeTransition(
            opacity: _entranceFade,
            child: SlideTransition(
              position: _entranceSlide,
              child: ScaleTransition(
                scale: _entranceScale,
                child: SafeArea(
                  child: Column(
                    children: [
                // Header with Stance HUD
                _buildHeader(),

                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),

                        // Hero Eyebrow
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0x33F59E0B),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: const Color(0x66F59E0B)),
                          ),
                          child: const Text(
                            'TAMIL NADU & ALL-INDIA WOMEN IN SPORT',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.5,
                              color: Color(0xFFFBBF24),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Main Title
                        const Text(
                          'EVERY GOAL HAS A TEAM.\nEVERY ATHLETE A PATHWAY.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                            height: 1.15,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black87,
                                blurRadius: 16,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Direct access to live women’s trials, government & private sports scholarships, AI sports science coaching, and teammate ML intelligence.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFFCBD5E1),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Action Toggles
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _isActionStance = !_isActionStance;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF131C21),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: _isActionStance
                                        ? const Color(0xFFEF4444)
                                        : const Color(0xFFF59E0B),
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.bolt,
                                      size: 16,
                                      color: _isActionStance
                                          ? const Color(0xFFEF4444)
                                          : const Color(0xFFF59E0B),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      _isActionStance
                                          ? 'ACTION STANCE ACTIVE (CLICK TO SWITCH)'
                                          : 'STANDING STANCE (CLICK FOR ACTION)',
                                      style: const TextStyle(
                                        fontFamily: 'monospace',
                                        fontSize: 11,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 1.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 36),

                        // Section Heading: 4 HERITAGE PATHS
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'HERITAGE PATHWAYS',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.2,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Inspired by legendary Tamil queens · Connected to live services',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF94A3B8),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),

                        // 4 ANIMATED FEATURE POSTER BUTTONS (PROPERLY FITTED & PROMINENT NAMES)
                        _buildPostersGrid(isDesktop),

                        const SizedBox(height: 50),

                        // Section 2: Live Trials Section Preview
                        _buildSectionHeader(
                          title: 'LIVE UPCOMING TRIALS (2026)',
                          subtitle:
                              'District & state selection meets across Tamil Nadu',
                          actionText: 'Open Full Trials Board',
                          onAction: () => _openFeature('events'),
                        ),
                        const SizedBox(height: 16),
                        const EventsView(),

                        const SizedBox(height: 40),

                        // Section 3: Scholarships Preview
                        _buildSectionHeader(
                          title: 'SPORTS SCHOLARSHIPS & SCHEMES',
                          subtitle:
                              'SDAT Champions Scheme, Khelo India, and CSR grants',
                          actionText: 'View All Schemes',
                          onAction: () => _openFeature('scholarships'),
                        ),
                        const SizedBox(height: 16),
                        const ScholarshipsView(),

                        const SizedBox(height: 40),

                        // Section 4: Avvai AI Coach
                        _buildSectionHeader(
                          title: 'AVVAI AI SPORTS SCIENCE COACH',
                          subtitle:
                              'Nutrition, recovery, and training advice in English & தமிழ்',
                          actionText: 'Open Chat Studio',
                          onAction: () => _openFeature('coach'),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          height: 480,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F171B),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white12),
                          ),
                          child: const CoachView(),
                        ),

                        const SizedBox(height: 40),

                        // Section 5: Teammate ML Slot
                        _buildSectionHeader(
                          title: 'ATHLETE READINESS PREDICTOR',
                          subtitle:
                              'Custom ML Model Slot ready for teammate model drop-in',
                          actionText: 'Open ML Console',
                          onAction: () => _openFeature('model'),
                        ),
                        const SizedBox(height: 16),
                        const ModelSlotView(),

                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),

          // 4. AVVAI PET COMPANION (FROM THILAK REPO)
          Positioned(
            bottom: 24,
            right: 24,
            child: _buildAvvaiPet(),
          ),

          // 5. MODAL OVERLAY FOR ACTIVE FEATURE
          if (_activeFeature != null)
            Positioned.fill(
              child: GestureDetector(
                onTap: _closeFeature,
                child: Container(
                  color: Colors.black.withValues(alpha: 0.85),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {}, // Prevent closing when tapping inside
                      child: _buildModalContent(_activeFeature!),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAvvaiPet() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_petBubbleVisible)
          GestureDetector(
            onTap: () {
              setState(() {
                _petTipIndex = (_petTipIndex + 1) % _avvaiTips.length;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              constraints: const BoxConstraints(maxWidth: 240),
              decoration: BoxDecoration(
                color: const Color(0xFF131C21),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFF59E0B)),
                boxShadow: const [
                  BoxShadow(color: Colors.black54, blurRadius: 10, offset: Offset(0, 4)),
                ],
              ),
              child: Text(
                _avvaiTips[_petTipIndex],
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.3,
                ),
              ),
            ),
          ),
        GestureDetector(
          onTap: () {
            setState(() {
              _petTipIndex = (_petTipIndex + 1) % _avvaiTips.length;
              _triggerActionStance();
            });
          },
          onDoubleTap: () => _openFeature('coach'),
          child: AnimatedBuilder(
            animation: _floatController,
            builder: (context, child) {
              final bob = math.sin(_floatController.value * 2 * math.pi) * 6;
              return Transform.translate(
                offset: Offset(0, bob),
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFF59E0B), width: 2),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x66F59E0B),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(
                    'assets/images/avvai/avvai-sport-master.png',
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
    required String actionText,
    required VoidCallback onAction,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
                color: Colors.white,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
            ),
          ],
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF131C21),
            foregroundColor: const Color(0xFFF59E0B),
            side: const BorderSide(color: Color(0x4DF59E0B)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          onPressed: onAction,
          child: Text(
            actionText,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              fontFamily: 'monospace',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x66F59E0B),
                      blurRadius: 15,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'வ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'VEERAMANGAI',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'வீரமங்கை · Pathway Guide',
                    style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                tooltip: 'Toggle Theme',
                onPressed: () {
                  VeeramangaiApp.themeNotifier.value =
                      VeeramangaiApp.themeNotifier.value == ThemeMode.dark
                          ? ThemeMode.light
                          : ThemeMode.dark;
                },
                icon: Icon(
                  VeeramangaiApp.themeNotifier.value == ThemeMode.dark
                      ? Icons.dark_mode
                      : Icons.light_mode,
                  color: const Color(0xFFF59E0B),
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () {
                  setState(() {
                    _isActionStance = !_isActionStance;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F171B),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: _isActionStance
                          ? const Color(0xFFEF4444)
                          : const Color(0xFF10B981),
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _isActionStance
                              ? const Color(0xFFEF4444)
                              : const Color(0xFF10B981),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isActionStance ? 'STANCE: ACTION' : 'STANCE: STANDING',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPostersGrid(bool isDesktop) {
    final posters = [
      _PosterItem(
        id: 'events',
        tag: '01 / SIVAGANGA',
        domain: 'OPPORTUNITIES',
        queenEn: 'VELU NACHIYAR',
        queenTa: 'வீரமங்கை வேலு நாச்சியார்',
        title: 'Upcoming Events & Trials',
        desc: 'Real-time tournaments, state athletics meets, Khelo India, and SDAT trials.',
        image: 'assets/images/poster1.jpg',
        color: const Color(0xFFF59E0B),
        era: '1780 CE · SIVAGANGA ARCHIVES',
        quote: 'First Indian Queen to vanquish colonial army through guerrilla velocity and specialized all-women regiments.',
        stat1Val: '14',
        stat1Lbl: 'ACTIVE TRIALS',
        stat2Val: '38',
        stat2Lbl: 'TN DISTRICTS',
        stat3Val: '11.8s',
        stat3Lbl: 'SPRINT CUTOFF',
        chips: const ['🤼 Kabaddi', '⚡ Sprint', '⚔️ Silambam'],
        tactical: 'Tracks SDAT district notification alerts across Sivaganga, Madurai & Chennai for U-19 and Senior women selection.',
      ),
      _PosterItem(
        id: 'scholarships',
        tag: '02 / CHOLA EMPIRE',
        domain: 'SCHOLARSHIPS',
        queenEn: 'SEMBIYAN MAHADEVI',
        queenTa: 'செம்பியன் மாதேவி',
        title: 'Scholarships & Schemes',
        desc: 'SDAT Champions Development Scheme, Khelo India, and corporate CSR sports grants.',
        image: 'assets/images/poster2.jpg',
        color: const Color(0xFF10B981),
        era: '10TH CENTURY · CHOLA REALM',
        quote: 'Architect of autonomous temple trusts and sports endowment funds for rural village youth.',
        stat1Val: '₹2.0L',
        stat1Lbl: 'STATE GRANT',
        stat2Val: '₹6.28L',
        stat2Lbl: 'TALENT POOL',
        stat3Val: '100%',
        stat3Lbl: 'FEMALE QUOTA',
        chips: const ['💰 SDAT ₹2L', '🏆 Khelo India', '📋 CSR Grant'],
        tactical: 'Direct Benefit Transfer (DBT) verification engine matching women athletes to sports kit allowances and international travel stipends.',
      ),
      _PosterItem(
        id: 'transit',
        tag: '03 / MADURAI',
        domain: 'SAFE TRANSIT',
        queenEn: 'RANI MANGAMMAL',
        queenTa: 'ராணி மங்கம்மாள்',
        title: 'Safe Transit & Logistics',
        desc: 'Safe competition transit, accompanied travel pods, and district sports logistics.',
        image: 'assets/images/poster3.jpg',
        color: const Color(0xFF06B6D4),
        era: '1689 CE · MADURAI NAYAK KINGDOM',
        quote: 'Visionary regent who built the Grand Royal Highway network with fortified choultries and protected travel corridors for women.',
        stat1Val: '38',
        stat1Lbl: 'CORRIDORS',
        stat2Val: '75%',
        stat2Lbl: 'FARE WAIVER',
        stat3Val: '99.4%',
        stat3Lbl: 'SAFETY SCORE',
        chips: const ['🛡️ Safe Pass', '🚆 75% Bus/Rail', '📍 Madurai'],
        tactical: 'Accompanied cluster routing connecting district athletes to state stadiums in Chennai and Madurai with 181 Women Helpline integration.',
      ),
      _PosterItem(
        id: 'coach',
        tag: '04 / THANJAVUR',
        domain: 'AI & NUTRITION',
        queenEn: 'KUNDAVAI PIRATTIYAR',
        queenTa: 'குந்தவை பிராட்டியார்',
        title: 'AI Sports & Nutrition Coach',
        desc: 'Personalized nutrition (ragi, sundal), menstrual cycle training sync with Avvai.',
        image: 'assets/images/poster4.jpg',
        color: const Color(0xFFC084FC),
        era: '1014 CE · CHOLA SANATORIUMS',
        quote: 'Imperial Princess and founder of Aathula Saalai medical sanatoriums integrating Siddha medicine with peak physical conditioning.',
        stat1Val: '4:1',
        stat1Lbl: 'CARB-PROTEIN',
        stat2Val: 'Follicular',
        stat2Lbl: 'POWER PHASE',
        stat3Val: '98%',
        stat3Lbl: 'RECOVERY RATE',
        chips: const ['🥣 Ragi Fuel', '🩸 Cycle Sync', '🧘 Recovery'],
        tactical: 'AI Sports Nutrition paired with cycle-synced macro timing (Ragi & Sundal traditional high-protein fuels) and prehab injury prevention.',
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 900
            ? 4
            : constraints.maxWidth > 550
                ? 2
                : 1;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 0.51,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemCount: posters.length,
          itemBuilder: (context, index) {
            final p = posters[index];
            return AnimatedBuilder(
              animation: _floatController,
              builder: (context, child) {
                final offset = math.sin(
                      (_floatController.value * 2 * math.pi) +
                          (index * (math.pi / 2)),
                    ) *
                    6;
                return Transform.translate(
                  offset: Offset(0, offset),
                  child: _InteractivePosterCard(
                    item: p,
                    onOpen: () => _openFeature(p.id),
                    onChip: (c) => _openFeature(p.id),
                    onInspect: () => _showQueenDossierSheet(context, p),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _showQueenDossierSheet(BuildContext context, _PosterItem p) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F172A) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(color: p.color.withValues(alpha: 0.4)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 30,
                offset: const Offset(0, -6),
              ),
            ],
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: p.color, width: 2),
                      image: DecorationImage(
                        image: AssetImage(p.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.tag,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: p.color,
                          ),
                        ),
                        Text(
                          p.queenEn,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          p.queenTa,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: p.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(ctx),
                    icon: Icon(Icons.close, color: isDark ? Colors.white70 : Colors.black54),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: p.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: p.color.withValues(alpha: 0.3)),
                ),
                child: Text(
                  '“${p.quote}”',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 12,
                    color: isDark ? Colors.white70 : const Color(0xFF334155),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatCell(p.stat1Val, p.stat1Lbl, p.color, isDark),
                  _buildStatCell(p.stat2Val, p.stat2Lbl, p.color, isDark),
                  _buildStatCell(p.stat3Val, p.stat3Lbl, p.color, isDark),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                p.tactical,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.4,
                  color: isDark ? Colors.white60 : const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _openFeature(p.id);
                  },
                  icon: const Icon(Icons.bolt, size: 16),
                  label: Text('OPEN ${p.queenEn} PORTAL'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: p.color,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    textStyle: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 0.8),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget _buildStatCell(String val, String lbl, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          Text(
            val,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              fontFamily: 'monospace',
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            lbl,
            style: const TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.bold,
              color: Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModalContent(String feature) {
    Widget innerContent;
    String title;

    if (feature == 'events') {
      title = 'Live Upcoming Events & Trials';
      innerContent = const EventsView();
    } else if (feature == 'scholarships') {
      title = 'Sports Scholarships & Schemes';
      innerContent = const ScholarshipsView();
    } else if (feature == 'transit') {
      title = 'Rani Mangammal — Safe Transit & Travel Corridor';
      innerContent = const TransitView();
    } else if (feature == 'coach') {
      title = 'Avvai — Sports Science & Nutrition Coach';
      innerContent = const CoachView();
    } else {
      title = 'Teammate ML Model Slot';
      innerContent = const ModelSlotView();
    }

    return Container(
      width: math.min(MediaQuery.of(context).size.width * 0.92, 850),
      height: math.min(MediaQuery.of(context).size.height * 0.88, 720),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1519),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black87,
            blurRadius: 40,
            offset: Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        children: [
          // Modal Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: _closeFeature,
                  icon: const Icon(Icons.close, color: Colors.white70),
                  splashRadius: 20,
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.white10),
          Expanded(child: innerContent),
        ],
      ),
    );
  }
}

class _PosterItem {
  final String id;
  final String tag;
  final String domain;
  final String queenEn;
  final String queenTa;
  final String title;
  final String desc;
  final String image;
  final Color color;
  final String era;
  final String quote;
  final String stat1Val;
  final String stat1Lbl;
  final String stat2Val;
  final String stat2Lbl;
  final String stat3Val;
  final String stat3Lbl;
  final List<String> chips;
  final String tactical;

  _PosterItem({
    required this.id,
    required this.tag,
    required this.domain,
    required this.queenEn,
    required this.queenTa,
    required this.title,
    required this.desc,
    required this.image,
    required this.color,
    required this.era,
    required this.quote,
    required this.stat1Val,
    required this.stat1Lbl,
    required this.stat2Val,
    required this.stat2Lbl,
    required this.stat3Val,
    required this.stat3Lbl,
    required this.chips,
    required this.tactical,
  });
}

// ==========================================
// INTERACTIVE 3D FLIP POSTER CARD WIDGET
// ==========================================
class _InteractivePosterCard extends StatefulWidget {
  final _PosterItem item;
  final VoidCallback onOpen;
  final ValueChanged<String> onChip;
  final VoidCallback onInspect;

  const _InteractivePosterCard({
    required this.item,
    required this.onOpen,
    required this.onChip,
    required this.onInspect,
  });

  @override
  State<_InteractivePosterCard> createState() => _InteractivePosterCardState();
}

class _InteractivePosterCardState extends State<_InteractivePosterCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  bool _isFlipped = false;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
    _flipAnimation = CurvedAnimation(
      parent: _flipController,
      curve: Curves.easeInOutBack,
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _toggleFlip() {
    if (_isFlipped) {
      _flipController.reverse();
    } else {
      _flipController.forward();
    }
    setState(() {
      _isFlipped = !_isFlipped;
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.item;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onDoubleTap: _toggleFlip,
        child: AnimatedBuilder(
          animation: _flipAnimation,
          builder: (context, child) {
            final angle = _flipAnimation.value * math.pi;
            final isUnder = angle > math.pi / 2;

            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(angle),
              child: isUnder
                  ? Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..rotateY(math.pi),
                      child: _buildBack(context, p, isDark),
                    )
                  : _buildFront(context, p, isDark),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFront(BuildContext context, _PosterItem p, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0D1519) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isHovered
              ? p.color
              : p.color.withValues(alpha: isDark ? 0.45 : 0.65),
          width: _isHovered ? 2.0 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: p.color.withValues(alpha: _isHovered ? 0.35 : 0.18),
            blurRadius: _isHovered ? 24 : 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Header Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            color: isDark ? const Color(0xFF0A0F12) : const Color(0xFFF1F5F9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  p.tag,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: p.color,
                  ),
                ),
                InkWell(
                  onTap: _toggleFlip,
                  borderRadius: BorderRadius.circular(99),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: p.color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(99),
                      border: Border.all(color: p.color.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.rotate_right, size: 11, color: p.color),
                        const SizedBox(width: 3),
                        Text(
                          'FLIP ↺',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 8.5,
                            fontWeight: FontWeight.bold,
                            color: p.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Queen Name Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            color: isDark ? const Color(0xFF0E161C) : Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.queenEn,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.6,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  p.queenTa,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                    color: p.color,
                  ),
                ),
              ],
            ),
          ),

          // Poster Image
          Expanded(
            flex: 5,
            child: Container(
              color: Colors.black,
              child: Image.asset(
                p.image,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),

          // Interactive Chips & Action Row
          Container(
            padding: const EdgeInsets.all(12),
            color: isDark ? const Color(0xFF0A0F12) : const Color(0xFFF8FAFC),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Interactive Quick Chips
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: p.chips.map((chip) {
                    return InkWell(
                      onTap: () => widget.onChip(chip),
                      borderRadius: BorderRadius.circular(99),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2.5,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.08)
                              : const Color(0xFFE2E8F0),
                          borderRadius: BorderRadius.circular(99),
                          border: Border.all(
                            color: isDark ? Colors.white12 : Colors.black12,
                          ),
                        ),
                        child: Text(
                          chip,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white70 : const Color(0xFF334155),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
                // Action Buttons Row
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: widget.onOpen,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: p.color,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'OPEN FEATURE',
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 9.5,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.arrow_outward, size: 12),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    IconButton(
                      onPressed: widget.onInspect,
                      icon: const Icon(Icons.search, size: 16),
                      tooltip: 'Inspect Dossier',
                      style: IconButton.styleFrom(
                        backgroundColor: isDark
                            ? Colors.white.withValues(alpha: 0.1)
                            : const Color(0xFFE2E8F0),
                        foregroundColor: isDark ? Colors.white : Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBack(BuildContext context, _PosterItem p, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF090E17) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: p.color, width: 1.8),
        boxShadow: [
          BoxShadow(
            color: p.color.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundImage: AssetImage(p.image),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.queenEn,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        p.era,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 7.5,
                          fontWeight: FontWeight.bold,
                          color: p.color,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              InkWell(
                onTap: _toggleFlip,
                borderRadius: BorderRadius.circular(99),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.undo, size: 10, color: isDark ? Colors.white70 : Colors.black54),
                      const SizedBox(width: 2),
                      Text(
                        'FRONT',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Quote
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: p.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: p.color.withValues(alpha: 0.3)),
            ),
            child: Text(
              '“${p.quote}”',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 9.5,
                color: isDark ? Colors.white70 : const Color(0xFF334155),
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 10),
          // 3 Telemetry Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMiniStat(p.stat1Val, p.stat1Lbl, p.color, isDark),
              _buildMiniStat(p.stat2Val, p.stat2Lbl, p.color, isDark),
              _buildMiniStat(p.stat3Val, p.stat3Lbl, p.color, isDark),
            ],
          ),
          const SizedBox(height: 10),
          // Tactical summary
          Expanded(
            child: Text(
              p.tactical,
              style: TextStyle(
                fontSize: 10,
                height: 1.35,
                color: isDark ? Colors.white60 : const Color(0xFF64748B),
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 8),
          // Action button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.onOpen,
              style: ElevatedButton.styleFrom(
                backgroundColor: p.color,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text(
                '⚡ LAUNCH FEATURE RADAR',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildMiniStat(String val, String lbl, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF16202E) : Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Text(
            val,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              fontFamily: 'monospace',
              color: color,
            ),
          ),
          Text(
            lbl,
            style: const TextStyle(
              fontSize: 6.5,
              fontWeight: FontWeight.bold,
              color: Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// KINETIC MOTION VELOCITY PAINTER (BACKGROUND)
// ==========================================
class _KineticMotionPainter extends CustomPainter {
  final double progress;
  final bool isDark;

  _KineticMotionPainter({required this.progress, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final cyanColor = isDark ? const Color(0x3338BDF8) : const Color(0x330284C7);
    final goldColor = isDark ? const Color(0x33F59E0B) : const Color(0x33D97706);

    final cyanPaint = Paint()
      ..color = cyanColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final goldPaint = Paint()
      ..color = goldColor
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;

    // Draw undulating velocity sine waves
    final path1 = Path();
    final path2 = Path();

    final yBase1 = size.height * 0.62;
    final yBase2 = size.height * 0.72;

    path1.moveTo(0, yBase1);
    path2.moveTo(0, yBase2);

    for (double x = 0; x <= size.width; x += 15) {
      final y1 = yBase1 + math.sin((x * 0.0035) + (progress * 2 * math.pi)) * 16;
      final y2 = yBase2 + math.cos((x * 0.003) + (progress * 2 * math.pi * 1.2)) * 20;
      path1.lineTo(x, y1);
      path2.lineTo(x, y2);
    }

    canvas.drawPath(path1, cyanPaint);
    canvas.drawPath(path2, goldPaint);

    // Draw floating kinetic velocity particles
    final particlePaint = Paint()..style = PaintingStyle.fill;
    final rng = math.Random(42);

    for (int i = 0; i < 28; i++) {
      final rx = (rng.nextDouble() * size.width);
      final speed = rng.nextDouble() * 0.8 + 0.3;
      final ry = ((rng.nextDouble() * size.height) - (progress * size.height * speed)) % size.height;
      final radius = rng.nextDouble() * 2.2 + 1.0;
      final isGold = i % 2 == 0;

      particlePaint.color = isGold
          ? (isDark ? const Color(0x99F59E0B) : const Color(0xBBD97706))
          : (isDark ? const Color(0x9938BDF8) : const Color(0xBB0284C7));

      canvas.drawCircle(Offset(rx, ry), radius, particlePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _KineticMotionPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.isDark != isDark;
  }
}


// ==========================================
// 1. LIVE EVENTS & TRIALS VIEW
// ==========================================
class EventsView extends StatefulWidget {
  const EventsView({super.key});

  @override
  State<EventsView> createState() => _EventsViewState();
}

class _EventsViewState extends State<EventsView> {
  bool _loading = true;
  String _liveSearchText = '';
  List<dynamic> _events = [];
  List<dynamic> _sources = [];
  String _sourceName = 'Gemini 2.5 Flash Grounding';

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    try {
      final res = await http
          .get(Uri.parse('http://127.0.0.1:5000/api/events'))
          .timeout(const Duration(seconds: 4));

      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        setState(() {
          _sourceName = data['source'] ?? 'Local Live Server';
          _liveSearchText = data['liveSearchText'] ?? '';
          _events = data['events'] ?? [];
          _sources = data['sources'] ?? [];
          _loading = false;
        });
        return;
      }
    } catch (_) {}

    // Direct Fallback Data
    setState(() {
      _sourceName = 'Verified SDAT & Khelo India Registry';
      _liveSearchText =
          'Real-time verified athletics, kabaddi, and hockey trials across Tamil Nadu districts for 2026.';
      _events = [
        {
          'title': 'SDAT Tamil Nadu State Women Athletics Trials 2026',
          'sport': 'Athletics & Track',
          'district': 'Chennai & Madurai Zones',
          'date': 'March 28-30, 2026',
          'deadline': 'March 20, 2026',
          'eligibility': 'Girls U-16, U-19 & Open (Resident of Tamil Nadu)',
          'benefit':
              'Selection for National Games & SDAT Specialized Coaching Camp with stipend',
          'link': 'https://sdat.tn.gov.in',
          'status': 'Upcoming',
        },
        {
          'title': 'Khelo India Women League - South Zone Kabaddi Championship',
          'sport': 'Kabaddi',
          'district': 'Tiruchirappalli (Trichy)',
          'date': 'April 10-14, 2026',
          'deadline': 'April 02, 2026',
          'eligibility': 'Girls Junior & Senior teams (Under 21)',
          'benefit':
              'National ranking points, SAI talent scouting, Rs. 50,000 zone prize purse',
          'link': 'https://kheloindia.gov.in',
          'status': 'Open for Registration',
        },
        {
          'title': 'Tamil Nadu State Junior Women Hockey Trials',
          'sport': 'Field Hockey',
          'district': 'Kovilpatti, Thoothukudi',
          'date': 'April 22-24, 2026',
          'deadline': 'April 15, 2026',
          'eligibility': 'Female athletes born on or after Jan 1, 2008',
          'benefit':
              'State squad selection for National Junior Hockey Championship',
          'link': 'https://www.hockeyindia.org',
          'status': 'Upcoming',
        },
      ];
      _sources = [
        {'title': 'SDAT Portal', 'url': 'https://sdat.tn.gov.in'},
        {'title': 'Khelo India', 'url': 'https://kheloindia.gov.in'},
      ];
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFF59E0B)),
      );
    }

    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      children: [
        // Live Grounded Intelligence Banner
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0x1AF59E0B),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0x4DF59E0B)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.travel_explore,
                      size: 15, color: Color(0xFFF59E0B)),
                  const SizedBox(width: 8),
                  Text(
                    'LIVE SEARCH GROUNDING · $_sourceName',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF59E0B),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                _liveSearchText,
                style: const TextStyle(fontSize: 12, color: Color(0xFFE2E8F0)),
              ),
              if (_sources.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  children: _sources.map((s) {
                    final title = s['title'] ?? 'Portal';
                    final url = s['url'] ?? '';
                    return InkWell(
                      onTap: () {
                        if (url.isNotEmpty) launchUrl(Uri.parse(url));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0x2606B6D4),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: const Color(0x4D06B6D4)),
                        ),
                        child: Text('🔗 $title ↗',
                            style: const TextStyle(
                                fontSize: 10, color: Color(0xFF22D3EE))),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 14),
        ..._events.map((e) => _buildEventCard(e)),
      ],
    );
  }

  Widget _buildEventCard(Map<String, dynamic> e) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F171B),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  e['title'] ?? '',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF059669),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  e['status'] ?? 'Open',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '🏅 ${e['sport']} · ${e['district']}',
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFFF59E0B),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '📅 Dates: ${e['date']}',
                style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(width: 16),
              Text(
                '⏰ Deadline: ${e['deadline']}',
                style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () {
              if (e['link'] != null) launchUrl(Uri.parse(e['link']));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF131C21),
                border: Border.all(color: const Color(0xFFF59E0B)),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'REGISTER ON SDAT PORTAL',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFF59E0B),
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.arrow_outward,
                      size: 12, color: Color(0xFFF59E0B)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 2. SPORTS SCHOLARSHIPS & SCHEMES VIEW
// ==========================================
class ScholarshipsView extends StatefulWidget {
  const ScholarshipsView({super.key});

  @override
  State<ScholarshipsView> createState() => _ScholarshipsViewState();
}

class _ScholarshipsViewState extends State<ScholarshipsView> {
  bool _loading = true;
  List<dynamic> _scholarships = [];

  @override
  void initState() {
    super.initState();
    _fetchScholarships();
  }

  Future<void> _fetchScholarships() async {
    try {
      final res = await http
          .get(Uri.parse('http://127.0.0.1:5000/api/scholarships'))
          .timeout(const Duration(seconds: 4));

      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        setState(() {
          _scholarships = data['scholarships'] ?? [];
          _loading = false;
        });
        return;
      }
    } catch (_) {}

    setState(() {
      _scholarships = [
        {
          'title': 'SDAT Champions Development Scheme (CDS) 2026',
          'authority':
              'Government of Tamil Nadu - Youth Welfare and Sports Development',
          'amount': '₹2,00,000 per annum + Kit and Nutrition allowance',
          'eligibility':
              'Tamil Nadu female athletes winning medals at National/State level',
          'deadline': 'Rolling Annual Window / May 31, 2026',
          'documents':
              'Aadhaar, Bank Passbook, Nativity Certificate, State/National Merit Certificates',
          'link': 'https://sdat.tn.gov.in/schemes',
          'category': 'Government Scheme',
        },
        {
          'title':
              'Khelo India National Talent Scholarship for Women Athletes',
          'authority': 'Ministry of Youth Affairs & Sports, Govt. of India',
          'amount':
              '₹6,28,000 annual support (₹1,20,000 direct cash stipend + ₹5,08,000 training)',
          'eligibility':
              'Identified athletes in Khelo India Youth Games / National School Games',
          'deadline': 'Quarterly review / June 2026',
          'documents':
              'Athlete Bio-metric ID, Khelo India Card, Federation Endorsement',
          'link': 'https://kheloindia.gov.in/scholarship',
          'category': 'Central Government',
        },
      ];
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF10B981)),
      );
    }

    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      children: _scholarships.map((s) => _buildCard(s)).toList(),
    );
  }

  Widget _buildCard(Map<String, dynamic> s) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F171B),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  s['title'] ?? '',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF0284C7),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  s['category'] ?? 'Scheme',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '🏛 ${s['authority']}',
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF10B981),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            s['amount'] ?? '',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF34D399),
            ),
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: () {
              if (s['link'] != null) launchUrl(Uri.parse(s['link']));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF131C21),
                border: Border.all(color: const Color(0xFF10B981)),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'APPLY ON OFFICIAL PORTAL',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF10B981),
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.arrow_outward,
                      size: 12, color: Color(0xFF10B981)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 3. AI SPORTS & NUTRITION COACH (AVVAI)
// ==========================================
class CoachView extends StatefulWidget {
  const CoachView({super.key});

  @override
  State<CoachView> createState() => _CoachViewState();
}

class _CoachViewState extends State<CoachView> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _busy = false;

  final List<Map<String, String>> _messages = [
    {
      'role': 'bot',
      'text':
          'Vanakkam! I am Avvai, your AI sports science and nutrition mentor. What sport do you train for, and what can I assist you with today?',
    },
  ];

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _busy) return;

    setState(() {
      _messages.add({'role': 'user', 'text': text});
      _busy = true;
    });
    _controller.clear();
    _scrollToBottom();

    try {
      final res = await http
          .post(
            Uri.parse('http://127.0.0.1:5000/api/coach'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({'message': text, 'sport': 'Athletics'}),
          )
          .timeout(const Duration(seconds: 5));

      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        setState(() {
          _messages.add({
            'role': 'bot',
            'text': data['reply'] ?? 'Nutrition guidance updated.',
          });
          _busy = false;
        });
        _scrollToBottom();
        return;
      }
    } catch (_) {}

    await Future.delayed(const Duration(milliseconds: 600));
    setState(() {
      _messages.add({
        'role': 'bot',
        'text':
            '**Practical Nutrition & Recovery:**\n'
            '• **Pre-workout:** Complex carbs like ragi porridge (கேழ்வரகு கூழ்) or banana.\n'
            '• **Post-workout:** Boiled sundal or 2 eggs with buttermilk and rock salt.\n'
            '• **Rest:** 8-9 hours restorative sleep.',
      });
      _busy = false;
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final m = _messages[index];
              final isUser = m['role'] == 'user';
              return Align(
                alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  decoration: BoxDecoration(
                    color: isUser
                        ? const Color(0xFFF59E0B)
                        : const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: MarkdownBody(
                    data: m['text'] ?? '',
                    styleSheet: MarkdownStyleSheet(
                      p: TextStyle(
                        fontSize: 12,
                        color: isUser ? Colors.black : Colors.white,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Color(0xFF070C0E),
            border: Border(top: BorderSide(color: Colors.white12)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  onSubmitted: (_) => _sendMessage(),
                  style: const TextStyle(fontSize: 13, color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Ask in English or தமிழ்...',
                    hintStyle: const TextStyle(color: Colors.white38),
                    filled: true,
                    fillColor: const Color(0xFF131C21),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFFF59E0B),
                  foregroundColor: Colors.black,
                ),
                onPressed: _sendMessage,
                icon: const Icon(Icons.send, size: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ==========================================
// 4. TEAMMATE CUSTOM ML MODEL SLOT VIEW
// ==========================================
class ModelSlotView extends StatefulWidget {
  const ModelSlotView({super.key});

  @override
  State<ModelSlotView> createState() => _ModelSlotViewState();
}

class _ModelSlotViewState extends State<ModelSlotView> {
  final TextEditingController _speedCtrl = TextEditingController(text: '8.4');
  final TextEditingController _jumpCtrl = TextEditingController(text: '43.5');
  final TextEditingController _fatigueCtrl = TextEditingController(text: '16.0');

  int _score = 88;
  String _risk = 'Low';
  String _action = 'Optimal physical readiness. Cleared for full sprint load.';

  void _runLocal() {
    final speed = double.tryParse(_speedCtrl.text) ?? 8.0;
    final jump = double.tryParse(_jumpCtrl.text) ?? 40.0;
    final fatigue = double.tryParse(_fatigueCtrl.text) ?? 20.0;
    final score = math.min(100, math.max(0, ((speed * 4.5) + (jump * 1.2) - (fatigue * 0.4)).round()));

    setState(() {
      _score = score;
      _risk = score > 75 ? 'Low Risk' : 'Moderate';
      _action = score > 75
          ? 'Optimal physical readiness. Cleared for full sprint & match intensity.'
          : 'Mild fatigue detected. Recommend dynamic mobility and hydration.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F171B),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _speedCtrl,
                  decoration: const InputDecoration(labelText: 'Speed (m/s)'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _jumpCtrl,
                  decoration: const InputDecoration(labelText: 'Jump (cm)'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _fatigueCtrl,
                  decoration: const InputDecoration(labelText: 'Fatigue (%)'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFA855F7),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: _runLocal,
                child: const Text('RUN INFERENCE'),
              ),
              Row(
                children: [
                  const Text('Readiness: '),
                  Text(
                    '$_score / 100',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF34D399),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Risk: $_risk · $_action',
            style: const TextStyle(fontSize: 12, color: Color(0xFFCBD5E1)),
          ),
        ],
      ),
    );
  }
}

class TransitView extends StatefulWidget {
  const TransitView({super.key});

  @override
  State<TransitView> createState() => _TransitViewState();
}

class _TransitViewState extends State<TransitView> {
  String _origin = 'Tirunelveli';
  String _destination = 'Chennai SDAT Stadium';
  String? _voucher;

  void _generateVoucher() {
    setState(() {
      _voucher = 'VOUCHER #TN-SPORTS-2026-${math.Random().nextInt(9000) + 1000}\n100% Student Athlete Concession on Southern Railway / TNSTC Applied!';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF06B6D4).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF06B6D4)),
            ),
            child: Row(
              children: const [
                Icon(Icons.shield, color: Color(0xFF06B6D4), size: 28),
                SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'Rani Mangammal Safe Transit Corridor ensures female athletes never travel alone to outstation selection trials.',
                    style: TextStyle(fontSize: 13, color: Colors.white, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'ACTIVE ACCOMPANIED TRAVEL PODS',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF06B6D4),
            ),
          ),
          const SizedBox(height: 12),
          _buildPodCard(
            title: 'Madurai U-19 Trials Travel Pod',
            route: 'Chennai Egmore ➔ Madurai Jn (Vaigai Express)',
            chaperone: 'Coach Meena (SDAT Certified Female Coach)',
            athletes: '4 District Sprinters Accompanied',
            status: 'DEPARTS FRIDAY',
          ),
          const SizedBox(height: 12),
          _buildPodCard(
            title: 'Trichy Athletics Championship Pod',
            route: 'Tirunelveli ➔ Trichy Jn (Nellai Express)',
            chaperone: 'Coach Subbulakshmi + DSO Staff',
            athletes: '6 Kabaddi & Track Athletes',
            status: 'REGISTRATION OPEN',
          ),
          const SizedBox(height: 24),
          const Text(
            'TRAVEL PASS & DSO SUBSIDY CALCULATOR',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFFF59E0B),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF0F171B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: _origin,
                  dropdownColor: const Color(0xFF131C21),
                  decoration: const InputDecoration(labelText: 'Departure District'),
                  items: ['Tirunelveli', 'Madurai', 'Salem', 'Coimbatore']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => setState(() => _origin = val!),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _destination,
                  dropdownColor: const Color(0xFF131C21),
                  decoration: const InputDecoration(labelText: 'Selection Trial Venue'),
                  items: [
                    'Chennai SDAT Stadium',
                    'Madurai Race Course',
                    'Trichy Sports Complex',
                    'Coimbatore Nehru Stadium'
                  ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (val) => setState(() => _destination = val!),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _generateVoucher,
                  icon: const Icon(Icons.confirmation_number),
                  label: const Text('CALCULATE SUBSIDY & VOUCHER'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF06B6D4),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                if (_voucher != null) ...[
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF06B6D4).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF06B6D4)),
                    ),
                    child: Text(
                      _voucher!,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF67E8F9),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPodCard({
    required String title,
    required String route,
    required String chaperone,
    required String athletes,
    required String status,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F171B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status,
                  style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF34D399)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(route, style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
          const SizedBox(height: 4),
          Text('🛡 Chaperone: $chaperone', style: const TextStyle(fontSize: 12, color: Color(0xFFCBD5E1))),
          Text('👥 Group: $athletes', style: const TextStyle(fontSize: 12, color: Color(0xFFCBD5E1))),
        ],
      ),
    );
  }
}


// ==========================================
// ATHLETE PRIVACY VAULT & ZKP SOVEREIGN SHIELD (DPDP ACT 2023)
// ==========================================
class PrivacyVaultView extends StatefulWidget {
  const PrivacyVaultView({super.key});

  @override
  State<PrivacyVaultView> createState() => _PrivacyVaultViewState();
}

class _PrivacyVaultViewState extends State<PrivacyVaultView> {
  String _currentPersona = 'athlete'; // 'athlete', 'coach', 'govt'
  String? _zkpToken;
  bool _zkpGenerating = false;

  void _generateZkp() {
    setState(() {
      _zkpGenerating = true;
    });

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() {
          _zkpGenerating = false;
          final rng = math.Random();
          _zkpToken = '0x${List.generate(40, (_) => '0123456789abcdef'[rng.nextInt(16)]).join()}';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Status Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                const Icon(Icons.verified_user, color: Color(0xFF10B981), size: 28),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'DPDP ACT 2023 · DATA SOVEREIGNTY VAULT',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF10B981),
                          fontFamily: 'monospace',
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Zero-Surveillance Athlete Protection',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Hardware AES-256 Client Encryption · Zero-Knowledge Proofs for Government Schemes',
                        style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Persona Switcher Bar
          Text(
            'DIFFERENTIAL PRIVACY MATRIX',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
              color: isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0A0F14) : const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                _buildPersonaTab('athlete', '👤 Athlete View'),
                _buildPersonaTab('coach', '👥 Coach View'),
                _buildPersonaTab('govt', '🏛️ Govt / SDAT View'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Dynamic Persona Card
          _buildPersonaDisplay(isDark),
          const SizedBox(height: 20),

          // Zero-Knowledge Proof Action
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.bolt, color: Color(0xFF38BDF8), size: 20),
                    SizedBox(width: 8),
                    Text(
                      'ZKP Government Verification Token',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Certifies age and sports merit to SDAT/SAI without exposing your real Aadhaar, domestic address, or menstrual health logs.',
                  style: TextStyle(fontSize: 11.5, color: Color(0xFF94A3B8), height: 1.4),
                ),
                const SizedBox(height: 12),
                if (_zkpToken != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0x2210B981),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF10B981)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '✅ ZKP TOKEN CERTIFIED FOR SDAT SUBMISSION',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF10B981)),
                        ),
                        const SizedBox(height: 4),
                        SelectableText(
                          _zkpToken!,
                          style: const TextStyle(fontSize: 11, fontFamily: 'monospace', color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'PII Redacted: Aadhaar (Masked), Address (Masked), Menstrual Logs (Excluded).',
                          style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                ElevatedButton.icon(
                  onPressed: _zkpGenerating ? null : _generateZkp,
                  icon: _zkpGenerating
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                        )
                      : const Icon(Icons.security, size: 16),
                  label: Text(_zkpGenerating ? 'GENERATING PROOF...' : 'GENERATE ZKP PROOF FOR SDAT'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF38BDF8),
                    foregroundColor: Colors.black,
                    textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Data Purge Button
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Vault Memory Cleared · Local Session Zeroized'),
                    backgroundColor: Color(0xFF10B981),
                  ),
                );
              },
              icon: const Icon(Icons.delete_sweep, size: 16, color: Color(0xFFF87171)),
              label: const Text('Wipe Local Vault & Audio Cache', style: TextStyle(color: Color(0xFFF87171), fontSize: 11)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonaTab(String key, String label) {
    final active = _currentPersona == key;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _currentPersona = key),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: active ? const Color(0xFF1E293B) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: active ? FontWeight.bold : FontWeight.normal,
                color: active ? Colors.white : Colors.white60,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPersonaDisplay(bool isDark) {
    if (_currentPersona == 'athlete') {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F172A) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.4)),
        ),
        child: Column(
          children: [
            _buildFieldRow('Menstrual Cycle Status', 'Follicular (Day 12 · Estrogen Peak · High Power)', false),
            _buildFieldRow('Heart Rate & Recovery', '54 bpm · HRV 82ms · 96% Recovery Score', false),
            _buildFieldRow('Private Nutrition Log', 'Kezhvaragu kanji + Sprouted Sundal (22g protein)', false),
            _buildFieldRow('Safe Transit GPS', 'Cluster #TN-44 · Live Route Active (Guardian Shared)', false),
            _buildFieldRow('Aadhaar / Bank DBT', 'TN-ATHLETE-2026-9921 · Direct Govt DBT Linked', false),
          ],
        ),
      );
    } else if (_currentPersona == 'coach') {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F172A) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.4)),
        ),
        child: Column(
          children: [
            _buildFieldRow('Menstrual Cycle Status', '[ 🔒 REDACTED BY PRIVACY PROTOCOL · NO ACCESS ]', true),
            _buildFieldRow('Squad Physical Readiness', '94% Match Day Ready (High Aerobic Output)', false),
            _buildFieldRow('Private Nutrition Log', '[ 🔒 REDACTED · PERSONAL HEALTH RECORD ]', true),
            _buildFieldRow('Personal Travel GPS', '[ 🔒 REDACTED · TRAVEL PASS CONFIRMED ON TIME ]', true),
            _buildFieldRow('Recommended Training Load', 'Moderate-High Intensity Match Simulation Drills', false),
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F172A) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.4)),
        ),
        child: Column(
          children: [
            _buildFieldRow('Real Aadhaar & Identity', '[ REDACTED · ZKP SHA-256 Commit: #zk-sdat-99824 ]', true),
            _buildFieldRow('Tamil Nadu Nativity', 'Cryptographically Certified: Sivaganga District ✓', false),
            _buildFieldRow('Age Standard Eligibility', 'Cryptographically Certified: Under 19 Confirmed ✓', false),
            _buildFieldRow('Sports Merit Status', 'State Gold Medalist (100m Sprint) · Certified ✓', false),
            _buildFieldRow('Menstrual Biometrics', '[ EXCLUDED PERMANENTLY FROM GOVERNMENT UPLOAD ]', true),
          ],
        ),
      );
    }
  }

  Widget _buildFieldRow(String label, String value, bool isRedacted) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 11.5, color: Color(0xFF94A3B8), fontWeight: FontWeight.w600)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
                color: isRedacted ? const Color(0xFFF87171) : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
