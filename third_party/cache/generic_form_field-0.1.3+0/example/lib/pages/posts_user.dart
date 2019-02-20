import 'package:flutter/material.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../routes.dart';
import '../utils.dart';

class Posts extends StatefulWidget {
  final User user;

  Posts({@required this.user}) : assert(user != null);

  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  Future<List<Post>> _posts() async => await Routes.posts(widget.user);

  Widget _post(Post p) {
    ThemeData theme = Theme.of(context);
    return InkWell(
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
            Text(p.body)
          ],
        ),
      ),
      // onTap: () => Navigator.of(context)
      //     .push(MaterialPageRoute(builder: (_) => (post: p))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.user}\'s posts'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: FutureBuilder<List<Post>>(
          future: _posts(),
          builder: (_, AsyncSnapshot<List<Post>> snap) {
            if (snap.connectionState != ConnectionState.done)
              return Utils.waiting();
            if (snap.data != null && snap.data.isNotEmpty)
              return ListView(
                children: snap.data.map((p) => _post(p)).toList(),
              );
            return Utils.empty();
          },
        ),
      ),
    );
  }
}
