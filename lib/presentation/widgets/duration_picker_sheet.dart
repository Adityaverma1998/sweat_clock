import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/localization/localization_ext.dart';
import '../../core/theme/theme_ext.dart';

class DurationPickerSheet extends StatefulWidget {
  final Duration initialDuration;
  final ValueChanged<Duration> onDurationSelected;

  const DurationPickerSheet({
    super.key,
    required this.initialDuration,
    required this.onDurationSelected,
  });

  static Future<void> show(
    BuildContext context, {
    required Duration initialDuration,
    required ValueChanged<Duration> onDurationSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DurationPickerSheet(
        initialDuration: initialDuration,
        onDurationSelected: onDurationSelected,
      ),
    );
  }

  @override
  State<DurationPickerSheet> createState() => _DurationPickerSheetState();
}

class _DurationPickerSheetState extends State<DurationPickerSheet> {
  late int _selectedHours;
  late int _selectedMinutes;
  late int _selectedSeconds;

  static const List<Duration> _quickDurations = [
    Duration(seconds: 30),
    Duration(minutes: 1),
    Duration(minutes: 5),
    Duration(minutes: 10),
    Duration(minutes: 15),
    Duration(minutes: 30),
    Duration(minutes: 60),
  ];

  @override
  void initState() {
    super.initState();
    final totalSec = widget.initialDuration.inSeconds;
    _selectedHours = totalSec ~/ 3600;
    _selectedMinutes = (totalSec % 3600) ~/ 60;
    _selectedSeconds = totalSec % 60;
  }

  void _applyQuickDuration(Duration d) {
    setState(() {
      final totalSec = d.inSeconds;
      _selectedHours = totalSec ~/ 3600;
      _selectedMinutes = (totalSec % 3600) ~/ 60;
      _selectedSeconds = totalSec % 60;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.bgSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(
          top: BorderSide(color: context.borderSubtle, width: 1.5),
        ),
      ),
      padding: EdgeInsets.only(
        top: 20,
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
      ),
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
          const SizedBox(height: 18),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.translate('set_duration'),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: context.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close_rounded, color: context.textMuted),
                style: IconButton.styleFrom(
                  backgroundColor: context.bgBase,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Quick Duration Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: _quickDurations.map((d) {
                final isSelected =
                    d.inSeconds == (_selectedHours * 3600 + _selectedMinutes * 60 + _selectedSeconds);
                final label = _formatChipLabel(d);
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(label),
                    selected: isSelected,
                    onSelected: (_) => _applyQuickDuration(d),
                    backgroundColor: context.bgBase,
                    selectedColor: context.accent.withValues(alpha: 0.18),
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? context.accent : context.textSecondary,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isSelected ? context.accent : context.borderSubtle,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),

          // 3-Wheel Cupertino Picker (Hours, Minutes, Seconds)
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: context.bgBase,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: context.borderSubtle),
            ),
            child: Row(
              children: [
                _buildPickerColumn(
                  label: context.translate('hours'),
                  itemCount: 24,
                  selectedValue: _selectedHours,
                  onChanged: (val) => setState(() => _selectedHours = val),
                ),
                _buildDivider(),
                _buildPickerColumn(
                  label: context.translate('minutes'),
                  itemCount: 60,
                  selectedValue: _selectedMinutes,
                  onChanged: (val) => setState(() => _selectedMinutes = val),
                ),
                _buildDivider(),
                _buildPickerColumn(
                  label: context.translate('seconds'),
                  itemCount: 60,
                  selectedValue: _selectedSeconds,
                  onChanged: (val) => setState(() => _selectedSeconds = val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Confirm Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final totalSec = _selectedHours * 3600 + _selectedMinutes * 60 + _selectedSeconds;
                final duration = totalSec > 0 ? Duration(seconds: totalSec) : const Duration(seconds: 10);
                widget.onDurationSelected(duration);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: context.accent,
                foregroundColor: context.fabForeground,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Text(
                context.translate('done'),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 100,
      color: context.borderSubtle,
    );
  }

  Widget _buildPickerColumn({
    required String label,
    required int itemCount,
    required int selectedValue,
    required ValueChanged<int> onChanged,
  }) {
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 4),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: context.textMuted,
              ),
            ),
          ),
          Expanded(
            child: CupertinoPicker(
              scrollController: FixedExtentScrollController(initialItem: selectedValue),
              itemExtent: 40,
              selectionOverlay: Container(
                decoration: BoxDecoration(
                  border: Border.symmetric(
                    horizontal: BorderSide(
                      color: context.accent.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              onSelectedItemChanged: onChanged,
              children: List.generate(itemCount, (index) {
                final isSelected = index == selectedValue;
                return Center(
                  child: Text(
                    index.toString().padLeft(2, '0'),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                      color: isSelected ? context.textPrimary : context.textMuted,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  String _formatChipLabel(Duration d) {
    if (d.inHours >= 1) return '${d.inHours}h';
    if (d.inMinutes >= 1) return '${d.inMinutes}m';
    return '${d.inSeconds}s';
  }
}
