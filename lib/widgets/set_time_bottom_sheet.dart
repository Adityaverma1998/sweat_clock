import 'package:flutter/material.dart';

void showTimePickerBottomSheet(BuildContext context) {
  List<int> minValues = List.generate(61, (index) => index);
  List<int> secValues = List.generate(13, (index) => index * 5); 

  double itemHeight = 30;
  var selectedMin = minValues[(minValues.length / 2).toInt()];
  var selectedSec = secValues[(secValues.length / 2).toInt()];

 

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.all(16.0),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Set Time',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                
                     
              
              ])    
          ],
        ),
      );
    },
  );
}
