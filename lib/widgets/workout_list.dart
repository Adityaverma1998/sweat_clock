import 'package:flutter/material.dart';
import 'package:stop_watch/core/theme/theme_ext.dart';

class WorkoutListTile extends StatelessWidget {
  final String title;
  final String time;
  final Color borderColor;
  final Widget icon;

  final VoidCallback onTap;

  const WorkoutListTile({
    super.key,
    required this.title,
    required this.time,
    required this.onTap,
    required this.borderColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      // borderRadius: BorderRadius.circular(18),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          decoration: BoxDecoration(
            color: context.bgSurface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: context.borderSubtle),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 5,
                  color: context.borderStrong,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 18, 18),
                child: Row(
                  children: [
                    // 🎯 ICON BOX
                    Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: context.workoutBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: icon),

                    const SizedBox(width: 14),

                    // 📝 TEXT SECTION
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // SMALL LABEL (like cfg-label)
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 1.0,
                              fontWeight: FontWeight.w600,
                              color: context.textMuted,
                            ),
                          ),

                          const SizedBox(height: 4),

                          // BIG VALUE (like cfg-val)
                          Text(
                            time,
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: context.workout,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ➡️ ARROW
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: context.bgSurface2,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: context.borderSubtle,
                        ),
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 12,
                        color: context.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
