
import 'package:flutter/material.dart';
class CustomText extends StatelessWidget {
  final String title;
  final String text;
  const CustomText({Key? key, required this.title, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text.rich(
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black38),
        TextSpan(
            text: title,
            //style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500, color: Colors.black38),
            children: <InlineSpan>[
              TextSpan(
                text: text,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              )
            ]));
  }
}