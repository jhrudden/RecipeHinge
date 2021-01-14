import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  Future<String> imageURL(String imageName) async {
    final ref = FirebaseStorage.instance.ref().child('images/$imageName');
    try {
      var url = await ref.getDownloadURL();
      return url;
    } on Exception catch (e) {
      return e.toString();
    }
  }
}
