import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class FireStorageUploader {
  static Future<String> uploadImage(var imageFile) async {
    var uuid = Uuid().v1();
    StorageReference ref =
        FirebaseStorage.instance.ref().child("post_$uuid.jpg");
    String url = await ref.putFile(imageFile).onComplete.then((val) async {
      var url = await val.ref.getDownloadURL().then((val) {
        return val;
      });
      return url;
    });
    return url;
  }
}
