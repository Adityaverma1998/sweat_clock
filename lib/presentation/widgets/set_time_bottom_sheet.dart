import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/localization/localization_ext.dart';
import '../../core/theme/theme_ext.dart';
import '../viewmodels/home_viewmodel.dart';

void showTimePickerBottomSheet(BuildContext context, String timerType) {
  final homeViewModel = context.read<HomeViewModel>();

  int selectedMin;
  int selectedSec;
  String titleKey;
  String description;
  String icon;

  if (timerType == "preparation") {
    selectedMin = homeViewModel.prepMinutes;
    selectedSec = homeViewModel.prepSeconds;
    titleKey = 'preparation';
    description = 'Set how long before each round starts';
    icon = '⏳';
  } else if (timerType == "workout") {
    selectedMin = homeViewModel.workoutMinutes;
    selectedSec = homeViewModel.workoutSeconds;
    titleKey = 'workout';
    description = 'Set work interval duration';
    icon = '🔥';
  } else {
    selectedMin = homeViewModel.restMinutes;
    selectedSec = homeViewModel.restSeconds;
    titleKey = 'rest';
    description = 'Set rest interval between rounds';
    icon = '🧘';
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext ctx) {
      return _TimePickerSheet(
        timerType: timerType,
        initialMin: selectedMin,
        initialSec: selectedSec,
        titleKey: titleKey,
        description: description,
        icon: icon,
        homeViewModel: homeViewModel,
      );
    },
  );
}

class _TimePickerSheet extends StatefulWidget {
  final String timerType;
  final int initialMin;
  final int initialSec;
  final String titleKey;
  final String description;
  final String icon;
  final HomeViewModel homeViewModel;

  const _TimePickerSheet({
    required this.timerType,
    required this.initialMin,
    required this.initialSec,
    required this.titleKey,
    required this.description,
    required this.icon,
    required this.homeViewModel,
  });

  @override
  State<_TimePickerSheet> createState() => _TimePickerSheetState();
}

class _TimePickerSheetState extends State<_TimePickerSheet> {
  late int _selectedMin;
  late int _selectedSec;

  final List<int> _minValues = List.generate(61, (i) => i);
  // generate 0, 5, 10, 15, ..., 60 seconds
  final List<int> _secValues = List.generate(13, (i) => i * 5);

  late FixedExtentScrollController _minController;
  late FixedExtentScrollController _secController;

  @override
  void initState() {
    super.initState();
    _selectedMin = widget.initialMin;
    _selectedSec = widget.initialSec;

    _minController = FixedExtentScrollController(
      initialItem: _minValues.indexOf(_selectedMin).clamp(0, _minValues.length - 1),
    );

    final secIdx = _secValues.indexOf(_selectedSec);
    _secController = FixedExtentScrollController(
      initialItem: secIdx >= 0 ? secIdx : 0,
    );
  }

  @override
  void dispose() {
    _minController.dispose();
    _secController.dispose();
    super.dispose();
  }

  Color _phaseColor(BuildContext context) {
    switch (widget.timerType) {
      case 'preparation':
        return context.prep;
      case 'workout':
        return context.workout;
      default:
        return context.rest;
    }
  }

  void _apply() {
    // If user selects 0 minutes and 0 seconds, fallback to at least 5 seconds for safety
    if (_selectedMin == 0 && _selectedSec == 0) {
      _selectedSec = 5;
    }

    if (widget.timerType == "preparation") {
      widget.homeViewModel.setPrepTime(_selectedMin, _selectedSec);
    } else if (widget.timerType == "workout") {
      widget.homeViewModel.setWorkoutTime(_selectedMin, _selectedSec);
    } else {
      widget.homeViewModel.setRestTime(_selectedMin, _selectedSec);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final color = _phaseColor(context);
    final localizedTitle = context.translate(widget.titleKey);

    return Container(
      decoration: BoxDecoration(
        color: context.bgBase,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(
          color: color.withOpacity(0.15),
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
            const SizedBox(height: 16),
            Text(widget.icon, style: const TextStyle(fontSize: 36)),
            const SizedBox(height: 8),
            Text(
              localizedTitle.toUpperCase(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                letterSpacing: 3,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.description,
              style: TextStyle(fontSize: 12, color: context.textMuted),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 180,
              child: Row(
                children: [
                  Expanded(
                    child: _buildDrumPicker(
                      context,
                      values: _minValues,
                      controller: _minController,
                      color: color,
                      unitLabel: context.translate('minutes').toUpperCase(),
                      onChanged: (i) => setState(() => _selectedMin = _minValues[i]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      ':',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: context.textMuted,
                      ),
                    ),
                  ),
                  Expanded(
                    child: _buildDrumPicker(
                      context,
                      values: _secValues,
                      controller: _secController,
                      color: color,
                      unitLabel: context.translate('seconds').toUpperCase(),
                      onChanged: (i) => setState(() => _selectedSec = _secValues[i]),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.08),
                border: Border.all(color: color.withOpacity(0.2)),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  Text(
                    'PREVIEW',
                    style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 1.5,
                      color: context.textMuted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$_selectedMin : ${_selectedSec.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: color,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            GestureDetector(
              onTap: _apply,
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

  Widget _buildDrumPicker(
    BuildContext context, {
    required List<int> values,
    required FixedExtentScrollController controller,
    required Color color,
    required String unitLabel,
    required ValueChanged<int> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: context.bgSurface,
        border: Border.all(color: context.borderSubtle),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Expanded(
            child: CupertinoPicker(
              scrollController: controller,
              itemExtent: 42,
              selectionOverlay: Container(
                decoration: BoxDecoration(
                  color: color.withOpacity(0.08),
                  border: Border.symmetric(
                    horizontal: BorderSide(color: color.withOpacity(0.35)),
                  ),
                ),
              ),
              diameterRatio: 1.2,
              squeeze: 1.0,
              useMagnifier: true,
              magnification: 1.15,
              onSelectedItemChanged: onChanged,
              children: values
                  .map((v) => Center(
                        child: Text(
                          '$v',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: context.textPrimary,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 6, top: 2),
            child: Text(
              unitLabel,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
