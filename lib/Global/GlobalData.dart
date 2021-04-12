import 'package:flutter/material.dart';

class NewsData {
  String author, title, description, url, urlToImage, publishedAt, content;
}

Color startColor = Color(0xFFFC6D1C);
Color endColor = Color(0xFFF52862);

myTextField(controller, hintText, {obscure, errorText}) {
  return Container(
    margin: EdgeInsets.fromLTRB(20, 15, 20, 0),
    height: 30,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
    ),
    child: TextField(
      controller: controller,
      style:
          TextStyle(color: endColor, fontWeight: FontWeight.w500, fontSize: 14),
      obscureText: obscure == null ? false : obscure,
      obscuringCharacter: '*',
      decoration: InputDecoration(
        errorText: errorText,
        hintText: hintText,
        hintStyle: TextStyle(
            color: endColor, fontWeight: FontWeight.w500, fontSize: 14),
        contentPadding: EdgeInsets.only(bottom: 10, left: 15),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: startColor),
            borderRadius: BorderRadius.circular(20)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: endColor),
            borderRadius: BorderRadius.circular(20)),
      ),
    ),
  );
}

myInputDecoration(hintText, errorText) {
  return InputDecoration(
      errorText: errorText,
      hintText: hintText,
      hintStyle:
          TextStyle(color: endColor, fontWeight: FontWeight.w500, fontSize: 14),
      contentPadding: EdgeInsets.only(bottom: 10, left: 15),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: startColor),
          borderRadius: BorderRadius.circular(20)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: endColor),
          borderRadius: BorderRadius.circular(20)),
      border: OutlineInputBorder(
          borderSide: BorderSide(color: startColor),
          borderRadius: BorderRadius.circular(20)),
      focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(20)),
      errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(20)));
}

TextStyle myTextStyle() {
  return TextStyle(color: endColor, fontWeight: FontWeight.w500, fontSize: 14);
}

showSnackBar(context, text, {color, duration, key}) {
  final snackBar = SnackBar(
    key: key,
    content: Text(text),
    backgroundColor: color == null ? Colors.black.withOpacity(0.8) : color,
    duration: duration == null ? Duration(seconds: 1) : duration,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
