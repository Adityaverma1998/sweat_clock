import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/localization/localization_ext.dart';
import '../../../core/theme/theme_ext.dart';
import '../../viewmodels/home_viewmodel.dart';
import '../home/home_screen.dart';
import '../coffee/coffee_screen.dart';
import '../../../widgets/confetti_view.dart';
import 'dart:math' as math;

class CongratulationScreen extends StatefulWidget {
  const CongratulationScreen({super.key});

  @override
  State<CongratulationScreen> createState() => _CongratulationScreenState();
}

class _CongratulationScreenState extends State<CongratulationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final ScreenshotController _screenshotController = ScreenshotController();
  bool _isSharing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeViewModel = context.watch<HomeViewModel>();

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: context.bgBase,
        body: Stack(
          children: [
            const ConfettiView(),
            SafeArea(
              child: Column(
                children: [
                  _buildTopBar(context),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // ── Shareable card ──────────────────────────────
                          Screenshot(
                            controller: _screenshotController,
                            child: Container(
                              decoration: BoxDecoration(
                                color: context.bgBase,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  _buildStatsRow(context, homeViewModel),
                                  const SizedBox(height: 30),
                                  _buildTrophyArea(context),
                                  const SizedBox(height: 30),
                                  _buildStreakPill(context),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildCoffeeNudge(context),
                          const SizedBox(height: 20),
                          _buildActionButtons(context),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const SizedBox(width: 48),
          const Spacer(),
          Text(
            context.translate('title'),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: context.textPrimary,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, HomeViewModel homeViewModel) {
    final totalSec = homeViewModel.totalSeconds;
    final min = totalSec ~/ 60;
    final sec = totalSec % 60;
    final timeStr = '${min}:${sec.toString().padLeft(2, '0')}';

    return Row(
      children: [
        Expanded(
          child: _buildStatBox(
            context,
            '${homeViewModel.totalRounds}',
            context.translate('rounds'),
            context.prep,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatBox(
            context,
            timeStr,
            context.translate('total_time'),
            context.workout,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatBox(
            context,
            '100%',
            context.translate('done'),
            context.success,
          ),
        ),
      ],
    );
  }

  Widget _buildStatBox(
      BuildContext context, String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: context.bgSurface,
        border: Border.all(color: context.borderSubtle),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: context.shadowColor.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 9,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
              color: context.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrophyArea(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _controller.value * 2 * math.pi,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: context.gold.withOpacity(0.25),
                        width: 1.5,
                      ),
                    ),
                  ),
                );
              },
            ),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.rotate(
                  angle: -(_controller.value * 2 * math.pi),
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: context.gold.withOpacity(0.15),
                        width: 1,
                      ),
                    ),
                  ),
                );
              },
            ),
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [context.gold.withOpacity(0.3), Colors.transparent],
                  stops: const [0.0, 0.7],
                ),
              ),
            ),
            const Text(
              '🏆',
              style: TextStyle(fontSize: 72),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'WORKOUT\nCOMPLETE!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 32,
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
            color: context.gold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "You crushed all rounds!\nYou're absolutely unstoppable 💪",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            height: 1.5,
            color: context.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildStreakPill(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: context.successBg,
        border: Border.all(color: context.success.withOpacity(0.25)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🔥', style: TextStyle(fontSize: 14)),
          const SizedBox(width: 8),
          Text(
            "3-day streak — you're on fire!",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: context.success,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoffeeNudge(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CoffeeScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [context.accentBg, context.accentBg.withOpacity(0.04)],
          ),
          border: Border.all(color: context.accentBorder),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: context.shadowColor.withOpacity(0.1),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Text('☕', style: TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Love SweatClock?",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: context.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Buy me a coffee — starts at \$1.99",
                    style: TextStyle(fontSize: 11, color: context.textMuted),
                  ),
                ],
              ),
            ),
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: context.accent.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.chevron_right, size: 16, color: context.accent),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: OutlinedButton(
            onPressed: _isSharing ? null : _captureAndShare,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: context.borderDefault),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: _isSharing
                ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: context.textSecondary,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.share_rounded,
                          size: 16, color: context.textSecondary),
                      const SizedBox(width: 6),
                      Text(
                        "Share",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: context.textSecondary,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.accent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.play_arrow_rounded, size: 18),
                SizedBox(width: 6),
                Text(
                  "Go Again",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _captureAndShare() async {
    setState(() => _isSharing = true);
    try {
      final imageBytes = await _screenshotController.capture(
        pixelRatio: 3.0,
      );
      if (imageBytes == null) return;

      final tempDir = await getTemporaryDirectory();
      final file = await File(
        '${tempDir.path}/sweatclock_workout.png',
      ).writeAsBytes(imageBytes);

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path, mimeType: 'image/png')],
          text: '🏆 Workout Complete! Crushed it with SweatClock 💪 #SweatClock #Fitness #WorkoutDone',
        ),
      );
    } catch (e) {
      debugPrint('Share error: $e');
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }
}
