import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'Landing.dart';
import 'Network/connectivity_service.dart';
import 'Network/connectivity_status.dart';
import 'SplashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<ConnectivityStatus>(
      initialData: ConnectivityStatus.Offline,
      create: (BuildContext context) =>
          ConnectivityService().connectionStatusController.stream,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ScreenUtilInit(
            allowFontScaling: false,
            designSize: Size(constraints.maxWidth, constraints.maxHeight),
            builder: () => MaterialApp(
              debugShowCheckedModeBanner: false,
              home: SplashScreen(),
            ),
          );
        },
      ),
    );
  }
}
