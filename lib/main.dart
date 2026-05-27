import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loyalty_admin/routes/app_pages.dart';
import 'package:loyalty_admin/routes/app_routes.dart';
import 'package:loyalty_admin/services/app_info_service.dart';

void main() async {
  await dotenv.load(fileName: "env/.env");
  await AppInfoService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          initialRoute: AppRoutes.login,
          getPages: AppPages.pages,
        home: child, 
        );
      },
      child: const SizedBox.shrink(),
    );
  }
}
