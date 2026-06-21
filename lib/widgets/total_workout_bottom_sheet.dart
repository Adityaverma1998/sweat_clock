import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stop_watch/providers/home.dart';
import 'package:stop_watch/core/theme/theme_ext.dart';

void totalWorkoutBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (builder) {
      return const _RoundSelectorSheet();
    },
  );
}

class _RoundSelectorSheet extends StatefulWidget {
  const _RoundSelectorSheet();

  @override
  State<_RoundSelectorSheet> createState() => _RoundSelectorSheetState();
}

class _RoundSelectorSheetState extends State<_RoundSelectorSheet> {
  late int _selected;

  @override
  void initState() {
    super.initState();
    _selected = context.read<Home>().totalWorkout;
  }

  String _computeDuration(int rounds) {
    final home = context.read<Home>();
    final workSec = home.workoutMin * 60 + home.workoutSec;
    final restSec = home.restMin * 60 + home.restSec;
    final prepSec = home.prepMin * 60 + home.prepSec;
    final total = rounds * (workSec + restSec) + prepSec;
    final min = total ~/ 60;
    final sec = total % 60;
    return '$min:${sec.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.bgBase,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(
          color: context.accentLight.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.borderDefault,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 14),

            // Hero
            const Text('🔁', style: TextStyle(fontSize: 40)),
            const SizedBox(height: 6),
            Text(
              'HOW MANY ROUNDS?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: 3,
                color: context.accentLight,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              'Choose your workout intensity',
              style: TextStyle(fontSize: 12, color: context.textMuted),
            ),
            const SizedBox(height: 20),

            // Grid
            GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 0.95,
              children: List.generate(6, (i) {
                final rounds = i + 1;
                final isActive = rounds == _selected;
                return _buildRoundCard(context, rounds, isActive);
              }),
            ),
            const SizedBox(height: 20),

            // Set button
            GestureDetector(
              onTap: () {
                context.read<Home>().changeTotalWorkout(_selected);
                Navigator.pop(context);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [context.accent, context.accentLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: context.accent.withOpacity(0.4),
                      blurRadius: 28,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Text(
                  '✓   Set $_selected ${_selected == 1 ? 'Round' : 'Rounds'}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Cancel button
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: context.bgSurface2,
                  border: Border.all(color: context.borderDefault),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Cancel',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: context.textSecondary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoundCard(BuildContext context, int rounds, bool isActive) {
    return GestureDetector(
      onTap: () => setState(() => _selected = rounds),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isActive
              ? context.accent.withOpacity(0.15)
              : context.bgSurface,
          border: Border.all(
            color: isActive
                ? context.accentLight.withOpacity(0.6)
                : context.borderSubtle,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: context.accent.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$rounds',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: isActive ? context.accentLight : context.textSecondary,
                height: 1,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              rounds == 1 ? 'Round' : 'Rounds',
              style: TextStyle(
                fontSize: 9,
                letterSpacing: 1,
                fontWeight: FontWeight.bold,
                color: context.textMuted,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              _computeDuration(rounds),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: context.accentLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
