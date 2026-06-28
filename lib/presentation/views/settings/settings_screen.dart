import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/localization/localization_ext.dart';
import '../../../core/theme/theme_ext.dart';
import '../../viewmodels/settings_viewmodel.dart';
import '../coffee/coffee_screen.dart';

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
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: context.textPrimary,
            size: 20,
          ),
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
            // _buildSectionHeader(context.translate('audio_feel')),
            // _buildSectionContainer(
            //   context,
            //   [
            //     _buildSwitchTile(
            //       context: context,
            //       icon: Icons.volume_up_rounded,
            //       iconColor: Colors.amber,
            //       title: context.translate('sound_effects'),
            //       subtitle: context.translate('sound_effects_desc'),
            //       value: viewModel.soundEffects,
            //       onChanged: (val) => viewModel.toggleSoundEffects(val),
            //     ),
            //     _buildDivider(context),
            //     _buildSwitchTile(
            //       context: context,
            //       icon: Icons.vibration_rounded,
            //       iconColor: Colors.pinkAccent,
            //       title: context.translate('vibration'),
            //       subtitle: context.translate('vibration_desc'),
            //       value: viewModel.vibration,
            //       onChanged: (val) => viewModel.toggleVibration(val),
            //     ),
            //     _buildDivider(context),
            //     _buildSwitchTile(
            //       context: context,
            //       icon: Icons.edgesensor_high_rounded,
            //       iconColor: Colors.deepOrangeAccent,
            //       title: context.translate('countdown_vibration'),
            //       subtitle: context.translate('countdown_vibration_desc'),
            //       value: viewModel.countdownVibration,
            //       onChanged: (val) => viewModel.toggleCountdownVibration(val),
            //     ),
            //     _buildDivider(context),
            //     _buildSwitchTile(
            //       context: context,
            //       icon: Icons.record_voice_over_rounded,
            //       iconColor: Colors.blueAccent,
            //       title: context.translate('voice_cues'),
            //       subtitle: context.translate('voice_cues_desc'),
            //       value: viewModel.voiceCues,
            //       onChanged: (val) => viewModel.toggleVoiceCues(val),
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 24),
            _buildSectionHeader(context.translate('display')),
            _buildSectionContainer(context, [
              _buildSwitchTile(
                context: context,
                icon: Icons.dark_mode_rounded,
                iconColor: Colors.purpleAccent,
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
                    child: Icon(
                      Icons.flash_on_rounded,
                      color: context.accent,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    context.translate('title'),
                    style: TextStyle(
                      fontFamily: 'Bebas Neue',
                      fontSize: 28,
                      letterSpacing: 1.5,
                      color: context.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    context.translate('version'),
                    style: TextStyle(
                      color: context.textMuted,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    context.translate('about_card_desc'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: context.textSecondary,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 18),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CoffeeScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: context.accent.withOpacity(0.15),
                        border: Border.all(
                          color: context.accentLight.withOpacity(0.35),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        context.translate('buy_coffee'),
                        style: TextStyle(
                          color: context.accentLight,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
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
    return Material(
      color: context.bgSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: context.borderSubtle),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
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
        style: TextStyle(color: context.textMuted, fontSize: 12),
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
          Icon(
            Icons.arrow_forward_ios_rounded,
            color: context.textMuted,
            size: 14,
          ),
        ],
      ),
      tileColor: Colors.transparent,
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(color: context.borderSubtle, height: 1, indent: 56);
  }

  void _showLanguageSelector(
    BuildContext context,
    SettingsViewModel viewModel,
  ) {
    final languages = [
      'English',
      'Español',
      'Français',
      'Deutsch',
      '日本語',
      'Hindi',
    ];

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
                context.translate('select_language'),
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
                    final isSelected = viewModel.language == lang;
                    return ListTile(
                      onTap: () {
                        viewModel.changeLanguage(lang);
                        Navigator.pop(context);
                      },
                      title: Text(
                        lang,
                        style: TextStyle(
                          color: isSelected
                              ? context.accent
                              : context.textPrimary,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(
                              Icons.check_rounded,
                              color: context.accent,
                              size: 22,
                            )
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
