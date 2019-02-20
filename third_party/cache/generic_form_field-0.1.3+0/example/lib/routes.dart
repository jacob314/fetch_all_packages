import 'dart:convert';

import 'models/album.dart';
import 'models/comment.dart';
import 'models/photo.dart';
import 'models/post.dart';
import 'models/user.dart';
import 'package:http/http.dart' as http;

class Routes {
  static const String url = 'https://jsonplaceholder.typicode.com/';

  static Future<List<dynamic>> fetch(String service) async {
    var result;
    await http.get('$url$service').then((r) {
      if (r.statusCode == 200) result = json.decode(r.body);
    }).catchError((e, s) => print(e));
    return result;
  }

  static Future<List<User>> users() async {
    var list;
    await fetch('users')
        .then((l) => list = l.map((json) => User.fromJson(json)).toList());
    return list;
  }

  static Future<List<Post>> posts(User user) async {
    var list;
    await fetch('posts?userId=${user.id}')
        .then((l) => list = l.map((json) => Post.fromJson(json)).toList());
    return list;
  }

  static Future<List<Comment>> comments(Post post) async {
    var list;
    await fetch('posts/${post.id}/comments')
        .then((l) => list = l.map((json) => Comment.fromJson(json)).toList());
    return list;
  }

  static Future<List<Album>> albums(User user) async {
    var list;
    await fetch('users/${user != null ? user.id : 0}/albums')
        .then((l) => list = l.map((json) => Album.fromJson(json)).toList());
    return list;
  }

  static Future<List<Photo>> photos(Album album) async {
    var list;
    await fetch('albums/${album.id}/photos')
        .then((l) => list = l.map((json) => Photo.fromJson(json)).toList());
    return list;
  }
}
