import 'package:fb_share_plugin_example/media_picker.dart';
import 'package:flutter/material.dart';
import 'package:fb_share_plugin/fb_share_plugin.dart';



void main() => runApp(MaterialApp(
  title: 'Navigation Basics',
  home: MyApp(),
));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  void initState() {
    super.initState();

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Center(
                child: RaisedButton(
                    child: Text("Share Button"),
                    onPressed: ()async {
                  await FbSharePlugin.shareContent("http://www.sheikhsoft.com");
                }),
              ),
              Center(
                child: RaisedButton(
                    child: Text("Facebook Share Video"),
                    onPressed: ()async {
                      await FbSharePlugin.shareVideo("/storage/emulated/0/Download/4721.mp4");
                    }),
              ),
              Center(
                child: RaisedButton(
                    child: Text("WhatsApp Share Video"),
                    onPressed: ()async {
                      await FbSharePlugin.shareVideoWhatsApp("/storage/emulated/0/Download/4721.mp4");
                    }),
              ),

              Center(
                child: RaisedButton(
                    child: Text("Messenger Share Video"),
                    onPressed: ()async {
                      await FbSharePlugin.shareVideoMessenger("/storage/emulated/0/Download/4721.mp4");
                    }),
              ),
              Center(
                child: RaisedButton(
                    child: Text("Twitter Share Video"),
                    onPressed: ()async {
                      await FbSharePlugin.shareVideoTwitter("/storage/emulated/0/Download/4721.mp4");
                    }),
              ),
              Center(
                child: RaisedButton(
                    child: Text("Open Meadia Picker Window"),
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MediaPickerScreen()),
                      );
                    }),

              ),
              Center(
                child: RaisedButton(
                    child: Text("Facebook Image Share"),
                    onPressed: ()async {
                      await FbSharePlugin.shareImageFb("/storage/emulated/0/viber/media/Viber Images/IMG-da9a022f2b9d9e27dda620c8622d1352-V.jpg");
                    }),

              ),

              Center(
                child: RaisedButton(
                    child: Text("WhatsApp Image Share"),
                    onPressed: ()async {
                      await FbSharePlugin.shareVideoWhatsApp("/storage/emulated/0/viber/media/Viber Images/IMG-da9a022f2b9d9e27dda620c8622d1352-V.jpg");
                    }),

              ),

              Center(
                child: RaisedButton(
                    child: Text("Twitter Image Share"),
                    onPressed: ()async {
                      await FbSharePlugin.shareVideoTwitter("/storage/emulated/0/viber/media/Viber Images/IMG-da9a022f2b9d9e27dda620c8622d1352-V.jpg");
                    }),

              ),

              Center(
                child: RaisedButton(
                    child: Text("Messanger Image Share"),
                    onPressed: ()async {
                      await FbSharePlugin.shareImageMessenger("/storage/emulated/0/viber/media/Viber Images/IMG-da9a022f2b9d9e27dda620c8622d1352-V.jpg");
                    }),

              ),

            ],
          ),
        ),
      );

  }
}

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Screen"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}
