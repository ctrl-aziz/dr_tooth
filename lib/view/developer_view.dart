import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class DeveloperView extends StatelessWidget {
  const DeveloperView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Example();
    // return Directionality(
    //   textDirection: TextDirection.rtl,
    //   child: Scaffold(
    //     appBar: AppBar(
    //       title: const Text('معلومات المطور'),
    //     ),
    //     body: const Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             Text('البريد الالكتروني: '),
    //             Text('syriatech07@gmail.com'),
    //           ],
    //         ),
    //         SizedBox(height: 10,),
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             Text('رقم الهاتف: '),
    //             Text('00905525310873'),
    //           ],
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("حول المطور"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: Column(
            children: [
              const SizedBox(height: 20.0,),
              const Text(
                "إذا كان لديك اي استفسار حول التطبيق يمكنك التواصل عبر",
              textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
               Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SocialIcon(
                    label: "انستغرام",
                    bg: Colors.redAccent,
                    iconColor: Colors.white,
                    icon: FontAwesomeIcons.instagram,
                    link: "https://www.instagram.com/ctrl_aziz",
                  ),
                  const SocialIcon(
                    label: "جيت هاب",
                    bg: Colors.purple,
                    iconColor: Colors.white,
                    icon: FontAwesomeIcons.github,
                    link: "https://github.com/ctrl-aziz",
                  ),
                  const SocialIcon(
                    label: "تويتر",
                    bg: Colors.black,
                    iconColor: Colors.white,
                    icon: FontAwesomeIcons.twitter,
                    link: "https://x.com/ctrl_aziz",
                  ),
                  const SocialIcon(
                    label: "يوتيوب",
                    bg: Colors.red,
                    iconColor: Colors.white,
                    icon: FontAwesomeIcons.youtube,
                    link: "https://youtube.com/@ctrl-aziz",
                  ),
                  const SocialIcon(
                    label: "فيسبوك",
                    bg: Colors.blue,
                    iconColor: Colors.white,
                    icon: FontAwesomeIcons.facebook,
                    link: "https://www.facebook.com/ctrl.aziz",
                  ),
                  SocialIcon(
                    label: "البريد الالكتروني",
                    bg: Colors.yellow.shade900,
                    iconColor: Colors.white,
                    icon: FontAwesomeIcons.solidEnvelope,
                    link: "mailchimp:ctrlaziz0@gmail.com",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SocialIcon extends StatelessWidget {
  final String label;
  final Color bg;
  final Color iconColor;
  final String link;
  final IconData icon;

  const SocialIcon({
    super.key,
    required this.label,
    required this.bg,
    required this.iconColor,
    required this.icon,
    required this.link,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      color: bg,
      child: ListTile(
        onTap: () => launchUrl(Uri.parse(link)),
        title: Text(
          label,
          style: GoogleFonts.cairo(color: Colors.white),
        ),
        leading: Icon(
          icon,
          color: iconColor,
        ),
      ),
    );
  }
}
