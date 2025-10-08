import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

/// Bottom navigation bar widget
/// Matches the web app's navigation with 5 tabs:
/// Home, Stream, Cube, Notifications, Profile
class BottomNav extends StatelessWidget {
  final String currentPage;
  final int unreadCount;
  final VoidCallback? onHomeTap;
  final VoidCallback? onStreamTap;
  final VoidCallback? onCubeTap;
  final VoidCallback? onNotificationsTap;
  final VoidCallback? onProfileTap;

  const BottomNav({
    super.key,
    required this.currentPage,
    this.unreadCount = 0,
    this.onHomeTap,
    this.onStreamTap,
    this.onCubeTap,
    this.onNotificationsTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.overlayDark,
        border: Border(
          top: BorderSide(
            color: AppColors.borderPrimary,
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Home',
                isActive: currentPage == 'home',
                onTap: onHomeTap ?? () => context.go('/home'),
              ),
              _NavItem(
                icon: Icons.stream_outlined,
                activeIcon: Icons.stream,
                label: 'Stream',
                isActive: currentPage == 'stream',
                onTap: onStreamTap ?? () => context.go('/stream'),
              ),
              _NavItem(
                icon: Icons.view_in_ar_outlined,
                activeIcon: Icons.view_in_ar,
                label: 'Cube',
                isActive: currentPage == 'cube',
                onTap: onCubeTap ?? () {
                  // TODO: Navigate to cube page
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Cube page - Coming soon!'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                isCube: true, // Special styling for cube icon
              ),
              _NavItem(
                icon: Icons.notifications_outlined,
                activeIcon: Icons.notifications,
                label: 'Notifications',
                isActive: currentPage == 'notifications',
                badgeCount: unreadCount,
                onTap: onNotificationsTap ?? () {
                  // TODO: Navigate to notifications
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Notifications - Coming soon!'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
              _NavItem(
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Profile',
                isActive: currentPage == 'profile',
                onTap: onProfileTap ?? () {
                  // TODO: Navigate to current user's profile
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile - Coming soon!'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final int badgeCount;
  final VoidCallback? onTap;
  final bool isCube;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    this.badgeCount = 0,
    this.onTap,
    this.isCube = false,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = isActive ? AppColors.iosGreen : AppColors.iosGray;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        splashColor: AppColors.primary.withOpacity(0.1),
        highlightColor: AppColors.primary.withOpacity(0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Icon
                Icon(
                  isActive ? activeIcon : icon,
                  color: iconColor,
                  size: isCube ? 28 : 24,
                  shadows: isCube && isActive
                      ? [
                          Shadow(
                            color: AppColors.primary.withOpacity(0.6),
                            blurRadius: 12,
                          ),
                        ]
                      : null,
                ),

                // Notification Badge
                if (badgeCount > 0)
                  Positioned(
                    right: -8,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.notificationBadge,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      constraints: const BoxConstraints(minWidth: 18),
                      child: Text(
                        badgeCount > 99 ? '99+' : '$badgeCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 4),

            // Label
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: iconColor,
                letterSpacing: -0.2,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
