import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loyalty_admin/routes/app_pages.dart';
import 'package:loyalty_admin/routes/app_routes.dart';
import 'package:loyalty_admin/services/app_info_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInfoService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final shortestSide = constraints.maxWidth < constraints.maxHeight
            ? constraints.maxWidth
            : constraints.maxHeight;
        // Tablets get a tablet-scale design size so ScreenUtil's scale factor
        // stays near 1× instead of ballooning everything ~2x on the wider screen.
        final isTablet = shortestSide >= 600;
        final designSize = isTablet
            ? const Size(768, 1024)
            : const Size(375, 812);

        return ScreenUtilInit(
          designSize: designSize,
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
        return GetMaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.login,
          getPages: AppPages.pages,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
            ),
            useMaterial3: true,
          ),
          home: child,
        );
          },
          child: const SizedBox.shrink(),
        );
      },
    );
  }
}