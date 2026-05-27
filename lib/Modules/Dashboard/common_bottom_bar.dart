import 'package:flutter/material.dart';
import 'package:loyalty_admin/Modules/Dashboard/dash_board_screen.dart';
import 'package:loyalty_admin/Modules/Dashboard/sample_screens.dart';
import 'package:loyalty_admin/constant/app_colors.dart';
import 'package:loyalty_admin/constant/app_icons_constant.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CommonBottomBar extends StatefulWidget {
  const CommonBottomBar({super.key});

  @override
  State<CommonBottomBar> createState() => _CommonBottomBarState();
}

class _CommonBottomBarState extends State<CommonBottomBar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    DashBoardScreen(),
    UserWebViewPage(url: "https://dev.d35eu7io5hegid.amplifyapp.com/users/?app_code=REST-7A9C21FE&app_key=B1F9C8A22D8F8BC19D7E10CE39129FB2& authorization=ggg",),
    // RedeemView(),
    // MenuView(),
    // MoreView(),
  ];

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(children: [_pages[_selectedIndex]]),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: const Color(0x1A000000),
              offset: const Offset(0, -2),
              blurRadius: 15,
            ),
          ],
        ),
        child: BottomAppBar(
          color: Colors.transparent,
          elevation: 0,
          notchMargin: 8.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(IconConsts.home, 0),
              _buildNavItem(IconConsts.user, 1),
              _buildNavItem(IconConsts.analytics, 2),
              _buildNavItem(IconConsts.menuOutlets, 3),
              _buildNavItem(IconConsts.more, 3),
            ],
          ),
        ),
      ),
    );
  }

  void _openWebView(BuildContext context, String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SafeArea(
          child: Scaffold(
            //appBar: AppBar(title: const Text("WebView")),
            body: WebViewWidget(
              controller: WebViewController()
                ..setJavaScriptMode(JavaScriptMode.unrestricted)
                ..loadRequest(Uri.parse(url)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(String icon, int index) {
    final isSelected = index == _selectedIndex;

    return GestureDetector(
      onTap: () => _onTabSelected(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image(
            image: AssetImage(icon),
            height: 24,
            color: isSelected ? const Color(0xFFFF7C0A) : Colors.black,
          ),
        ],
      ),
    );
  }
}
