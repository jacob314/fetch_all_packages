import 'package:flutter/material.dart';

class ExLoader{
  
    static ImageProvider loadImage(String imageUrl){
      return imageUrl!=null ? NetworkImage(imageUrl) : AssetImage("assets/images/loading_image.gif");
    }

    static String loadText(String txt){

      return txt != null ? txt : "Loading..";
    }

    static Image loadIndicator(){
      return Image.asset("assets/images/loading_image.gif");
    }
}