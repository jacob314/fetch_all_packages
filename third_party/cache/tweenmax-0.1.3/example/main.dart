import 'package:flutter/material.dart';
import 'package:tweenmax/tweenmax.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new HomeScreen()
    );
  } 
}

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    
    TweenContainer tweenContainer = TweenContainer(
      data: TweenData(
        top: 100, 
        left: 100,
        width: 100,
        height: 100,
        color: Colors.red
      ),
      child: Icon(Icons.star, color: Colors.white)
    );

    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          // tween container
          Align(
            alignment: Alignment.center,
            child: tweenContainer
          ),
          
          // button
          Align(
            alignment: Alignment(0, 0.8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                FlatButton(
                  child: Icon(Icons.arrow_back, color: Colors.white),
                  color: Colors.blue,
                  onPressed: (){
                    TweenMax.killTweensOf(tweenContainer);
                    TweenMax.to(
                      tweenContainer,
                      duration: 1,
                      ease: Curves.fastOutSlowIn,
                      data: TweenData(
                        width: 100,
                        height: 100,
                        rotation: 0,
                        scale: Offset(1, 1),
                        opacity: 1,
                        color: Colors.red,
                        // border: Border.all(color: Colors.white, width: 1)
                      ),
                    );
                  },
                ),
                
                // spacing
                SizedBox(width: 5),

                FlatButton(
                  child: Icon(Icons.arrow_forward, color: Colors.white),
                  color: Colors.blue,
                  onPressed: (){
                    TweenMax.killTweensOf(tweenContainer);
                    TweenMax.to(
                      tweenContainer,
                      duration: 1,
                      data: TweenData(
                        width: 250,
                        height: 250,
                        rotation: 180,
                        // scale: Offset(3, 3),
                        // transformOrigin: Offset(0.5, 0.5),
                        color: Colors.blue
                      ),
                      ease: Curves.ease,
                      // repeat: -1,
                      // yoyo: true,
                    );
                  },
                ),

                
              ],
            )
            
          )
          
        ],
      ),
    );
  }
}