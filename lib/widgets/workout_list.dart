import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18.r),
        child: Ink(
          decoration: BoxDecoration(
            color: context.bgSurface,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: context.borderSubtle),
          ),
          child: Stack(
            children: [
              // Left accent bar
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 5.w,
                  color: context.borderStrong,
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 18.h, 18.w, 18.h),
                child: Row(
                  children: [
                    // Icon box
                    Container(
                      width: 40.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: context.workoutBg,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: icon,
                    ),

                    SizedBox(width: 14.w),

                    // Text section
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 14.sp,
                              letterSpacing: 1.6,
                              height: 1.5,
                              fontWeight: FontWeight.w600,
                              color: context.textMuted,
                            ),
                          ),
                          // SizedBox(height: 4.h),
                          Text(
                            time,
                            style: TextStyle(
                              fontSize: 26.sp,
                              fontWeight: FontWeight.w800,
                              color: context.workout,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Arrow button
                    Container(
                      width: 28.w,
                      height: 28.h,
                      decoration: BoxDecoration(
                        color: context.bgSurface2,
                        shape: BoxShape.circle,
                        border: Border.all(color: context.borderSubtle),
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 12.sp,
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
