import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasklink/common/widgets/primary_app_bar.dart';
import 'package:tasklink/common/widgets/primary_button.dart';
import 'package:tasklink/features/settings/screens/widgets/settings_list_tile.dart';
import 'package:tasklink/features/settings/screens/widgets/settings_mode_toggle.dart';
import 'package:tasklink/features/settings/screens/widgets/settings_section_header.dart';
import 'package:tasklink/features/settings/screens/widgets/settings_switch_tile.dart';
import 'package:tasklink/features/settings/screens/widgets/settings_card.dart';
import '../../../../../utils/constants/colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF23220f) : const Color(0xFFf8f8f5),
      appBar: const PrimaryAppBar(title: 'Settings'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SettingsSectionHeader(title: 'Account', isDark: isDark),
            SettingsCard(
              isDark: isDark,
              children: [
                SettingsModeToggle(isDark: isDark),
              ],
            ),
            
            const SizedBox(height: 24),
            SettingsSectionHeader(title: 'Account Security', isDark: isDark),
            SettingsCard(
              isDark: isDark,
              children: [
                SettingsListTile(icon: Icons.lock, iconBg: TColors.primary, title: 'Change Password', isDark: isDark, onTap: () {}),
                _buildDivider(isDark),
                SettingsListTile(icon: Icons.verified_user, iconBg: TColors.primary, title: 'Two-Factor Authentication', isDark: isDark, onTap: () {}),
                _buildDivider(isDark),
                SettingsListTile(icon: Icons.delete, iconBg: Colors.red[100]!, title: 'Delete Account', isDark: isDark, isCrimson: true, onTap: () {}),
              ],
            ),
            
            const SizedBox(height: 24),
            SettingsSectionHeader(title: 'Notifications', isDark: isDark),
            SettingsCard(
              isDark: isDark,
              children: [
                SettingsSwitchTile(icon: Icons.notifications, iconBg: TColors.primary, title: 'Push Notifications', value: true, isDark: isDark),
                _buildDivider(isDark),
                SettingsSwitchTile(icon: Icons.mail, iconBg: TColors.primary, title: 'Email Updates', value: true, isDark: isDark),
                _buildDivider(isDark),
                SettingsSwitchTile(icon: Icons.sms, iconBg: TColors.primary, title: 'SMS Alerts', value: false, isDark: isDark),
              ],
            ),
            
            const SizedBox(height: 24),
            SettingsSectionHeader(title: 'App Info & Legal', isDark: isDark),
            SettingsCard(
              isDark: isDark,
              children: [
                SettingsListTile(icon: Icons.description, iconBg: TColors.primary, title: 'Terms of Service', isDark: isDark, onTap: () {}),
                _buildDivider(isDark),
                SettingsListTile(icon: Icons.policy, iconBg: TColors.primary, title: 'Privacy Policy', isDark: isDark, onTap: () {}),
                _buildDivider(isDark),
                SettingsListTile(icon: Icons.help, iconBg: TColors.primary, title: 'Help Center', isDark: isDark, showExternalIcon: true, onTap: () {}),
              ],
            ),
            
            const SizedBox(height: 24),
            PrimaryButton(
              onPressed: () {},
              text: 'Log Out',
            ),
            const SizedBox(height: 16),
            Text('TaskLink for iOS v1.2.4 (Build 405)', style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      height: 1,
      thickness: 1,
      color: isDark ? Colors.grey[800] : Colors.grey[200],
    );
  }
}

