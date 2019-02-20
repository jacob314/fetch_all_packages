import 'package:flutter/material.dart';

class CustomImageContainer extends StatelessWidget {

  final double height;
  final double width;
  final double radius;
  final String imageSrc;


  CustomImageContainer({this.height, this.width, this.radius, this.imageSrc});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 100,
      width: width ?? MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                 imageSrc ?? "http://images.midwestliving.mdpcdn.com/sites/midwestliving.com/files/styles/slide/public/R075094_13.jpg?itok=vFyuAl8S"),
            fit: BoxFit.fill,
          ),
          borderRadius: BorderRadius.all(
              Radius.circular(radius ?? 5.0))),
    );
  }
}
