import 'dart:io';
import 'package:exwidgets/src/etc/firestorage_uploader.dart';
import 'package:flutter/material.dart';
import 'package:exwidgets/src/helper/input.dart';
import 'package:image_picker/image_picker.dart';

class ExImageUploader extends StatefulWidget {
  final String id;
  final String labelText;
  final String value;

  ExImageUploader({
    @required this.id,
    @required this.labelText,
    this.value,
  });
  _ExImageUploaderState createState() => _ExImageUploaderState();
}

class _ExImageUploaderState extends State<ExImageUploader> {
  File _image;
  String url;

  deleteImage() {
    Input.setValue(widget.id, null);
    setState(() {
      _image = null;
    });
  }

  Future getImage() async {
    ImageSource imageSource;
    dynamic dialog = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
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

    if (widget.value != null) {
      print("U use Network Image ${widget.value}");
    }
    var noImageContainer = Container(
      width: 200,
      height: 200,
      child: InkWell(
        child: widget.value != null
            ? Image.network(widget.value)
            : Image.network(
                "http://anagatadev.com/exwidgets/assets/no_photo.png"),
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
              deleteImage();
            },
          ),
        ],
      ),
    );
  }
}
