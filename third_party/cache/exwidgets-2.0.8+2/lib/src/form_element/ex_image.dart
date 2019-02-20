
import 'package:flutter/material.dart';
import 'package:exwidgets/src/helper/ex_instance_manager.dart';

class ExImage extends StatefulWidget {
  final String id;
  final String imageUrl;

  ExImage({
    @required this.id,
    @required this.imageUrl,
    Key key,
  });

  @override
  ExImageState createState() => ExImageState();
}

class ExImageState extends State<ExImage> {
  String imageUrl = "";
  changeImageUrl(newImageUrl) {
    this.setState(() {
      imageUrl = newImageUrl;
    });
  }

  @override
  void initState() {
    imageUrl = widget.imageUrl;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ExInstanceManager.setInstance(widget.id, this);

    return Container(
      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
      child: Image.asset(
        imageUrl,
        width: 120.0,
        height: 120.0,
        fit: BoxFit.fill,
      ),
    );
  }
}
