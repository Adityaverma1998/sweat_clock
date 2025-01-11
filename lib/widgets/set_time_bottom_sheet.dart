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
        width: MediaQuery.of(context).size.width ,
        padding: EdgeInsets.all(16.0),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Set Time',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Container(
                                color:Colors.blue,

                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    itemCount: minValues.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('${minValues[index]}'),
                        titleTextStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500
                        ),
                      );
                    },
                  )),
              Container(
                color:Colors.red,
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Center(
                    child: ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      itemCount: secValues.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: (){

                          },
                          title: Text('${secValues[index]}'),
                        );
                      },
                    ),
                  ))
            ])
          ],
        ),
      );
    },
  );
}
