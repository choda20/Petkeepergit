import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  void Function() whenPressed;
  double height;
  double width;
  IconData iconData;
  String text;
  double fontSize;
  GradientButton(this.whenPressed, this.height, this.width, this.iconData,
      this.text, this.fontSize);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: whenPressed,
        style: ButtonStyle(
            padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80)))),
        child: Ink(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: <Color>[Color(0xfffe5858), Color(0xffee9617)]),
              borderRadius: BorderRadius.all(Radius.circular(80))),
          child: Container(
            constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0),
            alignment: Alignment.center,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(
                iconData,
                size: 22,
                color: Colors.white,
              ),
              const SizedBox(width: 5),
              Text(
                text,
                style: TextStyle(fontSize: fontSize),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
