import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 16.0,horizontal: 16.0),
            child: Column(
          children: <Widget>[
            Row(
              children: [
                Center(
                  child: Text(
                    "Total Workout: 5",
                    style: TextStyle(fontSize: 24.0),
                  ),
                ),
                Spacer(), // Pushes the icon to the right
                Icon(Icons.keyboard_arrow_right_rounded),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            ListTile(
              onTap: () {},
              title: Text("Prep Time "),
              subtitle: Text("00:10"),
            ),
            SizedBox(
              height: 20,
            ),
            ListTile(
              tileColor: Colors.black,
              onTap: () {},
              title: Text("Prep Time "),
              subtitle: Text("00:10"),
            ),
            SizedBox(
              height: 20,
            ),
            ListTile(
              onTap: () {},
              title: Text("Prep Time "),
              subtitle: Text("00:10"),
            )
          ],
        )),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: false,
      title: const Text("SweatClock"),
    );
  }
}
