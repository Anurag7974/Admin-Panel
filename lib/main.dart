import 'package:admincontrol/providers/dark_theme_provider.dart';
import 'package:admincontrol/screens/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'consts/theme_data.dart';
import 'controllers/MenuController.dart';
import 'inner_screen/add_banners.dart';
import 'inner_screen/add_news_list.dart';
import 'inner_screen/add_prod.dart';
import 'inner_screen/add_tasks.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
    options:const FirebaseOptions(
      apiKey: "AIzaSyDVNQvwINGoH_VDjQmIKatYNDH-mdLPKmQ",
      projectId: "btcmining-bf56f",
      messagingSenderId: "961887182019",
      storageBucket: "btcmining-bf56f.appspot.com",
      appId: "1:961887182019:web:f8627cdcbc98154cf61676",
    )
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme = await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: _initialization, builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: Center(
              child: CircularProgressIndicator(),),
          ),
        );
      } else if (snapshot.hasError) {
        const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: Center(
              child: Text('An error occurred'),),
          ),
        );
      }
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => menuController(),),
          ChangeNotifierProvider(create: (_) {return themeChangeProvider;},
        ),
      ],
      child: Consumer<DarkThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Grocery',
            theme: Styles.themeData(themeProvider.getDarkTheme, context),
            home: const MainScreen(),
            routes: {
              UploadProductForm.routeName: (context) => const UploadProductForm(),
              UploadBannersForm.routeName: (context) => const UploadBannersForm(),
              AddNewsListScreen.routeName: (context) => const AddNewsListScreen(),
              AddTasksScreen.routeName: (context) => const AddTasksScreen(),
            },
          );
        },
      ),
    );
  });
}
}
