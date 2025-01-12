import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:stop_watch/screen/home_screen.dart';
import 'package:stop_watch/widgets/custom_button.dart';

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
      backgroundColor: const Color(0xFF151515),
      appBar: AppBar(
        title: null,
        leading: null,
        actions: [],
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
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
           CustomButton(name: 'GO Back', callback: (){
             Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (contex) => const HomeScreen()),
                   (route) => false,
                );
           })
          ],
        ),
      ),
    );
  }
}
