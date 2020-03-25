import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:islamic_habits/utility/constants.dart';
import 'round_icon_button.dart';
import 'package:islamic_habits/utility/decimalTextInputFormatter.dart';
import 'dart:async';

class HabitInputDialog extends StatefulWidget {
  final double initialValue;
  HabitInputDialog({@required this.initialValue});
  @override
  _HabitInputDialogState createState() => _HabitInputDialogState();
}

class _HabitInputDialogState extends State<HabitInputDialog> {
  TextEditingController _controller = TextEditingController();
  double value;
  Timer timer;

  @override
  void initState() {
    value = widget.initialValue ?? 0;
    _controller.text = value.toString();
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text('Set Number'),
      ),
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: TextFormField(
            style: TextStyle(
              fontSize: 20,
            ),
            controller: _controller,
//            initialValue: value.toStringAsFixed(1),
            textAlign: TextAlign.center,
            cursorColor: Colors.deepPurple,
            decoration: kTextFieldDecoration,
            onChanged: (v) {
              setState(() {
                value = double.parse(v);
              });
            },
            keyboardType: TextInputType.number,
            inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RoundIconButton(
              onTapDown: (TapDownDetails details) {
                timer = Timer.periodic(Duration(milliseconds: 100), (t) {
                  setState(() {
                    value++;
                    _controller.text = value.toStringAsFixed(1);
                  });
//                  print('value $value');
                });
              },
              onTapUp: (TapUpDetails details) {
                timer.cancel();
              },
              onTapCancel: () {
                timer.cancel();
              },
              icon: FontAwesomeIcons.plus,
            ),
            RoundIconButton(
              onTapDown: (TapDownDetails details) {
                timer = Timer.periodic(Duration(milliseconds: 100), (t) {
                  setState(() {
                    if (value > 0) {
                      value--;
                      _controller.text = value.toStringAsFixed(1);
                    }
                  });
//                  print('value $value');
                });
              },
              onTapUp: (TapUpDetails details) {
                timer.cancel();
              },
              onTapCancel: () {
                timer.cancel();
              },
              icon: FontAwesomeIcons.minus,
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, value);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Set',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Expanded(
              child: SimpleDialogOption(
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    barrierDismissible: false, // user must tap button!
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Delete Session'),
                        content: Text(
                            'Are you sure you want to permenantly delete this session?.'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Yes'),
                            onPressed: () {
                              Navigator.of(context).pop();

                              Navigator.pop(context, null);
                            },
                          ),
                          FlatButton(
                            child: Text('No'),
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.pop(context, value);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Delete',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Expanded(
              child: SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, widget.initialValue);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Cancel',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
