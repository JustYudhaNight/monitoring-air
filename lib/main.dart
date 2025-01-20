import 'package:firebase_air_quality_2/screens/air_quality_card.dart';
import 'package:firebase_air_quality_2/providers/air_quality_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    // FirebaseOptions(
    // apiKey: 'AIzaSyA_M2ZaCnwnFZEf_wMzGOX_OElHmL7ZjHU',
    // appId: '1:161181161682:android:d459159de58c2ccdfcb50b',
    // messagingSenderId: '161181161682',
    // projectId: 'monitoring-air-quality-b0c30',
    // databaseURL: 'https://monitoring-air-quality-b0c30-default-rtdb.asia-southeast1.firebasedatabase.app',
    // storageBucket: 'monitoring-air-quality-b0c30.firebasestorage.app',
    // )
  );

  // Initialize locale data for Indonesian date formatting
  await initializeDateFormatting('id_ID', '');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AirQualityProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        home: const Scaffold(
          body: Padding(
            padding: EdgeInsets.all(16.0),
            child: AirQualityCard(),
          ),
        ),
      ),
    );
  }
}
