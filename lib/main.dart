import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'veera_services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeVeeraCloud();
  runApp(const VeeramangaiApp());
}

class VeeramangaiApp extends StatefulWidget {
  const VeeramangaiApp({super.key});

  @override
  State<VeeramangaiApp> createState() => _VeeramangaiAppState();
}

class _VeeramangaiAppState extends State<VeeramangaiApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void _toggleTheme() {
    setState(
      () => _themeMode = _themeMode == ThemeMode.dark
          ? ThemeMode.light
          : ThemeMode.dark,
    );
  }

  ThemeData _theme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    const darkInk = Color(0xFFF4FAF8);
    const lightInk = Color(0xFF20202B);
    const bronze = Color(0xFFFBCFE8);
    const lightBronze = Color(0xFF9C4777);
    final scheme = ColorScheme.fromSeed(
      seedColor: bronze,
      brightness: brightness,
      primary: isDark ? bronze : lightBronze,
      onPrimary: isDark ? const Color(0xFF1B1720) : Colors.white,
      secondary: isDark ? const Color(0xFF6AD7C4) : const Color(0xFF087E72),
      tertiary: isDark ? const Color(0xFF83AFFF) : const Color(0xFF456F9B),
      surface: isDark ? const Color(0xFF101B28) : const Color(0xFFFFFDFC),
      onSurface: isDark ? darkInk : lightInk,
      onSurfaceVariant: isDark
          ? const Color(0xFFB4B3BD)
          : const Color(0xFF646575),
      outline: isDark ? const Color(0xFF494A57) : const Color(0xFFB9B7C2),
      outlineVariant: isDark
          ? const Color(0xFF323443)
          : const Color(0xFFDDDAE1),
    );
    final ink = isDark ? darkInk : lightInk;
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      fontFamily: 'Raleway',
      scaffoldBackgroundColor: isDark
          ? const Color(0xFF06130F)
          : const Color(0xFFF4F8F5),
      appBarTheme: AppBarTheme(
        backgroundColor: isDark
            ? const Color(0xFF06130F)
            : const Color(0xFFF4F8F5),
        foregroundColor: ink,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: scheme.outlineVariant.withValues(alpha: .72)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? const Color(0xFF151E3B) : const Color(0xFFF7F6FC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(
            color: scheme.outlineVariant.withValues(alpha: .5),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isDark
            ? const Color(0xFF091A15)
            : const Color(0xFFF4F8F5),
        indicatorColor: scheme.primary.withValues(alpha: .17),
        elevation: 0,
        height: 72,
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 10, letterSpacing: .25),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: isDark ? const Color(0xFFFBCFE8) : lightBronze,
          foregroundColor: isDark ? const Color(0xFF20101A) : Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: isDark
            ? const Color(0xFF1B1D2A)
            : const Color(0xFFFFFDFC),
        side: BorderSide(color: scheme.outlineVariant.withValues(alpha: .85)),
        labelStyle: TextStyle(color: ink, fontSize: 11),
        shape: const StadiumBorder(),
      ),
    );
    final text = base.textTheme.apply(bodyColor: ink, displayColor: ink);
    const editorialFallback = ['serif'];
    return base.copyWith(
      textTheme: text.copyWith(
        headlineMedium: text.headlineMedium?.copyWith(
          fontFamily: 'Merriweather',
          fontFamilyFallback: editorialFallback,
          fontSize: 39,
          height: 1.02,
          letterSpacing: -1.25,
          fontWeight: FontWeight.w400,
          color: ink,
        ),
        headlineSmall: text.headlineSmall?.copyWith(
          fontFamily: 'Merriweather',
          fontFamilyFallback: editorialFallback,
          fontSize: 31,
          height: 1.04,
          letterSpacing: -.8,
          fontWeight: FontWeight.w400,
          color: ink,
        ),
        titleLarge: text.titleLarge?.copyWith(
          fontFamily: 'Merriweather',
          fontFamilyFallback: editorialFallback,
          fontWeight: FontWeight.w500,
          color: ink,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VEERAMANGAI',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: _theme(Brightness.light),
      darkTheme: _theme(Brightness.dark),
      home: MainShell(onToggleTheme: _toggleTheme, themeMode: _themeMode),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({
    super.key,
    required this.onToggleTheme,
    required this.themeMode,
  });
  final VoidCallback onToggleTheme;
  final ThemeMode themeMode;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> with TickerProviderStateMixin {
  int _index = 0;
  bool _showIntro = true;
  Timer? _introTimer;
  String? _signal;
  bool _allowAiProcessing = false;
  bool _thinking = false;
  final List<ChatMessage> _messages = [
    ChatMessage(
      text:
          'Vanakkam, Priyadharsini! I can help you pursue an opportunity, organize an application, plan a trip, or reach your support circle.',
      fromUser: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _introTimer = Timer(const Duration(milliseconds: 3400), () {
      if (mounted) setState(() => _showIntro = false);
    });
  }

  @override
  void dispose() {
    _introTimer?.cancel();
    super.dispose();
  }

  Future<void> _ask(String question) async {
    setState(() {
      _index = 2;
      _messages.add(ChatMessage(text: question, fromUser: true));
      _thinking = true;
    });
    final reply = await VeeraServices.ask(
      question,
      allowCloud: _allowAiProcessing,
    );
    if (!mounted) return;
    setState(() {
      _thinking = false;
      _messages.add(
        ChatMessage(text: reply.text, fromUser: false, source: reply.source),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (_showIntro) {
      return CinematicIntro(
        onFinish: () {
          _introTimer?.cancel();
          if (mounted) setState(() => _showIntro = false);
        },
      );
    }
    final pages = [
      _home(context),
      _opportunities(context),
      _veera(context),
      _team(context),
    ];
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 18,
        title: const BrandLockup(),
        actions: [
          IconButton(
            tooltip: isDark ? 'Switch to light mode' : 'Switch to dark mode',
            onPressed: widget.onToggleTheme,
            icon: Icon(
              isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 17,
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              child: Text(
                'P',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(painter: const PageAtmospherePainter()),
            ),
          ),
          SafeArea(
            top: false,
            child: IndexedStack(index: _index, children: pages),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined),
            selectedIcon: Icon(Icons.auto_awesome),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.forum_outlined),
            selectedIcon: Icon(Icons.forum_rounded),
            label: 'Veera',
          ),
          NavigationDestination(
            icon: Icon(Icons.groups_outlined),
            selectedIcon: Icon(Icons.groups_rounded),
            label: 'Team',
          ),
        ],
      ),
    );
  }

  Widget _home(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(18, 10, 18, 28),
    children: [
      const Center(child: Eyebrow('A PATHWAY FOR EVERY GIRL IN SPORT')),
      const SizedBox(height: 17),
      const Center(child: WebsiteSigil()),
      const SizedBox(height: 15),
      Text.rich(
        TextSpan(
          children: [
            const TextSpan(text: 'Every goal has\n'),
            TextSpan(
              text: 'a team behind it.',
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF797B8C)
                    : const Color(0xFF868594),
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      const SizedBox(height: 12),
      Text(
        'Meet your next opportunity with a clear plan and a support circle in your corner.',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          height: 1.65,
        ),
      ),
      const SizedBox(height: 22),
      GradientPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Eyebrow('YOUR NEXT OPPORTUNITY'),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const OpportunityIcon(icon: Icons.emoji_events_outlined),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'District U19 Kabaddi Trials',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Chengalpattu · 16 Nov · Apply by 12 Nov',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Tag(text: 'SAMPLE · VERIFY SOURCE'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            FilledButton.icon(
              onPressed: () => _ask('Help me plan for the district trials'),
              icon: const Icon(Icons.arrow_forward, size: 17),
              label: const Text('Make a plan'),
            ),
          ],
        ),
      ),
      const SizedBox(height: 22),
      SectionTitle(title: 'Your next steps', trailing: '2 of 5 ready'),
      const SizedBox(height: 9),
      const SurfaceCard(
        child: Column(
          children: [
            ChecklistRow(
              done: true,
              title: 'Review the trial notice',
              subtitle: 'Example content only',
            ),
            ChecklistRow(
              done: false,
              title: 'Prepare athlete details',
              subtitle: 'About 5 minutes',
            ),
            ChecklistRow(
              done: false,
              title: 'Plan travel & request support',
              subtitle: 'Veera can help estimate costs',
            ),
          ],
        ),
      ),
      const SizedBox(height: 22),
      SectionTitle(title: 'Your pathway guide', trailing: 'Tamil + English'),
      const SizedBox(height: 9),
      SurfaceCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                VeeraAvatar(),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Veera',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        'Find · plan · follow through',
                        style: TextStyle(fontSize: 11),
                      ),
                    ],
                  ),
                ),
                Tag(text: 'READY'),
              ],
            ),
            const SizedBox(height: 13),
            Text(
              'Vanakkam, Priyadharsini! Want help checking the trial deadline, preparing an application, or planning the trip?',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 13),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ActionChip(
                  label: const Text('Plan my application'),
                  onPressed: () => _ask('Help me plan for the district trials'),
                ),
                ActionChip(
                  label: const Text('Plan travel support'),
                  onPressed: () =>
                      _ask('Help me plan travel cost for the trials'),
                ),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(height: 14),
      SectionTitle(
        title: 'Private check-in',
        trailing: 'Your reason stays yours',
      ),
      const SizedBox(height: 8),
      SurfaceCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('How are you feeling about practice today?'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 7,
              runSpacing: 7,
              children: [
                _signalChip(context, 'Ready'),
                _signalChip(context, 'Go gently'),
                _signalChip(context, 'Need support'),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Coach sees only the session guidance needed to support you.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            if (_signal != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Saved privately: $_signal',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
          ],
        ),
      ),
      const SizedBox(height: 15),
      const Center(
        child: Text(
          'Concept demo · Sample opportunity details · No real requests are sent',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 10),
        ),
      ),
    ],
  );

  Widget _signalChip(BuildContext context, String label) => ChoiceChip(
    label: Text(label),
    selected: _signal == label,
    onSelected: (_) => setState(() => _signal = label),
  );

  Widget _opportunities(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
    children: [
      const Eyebrow('DISCOVER & GROW'),
      const SizedBox(height: 7),
      Text(
        'Opportunities for your game.',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -.7,
        ),
      ),
      const SizedBox(height: 7),
      Text(
        'Source-linked listings, with the steps and support to pursue them.',
        style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
      const SizedBox(height: 17),
      _opportunityDirectory(),
      const SizedBox(height: 14),
      const Eyebrow('IDEATHON EXAMPLE LISTINGS · NOT LIVE'),
      const SizedBox(height: 8),
      OpportunityCard(
        title: 'District U19 Kabaddi Trials',
        subtitle: 'Chengalpattu · 16 Nov · Apply by 12 Nov',
        tag: 'SAMPLE ONLY',
        icon: Icons.emoji_events_outlined,
        onTap: () => _ask('Help me plan for the district trials'),
      ),
      const SizedBox(height: 11),
      OpportunityCard(
        title: 'Emerging Athletes Travel Fund',
        subtitle:
            'Support for approved competitions; coordinator review required.',
        tag: 'SAMPLE ONLY',
        icon: Icons.train_outlined,
        onTap: () => _ask('Help me plan travel support for an event'),
      ),
      const SizedBox(height: 11),
      OpportunityCard(
        title: 'Women in Sport Skills Camp',
        subtitle: 'Sample listing · Ask your mentor for the official notice.',
        tag: 'SAMPLE LISTING',
        icon: Icons.stars_outlined,
        onTap: () => _ask('How can I check if the skills camp is open?'),
      ),
      const SizedBox(height: 15),
      const PrivacyNote(
        text:
            'Veera can organize a checklist and prepare drafts. You review every request before it is shared.',
      ),
    ],
  );

  Widget _opportunityDirectory() => FutureBuilder<List<Map<String, dynamic>>>(
    future: VeeraServices.fetchOpportunities(),
    builder: (context, snapshot) {
      if (!veeraCloudConfigured) {
        return const PrivacyNote(
          text:
              'Live directory is not connected. Current schemes, funding, and event dates are not shown as verified.',
        );
      }
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(),
          ),
        );
      }
      final rows = snapshot.data ?? const <Map<String, dynamic>>[];
      if (rows.isEmpty)
        return const PrivacyNote(
          text:
              'No currently verified listings are available. Check again later or ask your district sports office.',
        );
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Eyebrow('CURRENT VERIFIED LISTINGS'),
          const SizedBox(height: 8),
          for (final row in rows) ...[
            OpportunityCard(
              title: (row['title'] as String?) ?? 'Opportunity',
              subtitle:
                  [
                        row['sport'],
                        row['district'],
                        row['deadline'] == null
                            ? null
                            : 'Apply by ${row['deadline']}',
                        row['source_name'],
                      ]
                      .whereType<String>()
                      .where((part) => part.isNotEmpty)
                      .join(' · '),
              tag: (row['kind'] as String? ?? 'OPPORTUNITY')
                  .replaceAll('_', ' ')
                  .toUpperCase(),
              icon: Icons.open_in_new_rounded,
              onTap: () => showDialog<void>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(
                    (row['title'] as String?) ?? 'Opportunity details',
                  ),
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (row['eligibility'] != null)
                          Text('Eligibility: ${row['eligibility']}'),
                        if (row['benefit'] != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text('Support: ${row['benefit']}'),
                          ),
                        const SizedBox(height: 12),
                        Text('Source: ${row['source_name'] ?? 'Provider'}'),
                        SelectableText((row['source_url'] as String?) ?? ''),
                        if (row['verified_at'] != null)
                          Text('Checked: ${row['verified_at']}'),
                        const SizedBox(height: 10),
                        const Text(
                          'Confirm eligibility and current terms with the provider before applying.',
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ],
      );
    },
  );

  Widget _veera(BuildContext context) => Column(
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 10),
        child: Row(
          children: [
            const VeeraAvatar(),
            const SizedBox(width: 10),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Veera',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  Text(
                    'Athlete pathway guide · Tamil + English',
                    style: TextStyle(fontSize: 11),
                  ),
                ],
              ),
            ),
            Tag(text: veeraCloudConfigured ? 'VEERA AI' : 'OFFLINE GUIDE'),
          ],
        ),
      ),
      const Divider(height: 1),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 2),
        child: SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          dense: true,
          value: _allowAiProcessing,
          onChanged: (value) => setState(() => _allowAiProcessing = value),
          title: const Text(
            'Allow this chat to use AI',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
          subtitle: Text(
            'Off by default · Only a general task intent goes to AI, never your typed message. Health screening is best-effort.',
            style: TextStyle(
              fontSize: 10,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
      Expanded(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            for (final message in _messages) MessageBubble(message: message),
            if (_thinking)
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('Veera is checking…'),
                ),
              ),
            if (_messages.length <= 1)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Wrap(
                  spacing: 7,
                  runSpacing: 6,
                  children: [
                    ActionChip(
                      label: const Text('Plan my trial application'),
                      onPressed: () =>
                          _ask('Help me plan for the district trials'),
                    ),
                    ActionChip(
                      label: const Text('Estimate trip & support'),
                      onPressed: () =>
                          _ask('Help me plan travel cost for the trials'),
                    ),
                    ActionChip(
                      label: const Text('Draft a coach message'),
                      onPressed: () => _ask(
                        'Draft a message asking my coach to confirm eligibility',
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 12),
            const PrivacyNote(
              text:
                  'Veera can prepare plans and drafts. Nothing is sent without your review. It does not diagnose or make training decisions.',
            ),
          ],
        ),
      ),
      ChatComposer(onSend: _ask),
    ],
  );

  Widget _team(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
    children: [
      const Eyebrow('TEAM WORKSPACE · SAMPLE DATA'),
      const SizedBox(height: 7),
      Text(
        'Support the athlete’s plan.',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -.7,
        ),
      ),
      const SizedBox(height: 7),
      Text(
        'Coaches see the session guidance needed to support the squad.',
        style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
      const SizedBox(height: 15),
      const PrivacyNote(
        text:
            'Private reasons are hidden. Offer a choice, follow up with care, and let the athlete decide what to share.',
      ),
      const SizedBox(height: 13),
      const RosterTile(
        initials: 'P',
        name: 'Priyadharsini',
        plan: 'Technique drills offered',
        status: 'Ready',
      ),
      const SizedBox(height: 8),
      const RosterTile(
        initials: 'AK',
        name: 'Ananya K.',
        plan: 'Low-impact option offered',
        status: 'Adjusted',
      ),
      const SizedBox(height: 8),
      const RosterTile(
        initials: 'SK',
        name: 'Sandhiya K.',
        plan: 'Standard practice',
        status: 'Ready',
      ),
      const SizedBox(height: 8),
      const RosterTile(
        initials: 'NV',
        name: 'Nila V.',
        plan: 'Private follow-up offered',
        status: 'Check in',
      ),
      const SizedBox(height: 14),
      const SurfaceCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Suggested session',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 6),
            Text(
              'Offer technique-focused drills as an option. The athlete can accept, change, or decline the plan.',
            ),
          ],
        ),
      ),
    ],
  );
}

class CinematicIntro extends StatefulWidget {
  const CinematicIntro({super.key, required this.onFinish});
  final VoidCallback onFinish;

  @override
  State<CinematicIntro> createState() => _CinematicIntroState();
}

class WebsiteSigil extends StatelessWidget {
  const WebsiteSigil({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bronze = isDark ? const Color(0xFF6AD7C4) : const Color(0xFF087E72);
    return SizedBox(
      width: 94,
      height: 94,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size.square(94),
            painter: SigilPainter(bronze: bronze),
          ),
          Text(
            'வ',
            style: TextStyle(
              color: bronze,
              fontSize: 28,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class SigilPainter extends CustomPainter {
  const SigilPainter({required this.bronze});
  final Color bronze;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = bronze.withValues(alpha: .27);
    canvas.drawCircle(center, size.width * .48, ring);
    for (final angle in [-.38, .48]) {
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(angle);
      canvas.drawOval(
        Rect.fromCenter(center: Offset.zero, width: 59, height: 22),
        ring..color = bronze.withValues(alpha: .19),
      );
      canvas.restore();
    }
    final glow = Paint()
      ..shader = RadialGradient(
        colors: [bronze.withValues(alpha: .11), Colors.transparent],
      ).createShader(Rect.fromCircle(center: center, radius: size.width * .45));
    canvas.drawCircle(center, size.width * .45, glow);
  }

  @override
  bool shouldRepaint(covariant SigilPainter oldDelegate) =>
      oldDelegate.bronze != bronze;
}

class PageAtmospherePainter extends CustomPainter {
  const PageAtmospherePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final warm = Paint()
      ..shader =
          RadialGradient(
            colors: [
              const Color(0xFF0B8A78).withValues(alpha: .20),
              Colors.transparent,
            ],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * .12, size.height * .18),
              radius: size.width * .8,
            ),
          );
    canvas.drawRect(rect, warm);
    final cool = Paint()
      ..shader =
          RadialGradient(
            colors: [
              const Color(0xFF235FA9).withValues(alpha: .14),
              Colors.transparent,
            ],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * .95, size.height * .74),
              radius: size.width * .66,
            ),
          );
    canvas.drawRect(rect, cool);
    for (var wave = 0; wave < 3; wave++) {
      final baseline = size.height * (.77 + wave * .055);
      final path = Path()..moveTo(0, baseline);
      for (var x = 0.0; x <= size.width; x += 16) {
        final y = baseline + math.sin(x / size.width * 5 + wave) * 8;
        path.lineTo(x, y);
      }
      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = .7
          ..color = const Color(0xFF68D9C4).withValues(alpha: .055),
      );
    }
    for (var i = 0; i < 14; i++) {
      final x = size.width * (((i * .6180339) % 1) * .9 + .05);
      final y = size.height * (((i * .371) % 1) * .67 + .08);
      canvas.drawCircle(
        Offset(x, y),
        1,
        Paint()..color = const Color(0xFFFBCFE8).withValues(alpha: .24),
      );
    }
  }

  @override
  bool shouldRepaint(covariant PageAtmospherePainter oldDelegate) => false;
}

class _CinematicIntroState extends State<CinematicIntro>
    with TickerProviderStateMixin {
  late final AnimationController _motion;
  late final AnimationController _reveal;

  @override
  void initState() {
    super.initState();
    _motion = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
    _reveal = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2100),
    )..forward();
  }

  @override
  void dispose() {
    _motion.dispose();
    _reveal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF06130F),
    body: Stack(
      children: [
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _motion,
            builder: (context, _) =>
                CustomPaint(painter: ForgePainter(_motion.value)),
          ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF06130F).withValues(alpha: .10),
                  const Color(0xFF06130F).withValues(alpha: .35),
                  const Color(0xFF06130F),
                ],
              ),
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 20, 25, 24),
            child: Column(
              children: [
                const Align(alignment: Alignment.topLeft, child: BrandLockup()),
                const Spacer(flex: 3),
                AnimatedBuilder(
                  animation: _reveal,
                  builder: (context, _) => _staggeredWordmark(),
                ),
                const SizedBox(height: 17),
                FadeTransition(
                  opacity: CurvedAnimation(
                    parent: _reveal,
                    curve: const Interval(.45, 1, curve: Curves.easeOut),
                  ),
                  child: SlideTransition(
                    position:
                        Tween(
                          begin: const Offset(0, .22),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: _reveal,
                            curve: const Interval(
                              .45,
                              1,
                              curve: Curves.easeOutCubic,
                            ),
                          ),
                        ),
                    child: Text(
                      'EVERY GOAL HAS A TEAM',
                      style: TextStyle(
                        color: const Color(0xFFE8DCCB).withValues(alpha: .8),
                        fontSize: 10,
                        letterSpacing: 3.1,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 11),
                FadeTransition(
                  opacity: CurvedAnimation(
                    parent: _reveal,
                    curve: const Interval(.62, 1, curve: Curves.easeOut),
                  ),
                  child: const Text(
                    'Opportunities, practical plans,\nand a support circle in your corner.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFB3B5C0),
                      height: 1.5,
                      fontSize: 13,
                    ),
                  ),
                ),
                const Spacer(flex: 4),
                FadeTransition(
                  opacity: CurvedAnimation(
                    parent: _reveal,
                    curve: const Interval(.75, 1, curve: Curves.easeOut),
                  ),
                  child: TextButton(
                    onPressed: widget.onFinish,
                    child: const Text(
                      'ENTER YOUR SPACE  →',
                      style: TextStyle(
                        color: Color(0xFFEAD9B7),
                        letterSpacing: 1.4,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );

  Widget _staggeredWordmark() {
    const word = 'VEERAMANGAI';
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        for (var i = 0; i < word.length; i++)
          Builder(
            builder: (context) {
              final progress = ((_reveal.value - i * .045) / .58).clamp(
                0.0,
                1.0,
              );
              return Opacity(
                opacity: progress,
                child: Transform.translate(
                  offset: Offset(0, (1 - progress) * 21),
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(
                      sigmaX: (1 - progress) * 8,
                      sigmaY: (1 - progress) * 8,
                    ),
                    child: Text(
                      word[i],
                      style: const TextStyle(
                        fontFamily: 'Merriweather',
                        fontSize: 34,
                        letterSpacing: 1.2,
                        color: Color(0xFFFFE6CC),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}

class ForgePainter extends CustomPainter {
  ForgePainter(this.time);
  final double time;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF06130F), Color(0xFF071C29), Color(0xFF06130F)],
        ).createShader(rect),
    );

    final glow = Paint()
      ..shader =
          RadialGradient(
            colors: [
              const Color(0xFF0B8A78).withValues(alpha: .24),
              const Color(0xFF274F9B).withValues(alpha: .12),
              Colors.transparent,
            ],
            stops: const [0, .42, 1],
          ).createShader(
            Rect.fromCircle(
              center: Offset(
                size.width * (.5 + .08 * math.sin(time * math.pi * 2)),
                size.height * .43,
              ),
              radius: size.width * .78,
            ),
          );
    canvas.drawRect(rect, glow);
    final blueGlow = Paint()
      ..shader =
          RadialGradient(
            colors: [
              const Color(0xFF527BC2).withValues(alpha: .14),
              Colors.transparent,
            ],
            stops: const [0, 1],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * .88, size.height * .75),
              radius: size.width * .6,
            ),
          );
    canvas.drawRect(rect, blueGlow);

    for (var wave = 0; wave < 3; wave++) {
      final path = Path();
      final baseY = size.height * (.70 + wave * .055);
      path.moveTo(0, baseY);
      for (var x = 0.0; x <= size.width; x += 16) {
        final phase =
            x / size.width * math.pi * 2.1 + time * math.pi * 2 + wave * .64;
        final y =
            baseY +
            math.sin(phase) * (12 + wave * 3) +
            math.cos(phase * .53) * 5;
        path.lineTo(x, y);
      }
      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2
          ..color = Color.lerp(
            const Color(0xFF64D9C3),
            const Color(0xFFFBCFE8),
            (time + wave * .12) % 1,
          )!.withValues(alpha: .12 - wave * .014),
      );
    }

    for (var i = 0; i < 18; i++) {
      final seed = i * .6180339;
      final travel = (time * (.22 + (i % 5) * .035) + seed) % 1;
      final x =
          size.width * (.12 + .76 * ((seed * 1.71) % 1)) +
          math.sin(time * 6 + seed * 13) * 12;
      final y = size.height * (1 - travel);
      final radius = .7 + (i % 3) * .45;
      final isAmber = i % 3 != 0;
      final color = isAmber ? const Color(0xFFFFC27C) : const Color(0xFFA8D9F5);
      canvas.drawCircle(
        Offset(x, y),
        radius,
        Paint()..color = color.withValues(alpha: (1 - travel) * .63),
      );
    }
  }

  @override
  bool shouldRepaint(covariant ForgePainter oldDelegate) =>
      oldDelegate.time != time;
}

class BrandLockup extends StatelessWidget {
  const BrandLockup({super.key});
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF64D9C3), Color(0xFF83AFFF)],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: const Text(
          'வ',
          style: TextStyle(
            color: Color(0xFF211D36),
            fontWeight: FontWeight.w800,
            fontSize: 17,
          ),
        ),
      ),
      const SizedBox(width: 9),
      const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'VEERAMANGAI',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.3,
            ),
          ),
          Text(
            'EVERY GOAL HAS A TEAM',
            style: TextStyle(fontSize: 8, letterSpacing: .9),
          ),
        ],
      ),
    ],
  );
}

class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      color: Theme.of(context).colorScheme.primary,
      fontSize: 9,
      fontWeight: FontWeight.w800,
      letterSpacing: 1.5,
    ),
  );
}

class SurfaceCard extends StatelessWidget {
  const SurfaceCard({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(padding: const EdgeInsets.all(16), child: child),
  );
}

class GradientPanel extends StatelessWidget {
  const GradientPanel({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: dark
              ? const [Color(0xFF102D2D), Color(0xFF102036)]
              : const [Color(0xFFE7F8F3), Color(0xFFEAF0FF)],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: .23),
        ),
        boxShadow: [
          BoxShadow(
            color: (dark ? const Color(0xFF0B8A78) : const Color(0xFF087E72))
                .withValues(alpha: dark ? .16 : .06),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );
  }
}

class OpportunityIcon extends StatelessWidget {
  const OpportunityIcon({super.key, required this.icon});
  final IconData icon;
  @override
  Widget build(BuildContext context) => Container(
    width: 42,
    height: 42,
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.primary.withValues(alpha: .13),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Icon(icon, color: Theme.of(context).colorScheme.primary),
  );
}

class Tag extends StatelessWidget {
  const Tag({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.primary.withValues(alpha: .12),
      borderRadius: BorderRadius.circular(30),
    ),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 8,
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.w800,
        letterSpacing: .4,
      ),
    ),
  );
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.title, required this.trailing});
  final String title;
  final String trailing;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: const TextStyle(
          fontFamily: 'Merriweather',
          fontFamilyFallback: ['Georgia'],
          fontWeight: FontWeight.w400,
          fontSize: 21,
          letterSpacing: -.35,
        ),
      ),
      Text(
        trailing,
        style: TextStyle(
          fontSize: 10,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    ],
  );
}

class ChecklistRow extends StatelessWidget {
  const ChecklistRow({
    super.key,
    required this.done,
    required this.title,
    required this.subtitle,
  });
  final bool done;
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Icon(
          done ? Icons.check_circle : Icons.radio_button_unchecked,
          size: 19,
          color: done ? Colors.teal : Theme.of(context).colorScheme.outline,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 10,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class OpportunityCard extends StatelessWidget {
  const OpportunityCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.icon,
    required this.onTap,
  });
  final String title, subtitle, tag;
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => SurfaceCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OpportunityIcon(icon: icon),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 9),
                  Tag(text: tag),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 13),
        Align(
          alignment: Alignment.centerRight,
          child: OutlinedButton(
            onPressed: onTap,
            child: const Text('Make a plan'),
          ),
        ),
      ],
    ),
  );
}

class VeeraAvatar extends StatelessWidget {
  const VeeraAvatar({super.key});
  @override
  Widget build(BuildContext context) => Container(
    width: 37,
    height: 37,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF64D9C3), Color(0xFFFBCFE8)],
      ),
      borderRadius: BorderRadius.circular(13),
    ),
    child: const Icon(Icons.auto_awesome, size: 18, color: Color(0xFF10231F)),
  );
}

class PrivacyNote extends StatelessWidget {
  const PrivacyNote({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.primary.withValues(alpha: .08),
      borderRadius: BorderRadius.circular(15),
      border: Border.all(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: .18),
      ),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.lock_outline,
          size: 17,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 11,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    ),
  );
}

class RosterTile extends StatelessWidget {
  const RosterTile({
    super.key,
    required this.initials,
    required this.name,
    required this.plan,
    required this.status,
  });
  final String initials, name, plan, status;
  @override
  Widget build(BuildContext context) => SurfaceCard(
    child: Row(
      children: [
        CircleAvatar(
          radius: 17,
          child: Text(initials, style: const TextStyle(fontSize: 10)),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                plan,
                style: TextStyle(
                  fontSize: 10,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Tag(text: status.toUpperCase()),
      ],
    ),
  );
}

class ChatMessage {
  const ChatMessage({
    required this.text,
    required this.fromUser,
    this.source = '',
  });
  final String text;
  final bool fromUser;
  final String source;
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.message});
  final ChatMessage message;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Align(
      alignment: message.fromUser
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 320),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: message.fromUser
              ? cs.primary.withValues(alpha: .17)
              : cs.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outlineVariant.withValues(alpha: .5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: const TextStyle(fontSize: 12, height: 1.45),
            ),
            if (!message.fromUser)
              Padding(
                padding: const EdgeInsets.only(top: 7),
                child: Text(
                  message.source.isEmpty ? 'VEERA guide' : message.source,
                  style: TextStyle(fontSize: 9, color: cs.onSurfaceVariant),
                ),
              ),
            if (!message.fromUser && message.text.length > 145)
              Padding(
                padding: const EdgeInsets.only(top: 9),
                child: OutlinedButton(
                  onPressed: () => _showReview(context),
                  child: const Text('Review next step'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showReview(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Review before sharing'),
        content: const Text(
          'Veera can prepare a checklist, trip estimate, or message draft. You will review all details before anything is shared. Nothing is sent in this demo.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}

class ChatComposer extends StatefulWidget {
  const ChatComposer({super.key, required this.onSend});
  final ValueChanged<String> onSend;
  @override
  State<ChatComposer> createState() => _ChatComposerState();
}

class _ChatComposerState extends State<ChatComposer> {
  final _controller = TextEditingController();
  final _voice = VeeraVoiceInput();
  bool _recording = false;
  bool _voiceBusy = false;
  Timer? _voiceLimit;
  @override
  void dispose() {
    _controller.dispose();
    _voiceLimit?.cancel();
    _voice.dispose();
    super.dispose();
  }

  Future<void> _voiceAction() async {
    if (!_recording) {
      final consent = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Use voice input?'),
          content: const Text(
            'A short microphone clip will be sent to Sarvam to create a transcript and a private guest session will be created for the request. Avoid recording cycle, symptom, injury, or safety details. Review the transcript before sending it to Veera. The clip is not saved by this app.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Continue'),
            ),
          ],
        ),
      );
      if (consent != true || !mounted) return;
      if (!veeraCloudConfigured) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Connect Supabase to enable voice transcription.'),
          ),
        );
        return;
      }
      if (!await VeeraServices.prepareCloudSession()) {
        if (mounted)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not create a private guest session.'),
            ),
          );
        return;
      }
      try {
        final started = await _voice.start();
        if (!mounted) return;
        setState(() => _recording = started);
        if (started) {
          _voiceLimit?.cancel();
          _voiceLimit = Timer(const Duration(seconds: 18), () {
            if (mounted && _recording) _voiceAction();
          });
        }
        if (!started)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Microphone permission was not granted.'),
            ),
          );
      } catch (_) {
        if (mounted)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not start microphone input.')),
          );
      }
      return;
    }
    _voiceLimit?.cancel();
    setState(() {
      _recording = false;
      _voiceBusy = true;
    });
    final transcript = await _voice.stopAndTranscribe();
    if (!mounted) return;
    setState(() {
      _voiceBusy = false;
      if (transcript.isNotEmpty) _controller.text = transcript;
    });
    if (transcript.isEmpty)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No transcript returned. Try again or type your message.',
          ),
        ),
      );
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSend(text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(7, 0, 7, 5),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Don’t enter private health or cycle details in AI chat.',
              style: TextStyle(
                fontSize: 10,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
        Row(
          children: [
            IconButton(
              tooltip: _recording ? 'Stop and transcribe' : 'Voice input',
              onPressed: _voiceBusy ? null : _voiceAction,
              icon: _voiceBusy
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(
                      _recording
                          ? Icons.stop_circle_outlined
                          : Icons.mic_none_rounded,
                    ),
            ),
            Expanded(
              child: TextField(
                controller: _controller,
                onSubmitted: (_) => _submit(),
                decoration: const InputDecoration(
                  hintText: 'Tell Veera what you want to do…',
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: _submit,
              icon: const Icon(Icons.arrow_upward_rounded),
            ),
          ],
        ),
      ],
    ),
  );
}
