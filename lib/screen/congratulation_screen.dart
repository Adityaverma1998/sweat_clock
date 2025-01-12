import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:stop_watch/screen/home_screen.dart';

class CongratulationScreen extends StatelessWidget {
  final AudioPlayer player = AudioPlayer();

  CongratulationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Play the congratulation audio when the screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      playAudio();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Workout Complete"),
      ),
      body: _buildCongratulationScreen(context),
    );
  }

  void playAudio() async {
    await player.play(AssetSource('audios/congrat.mp3'));
  }

  Widget _buildCongratulationScreen(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
          

             Stack(
              children: <Widget>[
                Lottie.asset('assets/lotties/success.json',
                height: MediaQuery.of(context).size.height * 0.6,
                animate: true),
                 Lottie.asset('assets/lotties/winner.json',
                 
                height: MediaQuery.of(context).size.height * 0.6,
                animate: true),

              ],
             ),
            const SizedBox(height: 20),
            const Text(
              'Congratulations! You have successfully completed the workout!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigator.pop(
                //     context);
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (contex) => const HomeScreen()),
                  (route) => false,
                );
              },
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
