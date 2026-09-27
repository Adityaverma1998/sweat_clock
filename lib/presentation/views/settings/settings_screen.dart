import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/localization/localization_ext.dart';
import '../../../core/theme/theme_ext.dart';
import '../../viewmodels/settings_viewmodel.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SettingsViewModel>();

    return Scaffold(
      backgroundColor: context.bgBase,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: context.textPrimary, size: 20),
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
          context.translate('settings'),
          style: TextStyle(
            color: context.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Audio & Haptics ───────────────────────────────────────
            _buildSectionHeader(context.translate('audio_feel')),
            _buildSectionContainer(context, [
              _buildSwitchTile(
                context: context,
                icon: Icons.volume_up_rounded,
                iconColor: Colors.amber,
                title: context.translate('sound_effects'),
                subtitle: context.translate('sound_effects_desc'),
                value: viewModel.soundEffects,
                onChanged: (val) => viewModel.toggleSoundEffects(val),
              ),
              _buildDivider(context),
              _buildSwitchTile(
                context: context,
                icon: Icons.record_voice_over_rounded,
                iconColor: Colors.blueAccent,
                title: context.translate('voice_cues'),
                subtitle: context.translate('voice_cues_desc'),
                value: viewModel.voiceCues,
                onChanged: (val) => viewModel.toggleVoiceCues(val),
              ),
              _buildDivider(context),
              _buildSwitchTile(
                context: context,
                icon: Icons.vibration_rounded,
                iconColor: Colors.purpleAccent,
                title: context.translate('vibration'),
                subtitle: context.translate('vibration_desc'),
                value: viewModel.vibration,
                onChanged: (val) => viewModel.toggleVibration(val),
              ),
              _buildDivider(context),
              _buildSwitchTile(
                context: context,
                icon: Icons.timer_outlined,
                iconColor: Colors.orangeAccent,
                title: context.translate('countdown_vibration'),
                subtitle: context.translate('countdown_vibration_desc'),
                value: viewModel.countdownVibration,
                onChanged: (val) => viewModel.toggleCountdownVibration(val),
              ),
            ]),
            const SizedBox(height: 24),

            // ── Display ───────────────────────────────────────────────
            _buildSectionHeader(context.translate('display')),
            _buildSectionContainer(context, [
              _buildSwitchTile(
                context: context,
                icon: Icons.dark_mode_rounded,
                iconColor: Colors.cyanAccent,
                title: context.translate('dark_mode'),
                subtitle: context.translate('dark_mode_desc'),
                value: viewModel.isDarkMode,
                onChanged: (val) => viewModel.toggleDarkMode(val),
              ),
              _buildDivider(context),
              _buildSwitchTile(
                context: context,
                icon: Icons.screen_lock_rotation_rounded,
                iconColor: Colors.tealAccent,
                title: context.translate('keep_screen_on'),
                subtitle: context.translate('keep_screen_on_desc'),
                value: viewModel.keepScreenOn,
                onChanged: (val) => viewModel.toggleKeepScreenOn(val),
              ),
            ]),
            const SizedBox(height: 24),

            // ── General ───────────────────────────────────────────────
            _buildSectionHeader(context.translate('general')),
            _buildSectionContainer(context, [
              _buildNavigationTile(
                context: context,
                icon: Icons.language_rounded,
                iconColor: Colors.greenAccent,
                title: context.translate('language'),
                value: viewModel.language,
                onTap: () => _showLanguageSelector(context, viewModel),
              ),
            ]),
            const SizedBox(height: 36),

            // ── Minimal About Card ─────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: context.bgSurface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: context.borderSubtle),
              ),
              child: Column(
                children: [
                  Text(
                    'SweatClock',
                    style: TextStyle(
                      color: context.textPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    context.translate('version'),
                    style: TextStyle(
                      color: context.textMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
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
      child: Column(children: children),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(height: 1, indent: 60, endIndent: 20, color: context.borderSubtle);
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: context.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: context.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeTrackColor: context.accent,
            activeThumbColor: Colors.white,
          ),
        ],
      ),
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: context.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (value.isNotEmpty) ...[
              Text(
                value,
                style: TextStyle(
                  color: context.textMuted,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 6),
            ],
            Icon(Icons.arrow_forward_ios_rounded, size: 14, color: context.textMuted),
          ],
        ),
      ),
    );
  }

  void _showLanguageSelector(BuildContext context, SettingsViewModel viewModel) {
    const languages = [
      'English',
      'Español',
      'Français',
      'Deutsch',
      '日本語',
      'हिन्दी',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: context.bgSurface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(top: BorderSide(color: context.borderSubtle)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.borderDefault,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              context.translate('select_language'),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: context.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            ...languages.map((lang) {
              final isSelected = viewModel.language == lang;
              return ListTile(
                title: Text(
                  lang,
                  style: TextStyle(
                    color: isSelected ? context.accent : context.textPrimary,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
                trailing: isSelected
                    ? Icon(Icons.check_rounded, color: context.accent)
                    : null,
                onTap: () {
                  viewModel.changeLanguage(lang);
                  Navigator.pop(ctx);
                },
              );
            }),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
