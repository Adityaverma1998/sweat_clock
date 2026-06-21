import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stop_watch/providers/home.dart';
import 'package:stop_watch/core/theme/theme_ext.dart';

void showTimePickerBottomSheet(BuildContext context, String timerType) {
  final home = context.read<Home>();

  int selectedMin;
  int selectedSec;
  String title;
  String description;
  String icon;

  if (timerType == "preparation") {
    selectedMin = home.prepMin;
    selectedSec = home.prepSec;
    title = 'Preparation';
    description = 'Set how long before each round starts';
    icon = '⏳';
  } else if (timerType == "workout") {
    selectedMin = home.workoutMin;
    selectedSec = home.workoutSec;
    title = 'Workout';
    description = 'Set work interval duration';
    icon = '🔥';
  } else {
    selectedMin = home.restMin;
    selectedSec = home.restSec;
    title = 'Rest';
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
        title: title,
        description: description,
        icon: icon,
      );
    },
  );
}

class _TimePickerSheet extends StatefulWidget {
  final String timerType;
  final int initialMin;
  final int initialSec;
  final String title;
  final String description;
  final String icon;

  const _TimePickerSheet({
    required this.timerType,
    required this.initialMin,
    required this.initialSec,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  State<_TimePickerSheet> createState() => _TimePickerSheetState();
}

class _TimePickerSheetState extends State<_TimePickerSheet> {
  late int _selectedMin;
  late int _selectedSec;

  final List<int> _minValues = List.generate(61, (i) => i);
  final List<int> _secValues = List.generate(12, (i) => (i + 1) * 5);

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

  Color _phaseLightColor(BuildContext context) {
    switch (widget.timerType) {
      case 'preparation':
        return context.prepLight;
      case 'workout':
        return context.workoutLight;
      default:
        return context.restLight;
    }
  }

  void _apply() {
    final home = context.read<Home>();
    if (widget.timerType == "preparation") {
      home.changePrepMin(_selectedMin);
      home.changePrepSec(_selectedSec);
    } else if (widget.timerType == "workout") {
      home.changeWorkoutMin(_selectedMin);
      home.changeWorkoutSec(_selectedSec);
    } else {
      home.changeRestMin(_selectedMin);
      home.changeRestSec(_selectedSec);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final color = _phaseColor(context);
    final lightColor = _phaseLightColor(context);

    return Container(
      decoration: BoxDecoration(
        color: context.bgBase,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(
          top: BorderSide(color: color.withOpacity(0.2)),
          left: BorderSide(color: color.withOpacity(0.1)),
          right: BorderSide(color: color.withOpacity(0.1)),
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
            const SizedBox(height: 16),

            // Hero section
            Text(widget.icon, style: const TextStyle(fontSize: 36)),
            const SizedBox(height: 8),
            Text(
              widget.title.toUpperCase(),
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

            // Drum pickers
            SizedBox(
              height: 200,
              child: Row(
                children: [
                  // Minutes
                  Expanded(
                    child: _buildDrumPicker(
                      context,
                      values: _minValues,
                      controller: _minController,
                      color: color,
                      unitLabel: 'MIN',
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
                  // Seconds
                  Expanded(
                    child: _buildDrumPicker(
                      context,
                      values: _secValues,
                      controller: _secController,
                      color: color,
                      unitLabel: 'SEC',
                      onChanged: (i) => setState(() => _selectedSec = _secValues[i]),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Preview
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

            // Set button
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
                  '✓   Set ${widget.title} Time',
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
