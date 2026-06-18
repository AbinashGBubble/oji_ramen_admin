import 'package:flutter/material.dart';
import 'package:loyalty_admin/constant/app_colors.dart';

/// The active tab to highlight in [AppBottomNavBar].
///
/// Use [AppBottomNavBarTab.none] when the current screen sits outside the
/// normal tab flow (e.g. the Enter-Manually / QR-search screen).
enum AppBottomNavBarTab { home, users, stats, settings, none }

/// A shared, floating bottom-navigation bar used across all main screens.
///
/// Renders the four primary nav items (Home, Users, Stats, Settings).
/// The currently-active item is highlighted in the brand primary colour.
/// Tapping a tab invokes [onTabSelected]; the host widget is responsible
/// for the actual navigation / page switch so this widget stays stateless.
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    this.activeTab = AppBottomNavBarTab.none,
    required this.onTabSelected,
  });

  /// Which tab should appear selected.
  final AppBottomNavBarTab activeTab;

  /// Called when the user taps a tab; receives the tapped [AppBottomNavBarTab].
  final void Function(AppBottomNavBarTab tab) onTabSelected;

  static const _kActiveColor = Color(0xFFD7425B);
  static const _kInactiveColor = Colors.grey;

  static const _items = [
    _NavItemData(
      icon: Icons.home_rounded,
      label: 'Home',
      tab: AppBottomNavBarTab.home,
    ),
    _NavItemData(
      icon: Icons.people_alt_outlined,
      label: 'Users',
      tab: AppBottomNavBarTab.users,
    ),
    _NavItemData(
      icon: Icons.bar_chart_rounded,
      label: 'Stats',
      tab: AppBottomNavBarTab.stats,
    ),
    _NavItemData(
      icon: Icons.settings_outlined,
      label: 'Settings',
      tab: AppBottomNavBarTab.settings,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _items
              .map(
                (item) => _NavItem(
                  data: item,
                  isSelected: activeTab == item.tab,
                  activeColor: _kActiveColor,
                  inactiveColor: _kInactiveColor,
                  onTap: () => onTabSelected(item.tab),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Internal helpers (private to this file)
// ---------------------------------------------------------------------------

class _NavItemData {
  const _NavItemData({
    required this.icon,
    required this.label,
    required this.tab,
  });

  final IconData icon;
  final String label;
  final AppBottomNavBarTab tab;
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.data,
    required this.isSelected,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
  });

  final _NavItemData data;
  final bool isSelected;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? activeColor : inactiveColor;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(data.icon, size: 26, color: color),
            const SizedBox(height: 4),
            Text(
              data.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
