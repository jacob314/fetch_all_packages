import 'dart:io';

import 'package:flutter/material.dart';
import 'package:extreme_widget/extreme_widget/etc/firestorage_uploader.dart';
import 'package:extreme_widget/extreme_widget/helper/input.dart';
import 'package:image_picker/image_picker.dart';

class StandartImageUploader extends StatefulWidget {
  final String id;
  final String labelText;
  final String value;

  StandartImageUploader({
    @required this.id,
    @required this.labelText,
    this.value,
  });
  _StandartImageUploaderState createState() => _StandartImageUploaderState();
}

class _StandartImageUploaderState extends State<StandartImageUploader> {
  File _image;
  String url;


  Future getImage() async {
    ImageSource imageSource;
    dynamic dialog = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            content: Text(
              'Upload image from :',
            ),
            actions: <Widget>[
              FlatButton(
                child: const Text('Gallery'),
                onPressed: () {
                  imageSource = ImageSource.gallery;
                  Navigator.of(context).pop(true);
                },
              ),
              FlatButton(
                child: const Text('Camera'),
                onPressed: () {
                  imageSource = ImageSource.camera;
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });

    if (dialog == null) {
      
      return null;
    }
    var image = await ImagePicker.pickImage(source: imageSource);

    if (image == null) {
      
      return null;
    }

   url = await FireStorageUploader.uploadImage(image).then((value) {
      
      setState(() {
        _image = image;
      });
      Input.setValue(widget.id, value);
      return value;
    });

    if (url == null) {
      
      return null;
    }
    return url;
  }

  @override
    void initState() {
      Input.setValue(widget.id, widget.value);
      super.initState();
    }
  @override
  Widget build(BuildContext context) {

    var imageContainer = Container(
      width: 200,
      height: 200,
      child: _image == null
          ? Text('No image selected.')
          : InkWell(
              child: Image.file(_image),
              onTap: () {
                getImage();
              }),
    );

if(widget.value!=null){
  print("U use Network Image ${widget.value}");

}
    var noImageContainer = Container(
      width: 200,
      height: 200, 
      child: InkWell(
        child: widget.value!=null ? Image.network(widget.value) : Image.asset("assets/images/no_photo.png"),
        onTap: () {
          getImage();
        },
      ),
    );

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: 8.0,
      ),
      child: Column(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(14.0),
                  child: Text(
                    widget.labelText,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
                _image == null ? noImageContainer : imageContainer,
              ],
            ),
          ),
          RaisedButton(
            child: Text("Delete"),
            onPressed: () {
              Input.setValue(widget.id, null);
              setState(() {
                _image = null;
              });
            },
          ),
        ],
      ),
    );
  }
}
