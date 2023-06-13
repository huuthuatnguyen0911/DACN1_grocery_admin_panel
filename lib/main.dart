import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grocery_admin_panel/screens/main_screen.dart';
import 'package:provider/provider.dart';

import 'consts/theme_data.dart';
import 'controllers/MenuControllerss.dart';
import 'inner_screens/add_prod.dart';
import 'providers/dark_theme_provider.dart';
// import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAxT0rKwIeWQ7AbaBHOfy-XAlus-dG9FJY",
  authDomain: "grocery-flutter-52022.firebaseapp.com",
  projectId: "grocery-flutter-52022",
  storageBucket: "grocery-flutter-52022.appspot.com",
  messagingSenderId: "798578012630",
  appId: "1:798578012630:web:3d87d8461da1dc0d30f477",
  measurementId: "G-B6GCX85WXJ"
    ),
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
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: Center(
              child: Center(
                child: Text('App is being initialized'),
              ),
            ),
          ),
        );
      } else if (snapshot.hasError) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: Center(
              child: Center(
                child: Text('An error has been occured ${snapshot.error}'),
              ),
            ),
          ),
        );
      }
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => MenuControllerss(),
          ),
          ChangeNotifierProvider(
            create: (_) {
              return themeChangeProvider;
            },
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
                  UploadProductForm.routeName: (context) =>
                      const UploadProductForm(),
                });
          },
        ),
      );
    });
  }
}