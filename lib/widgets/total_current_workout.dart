import 'package:flutter/material.dart';
import 'package:stop_watch/providers/home.dart';
import 'package:provider/provider.dart';

class TotalCurrentWorkout extends StatefulWidget {
  const TotalCurrentWorkout({super.key});

  @override
  _TotalCurrentWorkoutState createState() => _TotalCurrentWorkoutState();
}

class _TotalCurrentWorkoutState extends State<TotalCurrentWorkout>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);

    _opacityAnimation =
        Tween<double>(begin: 1.0, end: 0.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Home>(
      builder: (context, homeProvider, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 12.0,
            ),
            Container(
              // color: Colors.red,
              width: MediaQuery.of(context).size.width * 0.9,
              height: 10,
              child: Center(
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: homeProvider.totalWorkout,
                  itemBuilder: (context, index) {
                    bool isSelected =
                        homeProvider.currentWorkoutStage == index + 1;

                    return AnimatedBuilder(
                      animation: _opacityAnimation,
                      builder: (context, child) {
                        return Opacity(
                          opacity: isSelected ? _opacityAnimation.value : 1.0,
                          child: Container(
                            width: 36.0,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: isSelected
                                      ? const Color(0xFF7C4DFF)
                                      : const Color(0xFF202023),
                                  width: 4.0,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(width: 8.0);
                  },
                ),
              ),
            ),
            SizedBox(
              height: 12.0,
            ),
            Text(
              '${homeProvider.currentWorkoutStage} / ${homeProvider.totalWorkout}',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF7C4DFF)),
            ),
          ],
        );
      },
    );
  }
}
