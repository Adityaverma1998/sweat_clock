// import 'dart:async';
// import 'dart:developer';

// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:stop_watch/core/theme/theme_ext.dart';
// import 'package:provider/provider.dart';
// import 'package:stop_watch/presentation/viewmodels/home_viewmodel.dart';

// // Access it in your build method:
// final homeViewModel = context.watch<HomeViewModel>();

// class WorkoutProgress extends StatefulWidget {
//   final int sec;
//   final String workoutType;
//   final Color color;

//   const WorkoutProgress({
//     super.key,
//     required this.sec,
//     required this.workoutType,
//     required this.color,
//   });

//   @override
//   _WorkoutProgressState createState() => _WorkoutProgressState();
// }

// class _WorkoutProgressState extends State<WorkoutProgress> with SingleTickerProviderStateMixin {
//   late AudioPlayer player;
//   late int currentSec;
//   late int showCurrentSec;
//   Timer? _timer;
//   late AnimationController _animationController;
//   late Animation<double> _bounceAnimation;

//   late Home homeProvider;

//   @override
//   void initState() {
//     super.initState();
//     currentSec = widget.sec;
//     showCurrentSec = widget.sec;

//     player = AudioPlayer();

//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );
//     _bounceAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: Curves.easeInOut,
//       ),
//     );
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     homeProvider = Provider.of<Home>(context, listen: true);
//     _startTimer();
//   }

//   void _startTimer() {
//     if (_timer != null && _timer!.isActive) return;

//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
//       if (!homeProvider.isWorkoutPaused) {
//         _ticker();
//       } else {
//         if (player.state == PlayerState.playing) player.stop();
//         _timer?.cancel();
//         if (_animationController.isAnimating) {
//           _animationController.stop();
//           _animationController.reset();
//         }
//       }
//     });
//   }

//   void _ticker() async {
//     if (currentSec >= 1) {
//       int audioSecond = homeProvider.currentWorkoutStage == homeProvider.totalWorkout ? showCurrentSec : currentSec;

//       if (currentSec == 1) {
//         showCurrentSec = showCurrentSec;
//         currentSec--;
//       } else {
//         setState(() {
//           currentSec--;
//           showCurrentSec--;
//         });
//       }

//       _playAudio(audioSecond);
//     } else {
//       _handleWorkoutCompletion();
//     }
//   }

//   void _playAudio(int currSec) async {
//     if (currSec > 4) return;
//     if (homeProvider.isWorkComplete) {
//       await player.play(AssetSource('audios/rest.mp3'));
//     } else if (homeProvider.isRestComplete || homeProvider.isPrepComplete) {
//       await player.play(AssetSource('audios/go.mp3'));
//     }
//     _animationController.forward();
//     _animationController.repeat(reverse: true);
//   }

//   void _handleWorkoutCompletion() {
//     if (homeProvider.currentWorkoutStage > homeProvider.totalWorkout) {
//       homeProvider.changeAllValues();
//     } else {
//       if (widget.workoutType == 'PREP') {
//         homeProvider.changeIsWorkoutComplete(true);
//         homeProvider.changeIsPrepComplete(false);
//       } else if (widget.workoutType == 'WORKOUT') {
//         if (homeProvider.totalWorkout == homeProvider.currentWorkoutStage) {
//           homeProvider.changeIsRestComplete(false);
//           homeProvider.changeCurrentWorkStage();
//         } else {
//           homeProvider.changeIsRestComplete(true);
//           homeProvider.changeIsWorkoutComplete(false);
//           homeProvider.changeCurrentWorkStage();
//         }
//       } else if (widget.workoutType == 'REST') {
//         homeProvider.changeIsWorkoutComplete(true);
//         homeProvider.changeIsRestComplete(false);
//       }
//     }

//     _timer?.cancel();
//     if (_animationController.isAnimating) {
//       _animationController.stop();
//       _animationController.reset();
//     }
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     if (_animationController.isAnimating) {
//       _animationController.stop();
//       _animationController.dispose();
//     }
//     player.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         _buildPhaseChip(context),
//         const SizedBox(height: 14),
//         SizedBox(
//           height: 220,
//           width: 220,
//           child: Stack(
//             fit: StackFit.expand,
//             alignment: Alignment.center,
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   gradient: RadialGradient(
//                     colors: [
//                       widget.color.withOpacity(0.12),
//                       context.bgBase.withOpacity(0.04),
//                       Colors.transparent,
//                     ],
//                     stops: const [0.0, 0.5, 0.7],
//                   ),
//                 ),
//               ),
//               CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation(currentSec > 3 ? widget.color : context.error),
//                 backgroundColor: context.ringTrack,
//                 strokeWidth: 14,
//                 strokeCap: StrokeCap.round,
//                 value: showCurrentSec > 0 ? showCurrentSec / widget.sec : 0,
//               ),
//               Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Text(
//                       widget.workoutType.toUpperCase(),
//                       style: TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.bold,
//                         letterSpacing: 2.5,
//                         color: widget.color,
//                       ),
//                     ),
//                     AnimatedBuilder(
//                       animation: _bounceAnimation,
//                       builder: (context, child) {
//                         return Transform.scale(
//                           scale: currentSec <= 3 ? _bounceAnimation.value : 1.0,
//                           child: Text(
//                             '$showCurrentSec',
//                             style: TextStyle(
//                               fontSize: 72,
//                               fontWeight: FontWeight.bold,
//                               height: 1.1,
//                               color: context.textPrimary,
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                     Text(
//                       "seconds left",
//                       style: TextStyle(
//                         fontSize: 10,
//                         letterSpacing: 1.5,
//                         color: context.textMuted,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildPhaseChip(BuildContext context) {
//     Color chipColor = widget.color;
//     Color chipBg = widget.color.withOpacity(0.1);
//     Color chipBorder = widget.color.withOpacity(0.25);

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
//       decoration: BoxDecoration(
//         color: chipBg,
//         border: Border.all(color: chipBorder),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             width: 6,
//             height: 6,
//             decoration: BoxDecoration(color: chipColor, shape: BoxShape.circle),
//           ),
//           const SizedBox(width: 6),
//           Text(
//             widget.workoutType.toUpperCase(),
//             style: TextStyle(
//               fontSize: 10,
//               fontWeight: FontWeight.bold,
//               letterSpacing: 2,
//               color: chipColor,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
