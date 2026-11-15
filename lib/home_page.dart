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
      title: 'Business Portfolio',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F7FB),
        textTheme: GoogleFonts.latoTextTheme(),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6941C6),
        ),
      ),
      home: const PortfolioPage(),
    );
  }
}

// ============================================================
// PORTFOLIO PAGE
// ============================================================

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  // ----------------------------------------------------------
  // SUPABASE
  // ----------------------------------------------------------

  final SupabaseClient supabase = Supabase.instance.client;

  bool isLoading = true;

  // ----------------------------------------------------------
  // COLORS
  // ----------------------------------------------------------

  final Color primaryColor = const Color(0xFF6941C6);
  final Color darkColor = const Color(0xFF17152B);
  final Color backgroundColor = const Color(0xFFF7F7FB);

  // ----------------------------------------------------------
  // BUSINESS DETAILS
  // Default values are displayed if Supabase fields are empty.
  // ----------------------------------------------------------

  String businessName = 'BIASHARA BUNIFU';

  String tagline = 'Tunabadilisha Mawazo Kuwa Uhalisia';

  String description =
      'Tunasaidia biashara kukua kupitia ubunifu, mawazo mapya na huduma za kitaalamu.';

  String logoUrl = '';

  String phone1 = '+255 700 000 001';
  String phone2 = '+255 700 000 002';

  String email = 'info@example.com';

  String instagram = '';
  String facebook = '';
  String tiktok = '';
  String youtube = '';

  String address = 'Dar es Salaam, Tanzania';

  String about =
      'Sisi ni biashara bunifu inayojitahidi kutoa huduma bora kwa wateja wetu. Dhamira yetu ni kutoa suluhisho zenye ubora zinazowasaidia watu binafsi na biashara kufikia malengo yao.';

  String services =
      'Tunatoa huduma za kitaalamu zinazolingana na mahitaji ya biashara yako.';

  String whyChooseUs =
      'Tunathamini ubora, ubunifu, kuridhika kwa wateja na matokeo bora katika kila tunachofanya.';

  // ----------------------------------------------------------
  // PROJECT DETAILS
  // ----------------------------------------------------------

  String project1Title = 'Ubunifu wa Kipekee';

  String project1Description =
      'Suluhisho za usanifu zenye mvuto na ubora wa kitaalamu.';

  String project2Title = 'Suluhisho za Biashara';

  String project2Description =
      'Tunasaidia biashara kujijenga na kukuza uwepo wake mtandaoni.';

  String project3Title = 'Ubunifu wa Kidijitali';

  String project3Description =
      'Suluhisho za kisasa za kidijitali kwa biashara za kisasa.';

  // ----------------------------------------------------------
  // PROJECT IMAGE URLS
  // These are fetched from Supabase columns image1, image2,
  // and image3.
  // ----------------------------------------------------------

  String image1Url = '';
  String image2Url = '';
  String image3Url = '';

  // ----------------------------------------------------------
  // RESPONSIVE SCREEN WIDTH
  // ----------------------------------------------------------

  double screenWidth = 360;

  bool get isMobile => screenWidth < 750;

  double responsiveFont(double originalSize) {
    final width = screenWidth.clamp(320.0, 1200.0);
    return (width / 360) * originalSize;
  }

  @override
  void initState() {
    super.initState();
    fetchBusinessDetails();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    screenWidth = MediaQuery.sizeOf(context).width;
  }

  // ==========================================================
  // FETCH ALL BUSINESS DETAILS FROM SUPABASE
  // ==========================================================

  Future<void> fetchBusinessDetails() async {
    try {
      final response = await supabase
          .from('Webdetails1')
          .select()
          .limit(1)
          .maybeSingle();

      if (response != null && mounted) {
        String getValue(String column, String fallback) {
          final value = response[column];

          if (value == null || value.toString().trim().isEmpty) {
            return fallback;
          }

          return value.toString().trim();
        }

        String getImage(String column) {
          final value = response[column];

          if (value == null) {
            return '';
          }

          return value.toString().trim();
        }

        setState(() {
          // BUSINESS INFORMATION

          businessName = getValue('business_name', businessName);
          tagline = getValue('tagline', tagline);
          description = getValue('description', description);

          logoUrl = getValue('logo_url', logoUrl);

          // CONTACT DETAILS

          phone1 = getValue('phone1', phone1);
          phone2 = getValue('phone2', phone2);
          email = getValue('email', email);

          address = getValue('address', address);

          // SOCIAL MEDIA

          instagram = getValue('instagram', instagram);
          facebook = getValue('facebook', facebook);
          tiktok = getValue('tiktok', tiktok);
          youtube = getValue('youtube', youtube);

          // OTHER BUSINESS DETAILS

          about = getValue('about', about);
          services = getValue('services', services);

          whyChooseUs = getValue(
            'why_choose_us',
            whyChooseUs,
          );

          // PROJECT 1

          project1Title = getValue(
            'project1_title',
            project1Title,
          );

          project1Description = getValue(
            'project1_description',
            project1Description,
          );

          // PROJECT 2

          project2Title = getValue(
            'project2_title',
            project2Title,
          );

          project2Description = getValue(
            'project2_description',
            project2Description,
          );

          // PROJECT 3

          project3Title = getValue(
            'project3_title',
            project3Title,
          );

          project3Description = getValue(
            'project3_description',
            project3Description,
          );

          // PROJECT IMAGES
          // Empty or NULL database values become empty strings.

          image1Url = getImage('image1');
          image2Url = getImage('image2');
          image3Url = getImage('image3');
        });
      }
    } catch (e) {
      debugPrint('Supabase error: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // ==========================================================
  // NAVIGATION KEYS
  // ==========================================================

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
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeInOut,
        alignment: 0,
      );
    }
  }

  // ==========================================================
  // OPEN LINKS
  // ==========================================================

  Future<void> openLink(String link) async {
    if (link.trim().isEmpty) return;

    try {
      final uri = Uri.tryParse(link.trim());

      if (uri == null) return;

      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        debugPrint('Cannot open: $link');
      }
    } catch (e) {
      debugPrint('Link error: $e');
    }
  }

  void callPhone(String number) {
    if (number.trim().isEmpty) return;

    final cleanedNumber = number.replaceAll(' ', '');

    openLink('tel:$cleanedNumber');
  }

  void sendEmail() {
    if (email.trim().isEmpty) return;

    openLink('mailto:$email');
  }

  // ==========================================================
  // MAIN PAGE
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        screenWidth = constraints.maxWidth;

        final mobile = screenWidth < 750;

        return Scaffold(
          backgroundColor: backgroundColor,
          body: SelectionArea(
            child: SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 1400,
                  ),
                  child: Column(
                    children: [
                      buildNavigation(mobile),

                      buildHero(mobile),

                      buildAbout(mobile),

                      buildServices(mobile),

                      buildProjects(mobile),

                      buildWhyChooseUs(mobile),

                      buildContact(mobile),

                      buildFooter(mobile),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ==========================================================
  // NAVIGATION BAR
  // ==========================================================

  Widget buildNavigation(bool mobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: mobile ? 20 : 65,
        vertical: 17,
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
              style: GoogleFonts.lato(
                fontSize: mobile ? 17 : 21,
                fontWeight: FontWeight.w800,
                color: darkColor,
              ),
            ),
          ),

          if (!mobile) ...[
            navItem('Mwanzo', 'home'),
            navItem('Kuhusu Sisi', 'about'),
            navItem('Huduma', 'services'),
            navItem('Kazi Zetu', 'projects'),
            navItem('Wasiliana Nasi', 'contact'),
          ] else
            IconButton(
              icon: Icon(
                Icons.menu_rounded,
                color: darkColor,
                size: 28,
              ),
              onPressed: showMobileMenu,
            ),
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
          fontSize: 14,
          color: darkColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  void showMobileMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                mobileNavItem('Mwanzo', 'home', sheetContext),
                mobileNavItem('Kuhusu Sisi', 'about', sheetContext),
                mobileNavItem('Huduma', 'services', sheetContext),
                mobileNavItem('Kazi Zetu', 'projects', sheetContext),
                mobileNavItem(
                  'Wasiliana Nasi',
                  'contact',
                  sheetContext,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget mobileNavItem(
      String title,
      String section,
      BuildContext sheetContext,
      ) {
    return ListTile(
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: GoogleFonts.lato(
          fontWeight: FontWeight.w700,
          color: darkColor,
        ),
      ),
      onTap: () {
        Navigator.pop(sheetContext);
        scrollToSection(section);
      },
    );
  }

  // ==========================================================
  // BUSINESS LOGO
  // ==========================================================

  Widget buildLogo(double size) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: size,
        height: size,
        color: primaryColor.withOpacity(0.10),
        child: logoUrl.trim().isNotEmpty
            ? Image.network(
          logoUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.business_rounded,
              color: primaryColor,
              size: size * 0.6,
            );
          },
        )
            : Icon(
          Icons.business_rounded,
          color: primaryColor,
          size: size * 0.6,
        ),
      ),
    );
  }

  // ==========================================================
  // HERO SECTION
  // ==========================================================

  Widget buildHero(bool mobile) {
    return Container(
      key: sectionKeys['home'],
      width: double.infinity,
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
      padding: EdgeInsets.symmetric(
        horizontal: mobile ? 25 : 75,
        vertical: mobile ? 65 : 85,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableWidth = constraints.maxWidth;

          final useVerticalLayout = availableWidth < 800;

          if (useVerticalLayout) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                heroContent(
                  mobile: true,
                  availableWidth: availableWidth,
                ),

                const SizedBox(height: 45),

                heroVisual(mobile ? 220 : 280),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 6,
                child: heroContent(
                  mobile: false,
                  availableWidth: availableWidth * 0.58,
                ),
              ),

              const SizedBox(width: 35),

              Expanded(
                flex: 4,
                child: heroVisual(320),
              ),
            ],
          );
        },
      ),
    );
  }

  // ==========================================================
  // HERO CONTENT
  // ==========================================================

  Widget heroContent({
    required bool mobile,
    required double availableWidth,
  }) {
    final titleSize = mobile
        ? (availableWidth * 0.085).clamp(29.0, 42.0)
        : (availableWidth * 0.095).clamp(40.0, 66.0);

    final subtitleSize = mobile
        ? (availableWidth * 0.045).clamp(18.0, 23.0)
        : (availableWidth * 0.047).clamp(21.0, 31.0);

    return Column(
      crossAxisAlignment:
      mobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        // SMALL LABEL

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 9,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.10),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: Colors.white.withOpacity(0.25),
            ),
          ),
          child: Text(
            'KARIBU KWENYE BIASHARA YETU',
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(
              color: Colors.white70,
              fontSize: 11,
              letterSpacing: 2,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),

        const SizedBox(height: 25),

        // BUSINESS NAME

        Text(
          businessName,
          textAlign: mobile ? TextAlign.center : TextAlign.start,
          style: GoogleFonts.lato(
            color: Colors.white,
            fontSize: titleSize,
            fontWeight: FontWeight.w900,
            height: 1.08,
            letterSpacing: -1.2,
          ),
        ),

        const SizedBox(height: 18),

        // ACCENT LINE

        Container(
          width: mobile ? 65 : 85,
          height: 5,
          decoration: BoxDecoration(
            color: const Color(0xFFFFD166),
            borderRadius: BorderRadius.circular(10),
          ),
        ),

        const SizedBox(height: 20),

        // TAGLINE

        Text(
          tagline,
          textAlign: mobile ? TextAlign.center : TextAlign.start,
          style: GoogleFonts.lato(
            color: const Color(0xFFFFD166),
            fontSize: subtitleSize,
            fontWeight: FontWeight.w700,
            height: 1.35,
          ),
        ),

        const SizedBox(height: 20),

        // DESCRIPTION

        ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 600,
          ),
          child: Text(
            description,
            textAlign: mobile ? TextAlign.center : TextAlign.start,
            style: GoogleFonts.lato(
              color: Colors.white70,
              fontSize: 16,
              height: 1.8,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),

        const SizedBox(height: 30),

        // BUTTONS

        Wrap(
          alignment: mobile ? WrapAlignment.center : WrapAlignment.start,
          spacing: 13,
          runSpacing: 13,
          children: [
            ElevatedButton(
              onPressed: () => scrollToSection('contact'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: primaryColor,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 17,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Wasiliana Nasi',
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
            ),

            OutlinedButton(
              onPressed: () => scrollToSection('projects'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(
                  color: Colors.white70,
                  width: 1.3,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 17,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Tazama Kazi Zetu',
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ==========================================================
  // HERO VISUAL
  // ==========================================================

  Widget heroVisual(double size) {
    return Center(
      child: Container(
        width: size,
        height: size,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.10),
          borderRadius: BorderRadius.circular(35),
          border: Border.all(
            color: Colors.white.withOpacity(0.25),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Center(
          child: logoUrl.trim().isNotEmpty
              ? ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.network(
              logoUrl,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 100,
                );
              },
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

  // ==========================================================
  // ABOUT SECTION
  // ==========================================================

  Widget buildAbout(bool mobile) {
    return Container(
      key: sectionKeys['about'],
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: mobile ? 25 : 75,
        vertical: 80,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 750) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                sectionHeading(
                  'KUHUSU SISI',
                  'Sisi Ni Nani?',
                  center: true,
                ),

                const SizedBox(height: 25),

                Text(
                  about,
                  textAlign: TextAlign.center,
                  style: bodyStyle,
                ),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: sectionHeading(
                  'KUHUSU SISI',
                  'Sisi Ni Nani?',
                ),
              ),

              const SizedBox(width: 55),

              Expanded(
                flex: 2,
                child: Text(
                  about,
                  style: bodyStyle,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ==========================================================
  // SERVICES SECTION
  // ==========================================================

  Widget buildServices(bool mobile) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: mobile ? 25 : 75,
        vertical: 80,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          sectionHeading(
            'TUNACHOFANYA',
            'Huduma Zetu',
            center: true,
          ),

          const SizedBox(height: 18),

          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 750,
            ),
            child: Text(
              services,
              textAlign: TextAlign.center,
              style: bodyStyle,
            ),
          ),

          const SizedBox(height: 40),

          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth < 550
                  ? 1
                  : constraints.maxWidth < 950
                  ? 2
                  : 3;

              final width = columns == 1
                  ? constraints.maxWidth
                  : (constraints.maxWidth - (20 * (columns - 1))) /
                  columns;

              return Wrap(
                alignment: WrapAlignment.center,
                spacing: 20,
                runSpacing: 20,
                children: [
                  SizedBox(
                    width: width,
                    child: serviceCard(
                      Icons.design_services_outlined,
                      'Ubora wa Kitaalamu',
                      'Tunatoa huduma bora kwa kuzingatia kila undani.',
                    ),
                  ),

                  SizedBox(
                    width: width,
                    child: serviceCard(
                      Icons.lightbulb_outline_rounded,
                      'Suluhisho Bunifu',
                      'Mawazo mapya yanayoifanya biashara yako ijitofautishe.',
                    ),
                  ),

                  SizedBox(
                    width: width,
                    child: serviceCard(
                      Icons.support_agent_rounded,
                      'Huduma kwa Wateja',
                      'Tunawathamini wateja wetu na kuridhika kwao ni kipaumbele.',
                    ),
                  ),
                ],
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
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: primaryColor.withOpacity(0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              icon,
              color: primaryColor,
              size: 34,
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

  // ==========================================================
  // PROJECTS SECTION
  // ==========================================================

  Widget buildProjects(bool mobile) {
    return Container(
      key: sectionKeys['projects'],
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: mobile ? 25 : 75,
        vertical: 80,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          sectionHeading(
            'KAZI ZETU',
            'Miradi Iliyokamilika',
            center: true,
          ),

          const SizedBox(height: 40),

          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth < 550
                  ? 1
                  : constraints.maxWidth < 950
                  ? 2
                  : 3;

              final width = columns == 1
                  ? constraints.maxWidth
                  : (constraints.maxWidth - (20 * (columns - 1))) /
                  columns;

              return Wrap(
                alignment: WrapAlignment.center,
                spacing: 20,
                runSpacing: 20,
                children: [
                  SizedBox(
                    width: width,
                    child: projectCard(
                      project1Title,
                      project1Description,
                      Icons.palette_outlined,
                      image1Url,
                    ),
                  ),

                  SizedBox(
                    width: width,
                    child: projectCard(
                      project2Title,
                      project2Description,
                      Icons.business_center_outlined,
                      image2Url,
                    ),
                  ),

                  SizedBox(
                    width: width,
                    child: projectCard(
                      project3Title,
                      project3Description,
                      Icons.devices_outlined,
                      image3Url,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // PROJECT CARD
  // ==========================================================

  Widget projectCard(
      String title,
      String description,
      IconData icon,
      String imageUrl,
      ) {
    final hasImage = imageUrl.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // PROJECT IMAGE

          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: SizedBox(
              width: double.infinity,
              height: 200,
              child: hasImage
                  ? Image.network(
                imageUrl.trim(),
                fit: BoxFit.cover,
                loadingBuilder: (
                    context,
                    child,
                    loadingProgress,
                    ) {
                  if (loadingProgress == null) {
                    return child;
                  }

                  return Container(
                    color: backgroundColor,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
                errorBuilder: (
                    context,
                    error,
                    stackTrace,
                    ) {
                  return projectImageFallback(icon);
                },
              )
                  : projectImageFallback(icon),
            ),
          ),

          const SizedBox(height: 22),

          // PROJECT TITLE

          Text(
            title,
            textAlign: TextAlign.center,
            style: cardTitleStyle,
          ),

          const SizedBox(height: 12),

          // PROJECT DESCRIPTION

          Text(
            description,
            textAlign: TextAlign.center,
            style: bodyStyle,
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // PROJECT IMAGE FALLBACK
  // ==========================================================

  Widget projectImageFallback(IconData icon) {
    return Container(
      width: double.infinity,
      height: 200,
      color: primaryColor.withOpacity(0.09),
      child: Center(
        child: Icon(
          icon,
          color: primaryColor,
          size: 65,
        ),
      ),
    );
  }

  // ==========================================================
  // WHY CHOOSE US SECTION
  // ==========================================================

  Widget buildWhyChooseUs(bool mobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: mobile ? 25 : 75,
        vertical: 75,
      ),
      color: darkColor,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 750) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                sectionHeading(
                  'AHADI YETU',
                  'Kwa Nini Utuchague?',
                  light: true,
                  center: true,
                ),

                const SizedBox(height: 25),

                Text(
                  whyChooseUs,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    color: Colors.white70,
                    fontSize: 16,
                    height: 1.8,
                  ),
                ),
              ],
            );
          }

          return Row(
            children: [
              Expanded(
                child: sectionHeading(
                  'AHADI YETU',
                  'Kwa Nini Utuchague?',
                  light: true,
                ),
              ),

              const SizedBox(width: 55),

              Expanded(
                flex: 2,
                child: Text(
                  whyChooseUs,
                  style: GoogleFonts.lato(
                    color: Colors.white70,
                    fontSize: 17,
                    height: 1.8,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ==========================================================
  // CONTACT SECTION
  // ==========================================================

  Widget buildContact(bool mobile) {
    return Container(
      key: sectionKeys['contact'],
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: mobile ? 25 : 75,
        vertical: 80,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          sectionHeading(
            'WASILIANA NASI',
            'Tupo Tayari Kukuhudumia',
            center: true,
          ),

          const SizedBox(height: 18),

          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 700,
            ),
            child: Text(
              'Tungependa kusikia kutoka kwako. Wasiliana nasi kupitia njia zozote zilizo hapa chini.',
              textAlign: TextAlign.center,
              style: bodyStyle,
            ),
          ),

          const SizedBox(height: 40),

          // CONTACT DETAILS

          Wrap(
            alignment: WrapAlignment.center,
            spacing: 20,
            runSpacing: 20,
            children: [
              contactItem(
                Icons.phone_outlined,
                'Namba ya Simu 1',
                phone1,
                    () => callPhone(phone1),
              ),

              contactItem(
                Icons.phone_android_outlined,
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
                    () {
                  openLink(
                    'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}',
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 50),

          // SOCIAL MEDIA TITLE

          Text(
            'TUFUATILIE KWENYE MITANDAO YA KIJAMII',
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(
              fontSize: 13,
              letterSpacing: 2,
              fontWeight: FontWeight.w800,
              color: darkColor,
            ),
          ),

          const SizedBox(height: 22),

          // SOCIAL MEDIA BUTTONS

          Wrap(
            alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
            spacing: 15,
            children: [

              socialButton(
                FaIcon(FontAwesomeIcons.instagram, color: primaryColor, size: 21),
                'Instagram',
                instagram,
              ),

              socialButton(
                FaIcon(FontAwesomeIcons.facebook, color: primaryColor, size: 21),
                'Facebook',
                facebook,
              ),

              socialButton(
                FaIcon(FontAwesomeIcons.tiktok, color: primaryColor, size: 21),
                'TikTok',
                tiktok,
              ),

              socialButton(
                FaIcon(FontAwesomeIcons.youtube, color: primaryColor, size: 21),
                'YouTube',
                youtube,
              ),

            ],
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // CONTACT ITEM
  // ==========================================================

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
        width: 250,
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
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: darkColor,
                    ),
                  ),

                  const SizedBox(height: 7),

                  Text(
                    value,
                    style: GoogleFonts.lato(
                      fontSize: 14,
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

  // ==========================================================
  // SOCIAL MEDIA BUTTON
  // ==========================================================

  Widget socialButton(
      Widget icon,
      String title,
      String url,
      ) {
    return Tooltip(
      message: title,
      child: InkWell(
        onTap: () => openLink(url),
        borderRadius: BorderRadius.circular(50),
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.10),
            shape: BoxShape.circle,
          ),
          child: Center(child: icon),
        ),
      ),
    );
  }

  // ==========================================================
  // FOOTER
  // ==========================================================

  Widget buildFooter(bool mobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: mobile ? 25 : 75,
        vertical: 30,
      ),
      color: darkColor,
      child: mobile
          ? Column(
        children: [
          Text(
            businessName,
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 21,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            '© Haki zote zimehifadhiwa.',
            style: GoogleFonts.lato(
              color: Colors.white60,
              fontSize: 13,
            ),
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
              fontWeight: FontWeight.w800,
              fontSize: 21,
            ),
          ),

          Text(
            '© Haki zote zimehifadhiwa.',
            style: GoogleFonts.lato(
              color: Colors.white60,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // REUSABLE TEXT STYLES
  // ==========================================================

  TextStyle get bodyStyle => GoogleFonts.lato(
    fontSize: 15,
    height: 1.8,
    color: Colors.black54,
  );

  TextStyle get cardTitleStyle => GoogleFonts.lato(
    fontSize: 19,
    fontWeight: FontWeight.w800,
    color: darkColor,
  );

  // ==========================================================
  // SECTION HEADING
  // ==========================================================

  Widget sectionHeading(
      String eyebrow,
      String heading, {
        bool light = false,
        bool center = false,
      }) {
    return Column(
      crossAxisAlignment:
      center ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow,
          textAlign: center ? TextAlign.center : TextAlign.start,
          style: GoogleFonts.lato(
            color: light ? Colors.white70 : primaryColor,
            fontSize: 12,
            letterSpacing: 3,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 12),

        Text(
          heading,
          textAlign: center ? TextAlign.center : TextAlign.start,
          style: GoogleFonts.lato(
            color: light ? Colors.white : darkColor,
            fontSize: 32,
            fontWeight: FontWeight.w900,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}