import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PremiumBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const PremiumBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return SafeArea(
      // 👈 Move SafeArea to the TOP
      bottom: true,
      top: false,
      left: false,
      right: false, // Only apply to bottom
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 25,
              spreadRadius: 1,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Container(
            height: 84, // 👈 Fixed height here is now safe!
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[900] : Colors.white,
            ),
            child: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: onTap,
              elevation: 0,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              selectedItemColor: theme.primaryColor,
              unselectedItemColor: isDarkMode
                  ? Colors.grey[400]
                  : Colors.grey[600],
              items: [
                _buildNavItem(
                  iconPath: 'assets/icons/home.svg',
                  isActive: currentIndex == 0,
                  theme: theme,
                ),
                _buildNavItem(
                  iconPath: 'assets/icons/inventory-alt.svg',
                  isActive: currentIndex == 1,
                  theme: theme,
                ),
                _buildNavItem(
                  iconPath: 'assets/icons/settings.svg',
                  isActive: currentIndex == 2,
                  theme: theme,
                ),
                _buildNavItem(
                  iconPath: 'assets/icons/user-gear.svg',
                  isActive: currentIndex == 3,
                  theme: theme,
                ),
                _buildNavItem(
                  iconPath: 'assets/icons/circle-user.svg',
                  isActive: currentIndex == 4,
                  theme: theme,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem({
    required String iconPath,
    required bool isActive,
    required ThemeData theme,
  }) {
    return BottomNavigationBarItem(
      icon: Transform.translate(
        offset: const Offset(0, 4), // 👈 moves icon 4 pixels down
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive
                ? theme.primaryColor.withOpacity(0.15)
                : Colors.transparent,
          ),
          child: SvgPicture.asset(
            iconPath,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              isActive ? theme.primaryColor : Colors.grey[600]!,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
      label: '',
    );
  }
}
