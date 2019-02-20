import 'package:flutter/material.dart';
import '../models/album.dart';
import '../models/photo.dart';
import '../routes.dart';
import '../utils.dart';

class Photos extends StatefulWidget {
  final Album album;

  Photos({@required this.album}) : assert(album != null);

  @override
  _PhotosState createState() => _PhotosState();
}

class _PhotosState extends State<Photos> {
  Future<List<Photo>> _photos() async => await Routes.photos(widget.album);

  Widget _photo(Photo p) {
    ThemeData theme = Theme.of(context);
    return InkWell(
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 64.0,
            // height: 64.0,
            child: Container(
              padding: EdgeInsets.only(right: 16.0),
              child: ClipOval(
                child: Image.network(
                  p.thumbnailUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: theme.primaryColorLight),
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          p.title,
                          style: theme.textTheme.button,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Text('${p.id}')
                    ],
                  ),
                  Text(p.url)
                ],
              ),
            ),
          ),
        ],
      ),
      onTap: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.album}\'s photos'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: FutureBuilder<List<Photo>>(
          future: _photos(),
          builder: (_, AsyncSnapshot<List<Photo>> snap) {
            if (snap.connectionState != ConnectionState.done)
              return Utils.waiting();
            if (snap.data != null && snap.data.isNotEmpty)
              return ListView(
                children: snap.data.map((p) => _photo(p)).toList(),
              );
            return Utils.empty();
          },
        ),
      ),
    );
  }
}
