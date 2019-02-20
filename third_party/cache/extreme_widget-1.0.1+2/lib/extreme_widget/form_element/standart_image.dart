
import 'package:flutter/material.dart';
import 'package:extreme_widget/extreme_widget/helper/instance_manager.dart';

class StandartImage extends StatefulWidget {
  final String id;
  final String imageUrl;

  StandartImage({
    @required this.id,
    @required this.imageUrl,
    Key key,
  });

  @override
  StandartImageWidget createState() => StandartImageWidget();
}

class StandartImageWidget extends State<StandartImage> {
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
    InstanceManager.setInstance(widget.id, this);

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
