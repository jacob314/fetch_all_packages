import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:photo_provider/photo_provider.dart';

class PhotoLibrary extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _PhotoLibrary();
}

class _PhotoLibrary extends State<PhotoLibrary> {
  int count = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initPhotoProvider();
  }

  _initPhotoProvider() {
    PhotoProvider.init();
    PhotoProvider.getImagesCount().then((count) {
      setState(() {
        this.count = count;
      });
    });
  }

  Future<Image> _getImageFromPhotoProvider(int index) async {
    print('getimage$index');
    var list = await PhotoProvider.getImage(index, width: 300, height: 300);
    return await Image.memory(list);
  }

  Widget _context() {
    return GridView.builder(
        itemCount: count,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, mainAxisSpacing: 2.0, crossAxisSpacing: 2.0),
        itemBuilder: (ctx, idx) {
          return FutureBuilder<Image>(
            future: _getImageFromPhotoProvider(idx),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return new Container(
                    color: Colors.black,
                  );
                case ConnectionState.waiting:
                  return new Container(
                    color: Colors.yellow,
                  );
                case ConnectionState.active:
                  return new Container(
                    color: Colors.green,
                  );
                case ConnectionState.done:
                  if (snapshot.hasError)
                    return Container(
                      color: Colors.red,
                    );
                  else
                    return snapshot.data;
              }
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
          ),
        ),
        middle: Text(
          '相册',
        ),
      ),
      child: _context(),
    );
  }
}
