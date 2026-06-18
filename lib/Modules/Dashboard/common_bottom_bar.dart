import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loyalty_admin/Modules/Dashboard/permission_controller.dart';
import 'package:loyalty_admin/modules/Auth/login_controller.dart';
import 'package:loyalty_admin/modules/Dashboard/app_bottom_nav_bar.dart';
import 'package:loyalty_admin/modules/Dashboard/pwaWebview_screen.dart';
import 'package:loyalty_admin/routes/app_routes.dart';
import 'package:loyalty_admin/services/storage/secure_storage_service.dart';

class CommonBottomBar extends StatefulWidget {
  const CommonBottomBar({super.key});

  @override
  State<CommonBottomBar> createState() => _CommonBottomBarState();
}

class _CommonBottomBarState extends State<CommonBottomBar> {
  int selectedIndex = 0;

  String adminName = '';
  String adminEmail = '';

  late PermissionController permissionController;

   final Set<int> _visitedIndices = {0};

   final _dashboardKey = PwaWebViewKey();

  static const List<({String title, String url})> _pageConfig = [
    (
      title: "Dashboard",
      url: "https://master.d1qi4h2imco1od.amplifyapp.com?source=flutter",
    ),
    (
      title: "Users",
      url:
          "https://master.d1qi4h2imco1od.amplifyapp.com/users?source=flutter",
    ),
    (
      title: "Analytics",
      url:
          "https://master.d1qi4h2imco1od.amplifyapp.com/analytics?source=flutter",
    ),
    (
      title: "Settings",
      url:
          "https://master.d1qi4h2imco1od.amplifyapp.com/settings?source=flutter",
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Support deep-linking into a specific tab by passing an int argument:
    //   Get.offAllNamed(AppRoutes.home, arguments: {'initialTab': 2})
    final args = Get.arguments;
    if (args is Map && args['initialTab'] is int) {
      final tab = args['initialTab'] as int;
      if (tab >= 0 && tab < _pageConfig.length) {
        selectedIndex = tab;
        _visitedIndices.add(tab);
      }
    }
    _loadAdminInfo();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );

    permissionController = Get.put(PermissionController(), permanent: true);

    permissionController.loadPermissions();
  }

  Future<void> _loadAdminInfo() async {
    final user = await SecureStorageService.getUser();
    if (user != null && mounted) {
      setState(() {
        adminName = user['name'] ?? '';
        adminEmail = user['email'] ?? '';
      });
    }
  }

  void _showProfileMenu(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    showMenu<String>(
      context: context,
      position: position,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 8,
      items: [
        PopupMenuItem<String>(
          enabled: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                adminName.isNotEmpty ? adminName : 'Admin',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
              if (adminEmail.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  adminEmail,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ],
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem<String>(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout_rounded, size: 18, color: Color(0xFFD7425B)),
              SizedBox(width: 10),
              Text(
                'Logout',
                style: TextStyle(
                  color: Color(0xFFD7425B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value == 'logout') _confirmLogout();
    });
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD7425B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              LoginController.handleLogout(); // ← static call, no Get.find/put
            },
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        title: Row(
          children: [
            Image(
              image: AssetImage('assets/icons/Oji_log.png'),
              height: 40,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Oji Ramen',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                Text(
                  'Rewards Admin',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Builder(
            builder: (ctx) => GestureDetector(
              onTap: () => _showProfileMenu(ctx),
              child: Container(
                margin: const EdgeInsets.only(right: 16),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: const Icon(
                  Icons.person_outline_rounded,
                  size: 22,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: Colors.grey.shade200),
        ),
      ),

      body: IndexedStack(
        index: selectedIndex,
        children: List.generate(_pageConfig.length, (i) {
          if (!_visitedIndices.contains(i)) return const SizedBox.shrink();
          final cfg = _pageConfig[i];
          return PwaWebViewScreen(
            key: i == 0 ? _dashboardKey : null,   // ← key only on Dashboard
            title: cfg.title,
            url: cfg.url,
          );
        }),
      ),

      floatingActionButton: GestureDetector(
        onTap: () => Get.toNamed(AppRoutes.scanQr),
        child: Container(
          height: 72,
          width: 72,
          decoration: BoxDecoration(
            color: const Color(0xFF2E7D32),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.qr_code_2, color: Colors.white, size: 30),
              SizedBox(height: 2),
              Text(
                "QR",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: AppBottomNavBar(
        activeTab: _indexToTab(selectedIndex),
        onTabSelected: _onNavTabSelected,
      ),
    );
  }

  // Maps the int page index to the enum used by AppBottomNavBar.
  AppBottomNavBarTab _indexToTab(int index) {
    switch (index) {
      case 0:
        return AppBottomNavBarTab.home;
      case 1:
        return AppBottomNavBarTab.users;
      case 2:
        return AppBottomNavBarTab.stats;
      case 3:
        return AppBottomNavBarTab.settings;
      default:
        return AppBottomNavBarTab.none;
    }
  }

  void _onNavTabSelected(AppBottomNavBarTab tab) {
    final index = tab.index; // enum order matches page index order
    if (index == 0 && selectedIndex == 0) {
      _dashboardKey.currentState?.reloadToHome();
    } else if (index == 0) {
      setState(() {
        selectedIndex = 0;
        _visitedIndices.add(0);
      });
      Future.delayed(const Duration(milliseconds: 100), () {
        _dashboardKey.currentState?.reloadToHome();
      });
    } else {
      setState(() {
        selectedIndex = index;
        _visitedIndices.add(index);
      });
    }
  }

}
