import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/localization/localization_ext.dart';
import '../../core/theme/theme_ext.dart';
import '../viewmodels/home_viewmodel.dart';

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
    _selected = context.read<HomeViewModel>().totalRounds;
  }

  String _computeDuration(int rounds) {
    final home = context.read<HomeViewModel>();
    final workSec = home.workoutMinutes * 60 + home.workoutSeconds;
    final restSec = home.restMinutes * 60 + home.restSeconds;
    final prepSec = home.prepMinutes * 60 + home.prepSeconds;
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
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.borderDefault,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 14),
            const Text('🔁', style: TextStyle(fontSize: 40)),
            const SizedBox(height: 6),
            Text(
              context.translate('set_rounds').toUpperCase(),
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
            GestureDetector(
              onTap: () {
                context.read<HomeViewModel>().setTotalRounds(_selected);
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
                  '✓   ${context.translate('done')}',
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
                  context.translate('cancel'),
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
              rounds == 1 ? context.translate('stage') : context.translate('rounds'),
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
