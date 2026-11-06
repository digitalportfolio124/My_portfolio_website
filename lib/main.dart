import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
      url: 'https://kjutcyqxyfcwithltroh.supabase.co',
      publishableKey: 'sb_publishable_hIDnqih5L9zN9szCWyKx3Q_fKFzrpgx',
  );

  runApp(const PortfolioApp());


  //Passion one
  //Righteous
  //Barlow Condensed
}