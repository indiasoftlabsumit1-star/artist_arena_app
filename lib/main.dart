
import 'package:artist_arena_app/Controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (p0, p1, p2) {
      return GetMaterialApp(
 debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Color(0xffF9FAFC),

          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xffF9FAFC) , // Surface background ke same color
            surfaceTintColor: Colors.transparent, // Scroll hone par tint color hatane ke liye
            scrolledUnderElevation: 0.0, // Scroll par color change na ho
            elevation: 0, // Shadow hatane ke liye (optional)
          ),
        ),
        home: SplashScreen(),
      );
    },);
  }
}

class SplashScreen extends StatefulWidget {

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  AuthController controller=Get.put(AuthController());



@override
void initState() {
    // TODO: implement initState
    super.initState();
    controller.login();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Image.asset(
          'assets/images/splashimg.webp',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}


