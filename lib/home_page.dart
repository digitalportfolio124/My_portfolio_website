import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tovuti ya Biashara',
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.latoTextTheme(),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6941C6),
        ),
      ),
      home: const PortfolioPage(),
    );
  }
}

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {

  // ------------------------------------------------
  // SUPABASE
  // ------------------------------------------------

  final SupabaseClient supabase = Supabase.instance.client;

  bool isLoading = true;

  // ------------------------------------------------
  // BUSINESS DETAILS
  // All variables have sample default values.
  // ------------------------------------------------

  String businessName = 'BIASHARA BUNIFU';
  String tagline = 'Tunabadilisha Mawazo Kuwa Uhalisia';
  String description =
      'Tunasaidia biashara kukua kupitia ubunifu, mawazo mapya na huduma za kitaalamu.';

  String logoUrl = 'https://kjutcyqxyfcwithltroh.supabase.co/storage/v1/object/public/images/pictures/Logo.png';

  String phone1 = '+255 700 000 001';
  String phone2 = '+255 700 000 002';
  String email = 'info@example.com';

  String instagram = 'https://instagram.com/';
  String facebook = 'https://facebook.com/';
  String tiktok = 'https://tiktok.com/';
  String youtube = 'https://youtube.com/';

  String address = 'Dar es Salaam, Tanzania';

  String about =
      'Sisi ni biashara bunifu inayojitahidi kutoa huduma bora kwa wateja wetu. Dhamira yetu ni kutoa suluhisho zenye ubora zinazowasaidia watu binafsi na biashara kufikia malengo yao.';

  String services =
      'Tunatoa huduma za kitaalamu zinazolingana na mahitaji ya biashara yako.';

  String whyChooseUs =
      'Tunathamini ubora, ubunifu, kuridhika kwa wateja na matokeo bora katika kila tunachofanya.';

  String project1Title = 'Ubunifu wa Kipekee';
  String project1Description =
      'Suluhisho za usanifu zenye mvuto na ubora wa kitaalamu.';

  String project2Title = 'Suluhisho za Biashara';
  String project2Description =
      'Tunasaidia biashara kujijenga na kukuza uwepo wake mtandaoni.';

  String project3Title = 'Ubunifu wa Kidijitali';
  String project3Description =
      'Suluhisho za kisasa za kidijitali kwa biashara za kisasa.';

  // ------------------------------------------------
  // COLORS
  // ------------------------------------------------

  final Color primaryColor = const Color(0xFF6941C6);
  final Color darkColor = const Color(0xFF17152B);
  final Color backgroundColor = const Color(0xFFF7F7FB);

  // Current screen width. It starts at 360 so the first layout has
  // sensible font sizes before the first frame is measured.
  double screenWidth = 360;

  // Keeps the original font sizes at a 360px screen width.
  // Example: responsiveFont(20) becomes screenWidth / 18.
  // Width is capped at 360 so desktop text does not become excessively large.
  double responsiveFont(double originalSize) {
    final width = screenWidth.clamp(320.0, 360.0);
    return width / (360 / originalSize);
  }

  void screenWidthFunc() {
    if (!mounted) return;

    final newWidth = MediaQuery.sizeOf(context).width;
    if (newWidth != screenWidth) {
      setState(() {
        screenWidth = newWidth;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Also updates the width when the browser/window is resized.
    screenWidth = MediaQuery.sizeOf(context).width;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      screenWidthFunc();
    });
    fetchBusinessDetails();
  }

  // ------------------------------------------------
  // FETCH SUPABASE DETAILS
  // ------------------------------------------------

  Future<void> fetchBusinessDetails() async {
    try {
      final response = await supabase
          .from('Webdetails1')
          .select()
          .limit(1)
          .maybeSingle();

      if (response != null) {
        String getValue(String key, String fallback) {
          final value = response[key];

          if (value == null || value.toString().trim().isEmpty) {
            return fallback;
          }

          return value.toString().trim();
        }

        if (mounted) {
          setState(() {
            businessName = getValue('business_name', businessName);
            tagline = getValue('tagline', tagline);
            description = getValue('description', description);

            logoUrl = getValue('logo_url', logoUrl);

            phone1 = getValue('phone1', phone1);
            phone2 = getValue('phone2', phone2);
            email = getValue('email', email);

            instagram = getValue('instagram', instagram);
            facebook = getValue('facebook', facebook);
            tiktok = getValue('tiktok', tiktok);
            youtube = getValue('youtube', youtube);

            address = getValue('address', address);
            about = getValue('about', about);
            services = getValue('services', services);
            whyChooseUs =
                getValue('why_choose_us', whyChooseUs);

            project1Title =
                getValue('project1_title', project1Title);
            project1Description =
                getValue('project1_description', project1Description);

            project2Title =
                getValue('project2_title', project2Title);
            project2Description =
                getValue('project2_description', project2Description);

            project3Title =
                getValue('project3_title', project3Title);
            project3Description =
                getValue('project3_description', project3Description);
          });
        }
      }
    } catch (e) {
      debugPrint('Supabase fetch error: $e');
      // Default sample details remain available.
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // ------------------------------------------------
  // URL LAUNCHER
  // ------------------------------------------------

  Future<void> openLink(String link) async {
    try {
      final uri = Uri.parse(link);

      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        debugPrint('Cannot open: $link');
      }
    } catch (e) {
      debugPrint('URL error: $e');
    }
  }

  void callPhone(String number) {
    openLink('tel:${number.replaceAll(' ', '')}');
  }

  void sendEmail() {
    openLink('mailto:$email');
  }

  // ------------------------------------------------
  // MAIN PAGE
  // ------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SelectionArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isPortrait = MediaQuery.orientationOf(context) == Orientation.portrait;
            final isMobile = constraints.maxWidth < 750 || isPortrait;

            return SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 1350,
                  ),
                  child: Column(
                    children: [

                      buildNavigation(isMobile),

                      buildHero(isMobile),

                      buildAbout(isMobile),

                      buildServices(isMobile),

                      buildProjects(isMobile),

                      buildWhyChooseUs(isMobile),

                      buildContact(isMobile),

                      buildFooter(isMobile),

                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ------------------------------------------------
  // NAVIGATION BAR
  // ------------------------------------------------

  Widget buildNavigation(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 55,
        vertical: 20,
      ),
      color: Colors.white,
      child: Row(
        children: [

          buildLogo(48),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              businessName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: responsiveFont(isMobile ? 17 : 21),
                fontWeight: FontWeight.w700,
                color: darkColor,
              ),
            ),
          ),

          if (!isMobile) ...[

            navItem('Mwanzo', 'home'),
            navItem('Kuhusu Sisi', 'about'),
            navItem('Huduma', 'services'),
            navItem('Kazi Zetu', 'projects'),
            navItem('Wasiliana Nasi', 'contact'),

          ] else ...[
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Container(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        mobileNavItem('Mwanzo', 'home'),
                        mobileNavItem('Kuhusu Sisi', 'about'),
                        mobileNavItem('Huduma', 'services'),
                        mobileNavItem('Kazi Zetu', 'projects'),
                        mobileNavItem('Wasiliana Nasi', 'contact'),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget navItem(String title, String section) {
    return TextButton(
      onPressed: () => scrollToSection(section),
      child: Text(
        title,
        style: GoogleFonts.lato(
          fontSize: responsiveFont(14),
          color: darkColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget mobileNavItem(String title, String section) {
    return ListTile(
      title: Text(title, textAlign: TextAlign.center, style: GoogleFonts.lato()),
      onTap: () {
        Navigator.pop(context);
        scrollToSection(section);
      },
    );
  }

  // ------------------------------------------------
  // SECTION NAVIGATION
  // ------------------------------------------------

  final Map<String, GlobalKey> sectionKeys = {
    'home': GlobalKey(),
    'about': GlobalKey(),
    'services': GlobalKey(),
    'projects': GlobalKey(),
    'contact': GlobalKey(),
  };

  void scrollToSection(String section) {
    final key = sectionKeys[section];

    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }
  }

  // ------------------------------------------------
  // BUSINESS LOGO
  // ------------------------------------------------

  Widget buildLogo(double size) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: size,
        height: size,
        color: primaryColor.withValues(alpha: 0.1),
        child: logoUrl.isNotEmpty
            ? Image.network(
          logoUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.business,
              size: size * 0.65,
              color: primaryColor,
            );
          },
        )
            : Icon(
          Icons.business,
          size: size * 0.65,
          color: primaryColor,
        ),
      ),
    );
  }

  // ------------------------------------------------
  // HERO SECTION
  // ------------------------------------------------

  Widget buildHero(bool isMobile) {
    return Container(
      key: sectionKeys['home'],
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 25 : 75,
        vertical: isMobile ? 65 : 100,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            darkColor,
            const Color(0xFF30245C),
            primaryColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: isMobile
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          heroContent(isMobile),
          const SizedBox(height: 35),
          heroVisual(250),
        ],
      )
          : Row(
        children: [
          Expanded(
            flex: 6,
            child: heroContent(isMobile),
          ),
          const SizedBox(width: 35),
          Expanded(
            flex: 4,
            child: heroVisual(350),
          ),
        ],
      ),
    );
  }

  Widget heroContent(bool isMobile) {
    return Column(
      crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [

        Text(
          'KARIBU KWENYE BIASHARA YETU',
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
          style: GoogleFonts.lato(
            color: Colors.white70,
            fontSize: responsiveFont(13),
            letterSpacing: 3,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 20),

        Text(
          businessName,
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
          style: GoogleFonts.lato(
            color: Colors.white,
            fontSize: responsiveFont(isMobile ? 36 : 54),
            fontWeight: FontWeight.w700,
            height: 1.15,
          ),
        ),

        const SizedBox(height: 15),

        Text(
          tagline,
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
          style: GoogleFonts.lato(
            color: Colors.white,
            fontSize: responsiveFont(isMobile ? 21 : 28),
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 20),

        Text(
          description,
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
          style: GoogleFonts.lato(
            color: Colors.white70,
            fontSize: responsiveFont(16),
            height: 1.8,
          ),
        ),

        const SizedBox(height: 30),

        Wrap(
          alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
          spacing: 15,
          runSpacing: 12,
          children: [

            ElevatedButton(
              onPressed: () => scrollToSection('contact'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 18,
                ),
              ),
              child: Text('Wasiliana Nasi', style: GoogleFonts.lato(fontSize: responsiveFont(16))),
            ),

            OutlinedButton(
              onPressed: () => scrollToSection('projects'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white),
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 18,
                ),
              ),
              child: Text('Tazama Kazi Zetu', style: GoogleFonts.lato(fontSize: responsiveFont(16))),
            ),

          ],
        ),
      ],
    );
  }

  Widget heroVisual(double size) {
    return Center(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(35),
          border: Border.all(
            color: Colors.white24,
            width: 2,
          ),
        ),
        child: Center(
          child: logoUrl.isNotEmpty
              ? ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.network(
              logoUrl,
              width: size * 0.65,
              height: size * 0.65,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.auto_awesome,
                color: Colors.white,
                size: 100,
              ),
            ),
          )
              : const Icon(
            Icons.auto_awesome,
            color: Colors.white,
            size: 100,
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------
  // ABOUT SECTION
  // ------------------------------------------------

  Widget buildAbout(bool isMobile) {
    return Container(
      key: sectionKeys['about'],
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 25 : 75,
        vertical: 75,
      ),
      child: isMobile
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          sectionHeading('KUHUSU SISI', 'Sisi Ni Nani?', center: isMobile),
          const SizedBox(height: 20),
          Text(
            about,
            textAlign: isMobile ? TextAlign.center : TextAlign.start,
            style: bodyStyle,
          ),
        ],
      )
          : Row(
        children: [
          Expanded(
            child: sectionHeading('KUHUSU SISI', 'Sisi Ni Nani?', center: isMobile),
          ),
          const SizedBox(width: 45),
          Expanded(
            flex: 2,
            child: Text(
              about,
              style: bodyStyle,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------
  // SERVICES SECTION
  // ------------------------------------------------

  Widget buildServices(bool isMobile) {
    return Container(
      key: sectionKeys['services'],
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 25 : 75,
        vertical: 75,
      ),
      child: Column(
        crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [

          sectionHeading('TUNACHOFANYA', 'Huduma Zetu', center: isMobile),

          const SizedBox(height: 15),

          Text(
            services,
            textAlign: isMobile ? TextAlign.center : TextAlign.start,
            style: bodyStyle,
          ),

          const SizedBox(height: 35),

          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth < 550
                  ? 1
                  : constraints.maxWidth < 900
                  ? 2
                  : 3;

              final serviceItems = [
                [
                  Icons.design_services,
                  'Ubora wa Kitaalamu',
                  'Tunatoa huduma bora kwa kuzingatia kila undani.',
                ],
                [
                  Icons.lightbulb_outline,
                  'Suluhisho Bunifu',
                  'Mawazo mapya yanayoifanya biashara yako ijitofautishe.',
                ],
                [
                  Icons.support_agent,
                  'Huduma kwa Wateja',
                  'Tunawathamini wateja wetu na kuridhika kwao ni kipaumbele.',
                ],
              ];

              return Wrap(
                alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
                spacing: 20,
                runSpacing: 20,
                children: serviceItems.map((item) {
                  return SizedBox(
                    width: columns == 1
                        ? constraints.maxWidth
                        : (constraints.maxWidth - 40) / columns,
                    child: serviceCard(
                      item[0] as IconData,
                      item[1] as String,
                      item[2] as String,
                    ),
                  );
                }).toList(),
              );
            },
          ),

        ],
      ),
    );
  }

  Widget serviceCard(
      IconData icon,
      String title,
      String description,
      ) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Icon(
            icon,
            size: 38,
            color: primaryColor,
          ),

          const SizedBox(height: 20),

          Text(
            title,
            textAlign: TextAlign.center,
            style: cardTitleStyle,
          ),

          const SizedBox(height: 12),

          Text(
            description,
            textAlign: TextAlign.center,
            style: bodyStyle,
          ),

        ],
      ),
    );
  }

  // ------------------------------------------------
  // PORTFOLIO / PROJECTS
  // ------------------------------------------------

  Widget buildProjects(bool isMobile) {
    return Container(
      key: sectionKeys['projects'],
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 25 : 75,
        vertical: 75,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          sectionHeading('KAZI ZETU', 'Miradi Iliyokamilika', center: isMobile),

          const SizedBox(height: 35),

          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth < 550
                  ? 1
                  : constraints.maxWidth < 900
                  ? 2
                  : 3;

              final projects = [
                [
                  project1Title,
                  project1Description,
                  Icons.palette_outlined,
                ],
                [
                  project2Title,
                  project2Description,
                  Icons.business_center_outlined,
                ],
                [
                  project3Title,
                  project3Description,
                  Icons.devices_outlined,
                ],
              ];

              return Wrap(
                alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
                spacing: 20,
                runSpacing: 20,
                children: projects.map((project) {
                  return SizedBox(
                    width: columns == 1
                        ? constraints.maxWidth
                        : (constraints.maxWidth - 40) / columns,
                    child: projectCard(
                      project[0] as String,
                      project[1] as String,
                      project[2] as IconData,
                    ),
                  );
                }).toList(),
              );
            },
          ),

        ],
      ),
    );
  }

  Widget projectCard(
      String title,
      String description,
      IconData icon,
      ) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Container(
            width: double.infinity,
            height: 140,
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.09),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              icon,
              color: primaryColor,
              size: 65,
            ),
          ),

          const SizedBox(height: 22),

          Text(
            title,
            textAlign: TextAlign.center,
            style: cardTitleStyle,
          ),

          const SizedBox(height: 12),

          Text(
            description,
            textAlign: TextAlign.center,
            style: bodyStyle,
          ),

        ],
      ),
    );
  }

  // ------------------------------------------------
  // WHY CHOOSE US
  // ------------------------------------------------

  Widget buildWhyChooseUs(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 25 : 75,
        vertical: 65,
      ),
      color: darkColor,
      child: isMobile
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          sectionHeading(
            'AHADI YETU',
            'Kwa Nini Utuchague?',
            light: true,
            center: isMobile,
          ),
          const SizedBox(height: 20),
          Text(
            whyChooseUs,
            textAlign: isMobile ? TextAlign.center : TextAlign.start,
            style: GoogleFonts.lato(
              color: Colors.white70,
              fontSize: responsiveFont(16),
              height: 1.8,
            ),
          ),
        ],
      )
          : Row(
        children: [
          Expanded(
            child: sectionHeading(
              'AHADI YETU',
              'Kwa Nini Utuchague?',
              light: true,
              center: false,
            ),
          ),
          const SizedBox(width: 45),
          Expanded(
            flex: 2,
            child: Text(
              whyChooseUs,
              style: GoogleFonts.lato(
                color: Colors.white70,
                fontSize: responsiveFont(17),
                height: 1.8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------
  // CONTACT SECTION
  // ------------------------------------------------

  Widget buildContact(bool isMobile) {
    return Container(
      key: sectionKeys['contact'],
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 25 : 75,
        vertical: 75,
      ),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [

          sectionHeading('WASILIANA NASI', 'Tupo Tayari Kukuhudumia', center: isMobile),

          const SizedBox(height: 15),

          Text(
            'Tungependa kusikia kutoka kwako. Wasiliana nasi kupitia njia zozote zilizo hapa chini.',
            textAlign: isMobile ? TextAlign.center : TextAlign.start,
            style: bodyStyle,
          ),

          const SizedBox(height: 35),

          Wrap(
            alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
            spacing: 25,
            runSpacing: 25,
            children: [

              contactItem(
                Icons.phone,
                'Namba ya Simu 1',
                phone1,
                    () => callPhone(phone1),
              ),

              contactItem(
                Icons.phone_android,
                'Namba ya Simu 2',
                phone2,
                    () => callPhone(phone2),
              ),

              contactItem(
                Icons.email_outlined,
                'Barua Pepe',
                email,
                sendEmail,
              ),

              contactItem(
                Icons.location_on_outlined,
                'Mahali Tulipo',
                address,
                    () => openLink(
                  'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}',
                ),
              ),

            ],
          ),

          const SizedBox(height: 45),

          Text(
            'TUFUATILIE KWENYE MITANDAO YA KIJAMII',
            textAlign: isMobile ? TextAlign.center : TextAlign.start,
            style: GoogleFonts.lato(
              fontSize: responsiveFont(13),
              letterSpacing: 2,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 20),

          Wrap(
            alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
            spacing: 15,
            children: [

              socialButton(
                FontAwesomeIcons.instagram,
                'Instagram',
                instagram,
              ),

              socialButton(
                FontAwesomeIcons.facebookF,
                'Facebook',
                facebook,
              ),

              socialButton(
                FontAwesomeIcons.tiktok,
                'TikTok',
                tiktok,
              ),

              socialButton(
                FontAwesomeIcons.youtube,
                'YouTube',
                youtube,
              ),

            ],
          ),

        ],
      ),
    );
  }

  Widget contactItem(
      IconData icon,
      String title,
      String value,
      VoidCallback onTap,
      ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: 245,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [

            Icon(
              icon,
              color: primaryColor,
              size: 27,
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.normal,
                      fontSize: responsiveFont(13),
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    value,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      fontSize: responsiveFont(14),
                      color: Colors.black54,
                    ),
                  ),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget socialButton(
      FaIconData icon,
      String title,
      String url,
      ) {
    return Tooltip(
      message: title,
      child: InkWell(
        onTap: () => openLink(url),
        borderRadius: BorderRadius.circular(50),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: FaIcon(
            icon,
            color: primaryColor,
            size: 21,
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------
  // FOOTER
  // ------------------------------------------------

  Widget buildFooter(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 25 : 75,
        vertical: 30,
      ),
      color: darkColor,
      child: isMobile
          ? Column(
        children: [
          Text(
            businessName,
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: responsiveFont(22),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '© Haki zote zimehifadhiwa.',
            style: GoogleFonts.lato(color: Colors.white60),
          ),
        ],
      )
          : Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            businessName,
            style: GoogleFonts.lato(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: responsiveFont(21),
            ),
          ),
          Text(
            '© Haki zote zimehifadhiwa.',
            style: GoogleFonts.lato(color: Colors.white60),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------
  // REUSABLE STYLES
  // ------------------------------------------------

  // Lato is used throughout for clear, readable text.
  TextStyle get bodyStyle => GoogleFonts.lato(
    fontSize: responsiveFont(15),
    height: 1.8,
    color: Colors.black54,
  );

  // Card headings use a clear Lato weight for easy reading.
  TextStyle get cardTitleStyle => GoogleFonts.lato(
    fontSize: responsiveFont(19),
    fontWeight: FontWeight.w700,
    color: darkColor,
  );

  Widget sectionHeading(
      String eyebrow,
      String heading, {
        bool light = false,
        bool center = false,
      }) {
    return Column(
      crossAxisAlignment: center ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [

        Text(
          eyebrow,
          textAlign: center ? TextAlign.center : TextAlign.start,
          style: GoogleFonts.lato(
            color: light ? Colors.white70 : primaryColor,
            fontSize: responsiveFont(12),
            letterSpacing: 3,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 12),

        Text(
          heading,
          textAlign: center ? TextAlign.center : TextAlign.start,
          style: GoogleFonts.lato(
            color: light ? Colors.white : darkColor,
            fontSize: responsiveFont(32),
            fontWeight: FontWeight.w700,
          ),
        ),

      ],
    );
  }
}
