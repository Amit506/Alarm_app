import 'package:amitalarm/colors.dart';
import 'package:flutter/material.dart';
import 'ManageRepeat.dart';
import 'package:provider/provider.dart';

class Repeat extends StatefulWidget {
  @override
  _RepeatState createState() => _RepeatState();
}

class _RepeatState extends State<Repeat> {
  @override
  Widget build(BuildContext context) {
    var manageCheckBox = Provider.of<ManageRepeatPage>(context);
    return Scaffold(
      body: SafeArea(
          child: Container(
        child: ListView(children: [
          CheckboxListTile(
            value: manageCheckBox.checkBox[7],
            onChanged: (vlaue) {
              manageCheckBox.setAllCheckBox(false);
            },
            title: Text('Once'),
          ),
          CheckboxListTile(
            value: manageCheckBox.checkBox[6],
            onChanged: (value) {
              manageCheckBox.set(value, 6);
            },
            title: Text('Every Sunday'),
          ),
          CheckboxListTile(
            value: manageCheckBox.checkBox[0],
            onChanged: (value) {
              manageCheckBox.set(value, 0);
            },
            title: Text('Every Monady'),
          ),
          CheckboxListTile(
            value: manageCheckBox.checkBox[1],
            onChanged: (value) {
              manageCheckBox.set(value, 1);
            },
            title: Text('Every Tuesday'),
          ),
          CheckboxListTile(
            value: manageCheckBox.checkBox[2],
            onChanged: (value) {
              manageCheckBox.set(value, 2);
            },
            title: Text('Every Wednesday'),
          ),
          CheckboxListTile(
            value: manageCheckBox.checkBox[3],
            onChanged: (value) {
              manageCheckBox.set(value, 3);
            },
            title: Text('Every Thursday'),
          ),
          CheckboxListTile(
            value: manageCheckBox.checkBox[4],
            onChanged: (value) {
              manageCheckBox.set(value, 4);
            },
            title: Text('Every Friday'),
          ),
          CheckboxListTile(
            value: manageCheckBox.checkBox[5],
            onChanged: (value) {
              manageCheckBox.set(value, 5);
            },
            title: Text('Every Saturday'),
          ),
          FlatButton(onPressed: (){
            Navigator.pop(context);

          }, child: Text('Save'),
          color: blue3         
          )
        ]),
      )),
    );
  }
}
