import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stop_watch/core/theme/theme_ext.dart';
import 'package:stop_watch/providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      backgroundColor: context.bgBase,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: context.textPrimary, size: 20),
          style: IconButton.styleFrom(
            backgroundColor: context.bgSurface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: context.borderSubtle),
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            color: context.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('AUDIO & FEEL'),
            _buildSectionContainer(
              context,
              [
                _buildSwitchTile(
                  context: context,
                  icon: Icons.volume_up_rounded,
                  iconColor: Colors.amber,
                  title: 'Sound Effects',
                  subtitle: 'Tones for phase transitions',
                  value: settings.soundEffects,
                  onChanged: (val) => settings.toggleSoundEffects(val),
                ),
                _buildDivider(context),
                _buildSwitchTile(
                  context: context,
                  icon: Icons.vibration_rounded,
                  iconColor: Colors.pinkAccent,
                  title: 'Vibration',
                  subtitle: 'Haptic feedback on ticks',
                  value: settings.vibration,
                  onChanged: (val) => settings.toggleVibration(val),
                ),
                _buildDivider(context),
                _buildSwitchTile(
                  context: context,
                  icon: Icons.record_voice_over_rounded,
                  iconColor: Colors.blueAccent,
                  title: 'Voice Cues',
                  subtitle: 'Announce phase names',
                  value: settings.voiceCues,
                  onChanged: (val) => settings.toggleVoiceCues(val),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSectionHeader('DISPLAY'),
            _buildSectionContainer(
              context,
              [
                _buildSwitchTile(
                  context: context,
                  icon: Icons.dark_mode_rounded,
                  iconColor: Colors.purpleAccent,
                  title: 'Dark Mode',
                  subtitle: 'Cool neon dark palette',
                  value: settings.isDarkMode,
                  onChanged: (val) => settings.toggleDarkMode(val),
                ),
                _buildDivider(context),
                _buildSwitchTile(
                  context: context,
                  icon: Icons.screen_lock_rotation_rounded,
                  iconColor: Colors.tealAccent,
                  title: 'Keep Screen On',
                  subtitle: 'Prevent auto sleep on timer',
                  value: settings.keepScreenOn,
                  onChanged: (val) => settings.toggleKeepScreenOn(val),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSectionHeader('GENERAL'),
            _buildSectionContainer(
              context,
              [
                _buildNavigationTile(
                  context: context,
                  icon: Icons.language_rounded,
                  iconColor: Colors.greenAccent,
                  title: 'Language',
                  value: settings.language,
                  onTap: () => _showLanguageSelector(context, settings),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // About SweatClock card matching premium aesthetic
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: context.bgSurface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: context.borderSubtle),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: context.accent.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.flash_on_rounded, color: context.accent, size: 28),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'SweatClock',
                    style: TextStyle(
                      fontFamily: 'Bebas Neue',
                      fontSize: 28,
                      letterSpacing: 1.5,
                      color: context.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Version 1.0.0 (5)',
                    style: TextStyle(
                      color: context.textMuted,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Crafted with ❤️ for athletes and solo fitness enthusiasts worldwide.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: context.textSecondary,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.5,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildSectionContainer(BuildContext context, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: context.bgSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.borderSubtle),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: context.textPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: context.textMuted,
          fontSize: 12,
        ),
      ),
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeColor: context.accent,
      ),
      tileColor: Colors.transparent,
    );
  }

  Widget _buildNavigationTile({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: context.textPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              color: context.textMuted,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.arrow_forward_ios_rounded, color: context.textMuted, size: 14),
        ],
      ),
      tileColor: Colors.transparent,
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(
      color: context.borderSubtle,
      height: 1,
      indent: 56,
    );
  }

  void _showLanguageSelector(BuildContext context, SettingsProvider settings) {
    final languages = ['English', 'Español', 'Français', 'Deutsch', '日本語'];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Language',
                style: TextStyle(
                  color: context.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: languages.length,
                  itemBuilder: (context, index) {
                    final lang = languages[index];
                    final isSelected = settings.language == lang;
                    return ListTile(
                      onTap: () {
                        settings.changeLanguage(lang);
                        Navigator.pop(context);
                      },
                      title: Text(
                        lang,
                        style: TextStyle(
                          color: isSelected ? context.accent : context.textPrimary,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(Icons.check_rounded, color: context.accent, size: 22)
                          : null,
                      tileColor: Colors.transparent,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
