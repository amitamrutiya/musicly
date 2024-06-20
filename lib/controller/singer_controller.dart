import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:musicly/model/singer_model.dart';
import 'package:musicly/model/song_model.dart';

class Singer {
  String name;
  String imageUrl;

  Singer({required this.name, required this.imageUrl});
}

class SingerController extends GetxController {
  // Create a reactive list of SingerModel

  var singers = <Singer>[].obs;
  var songs = <SongModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchSingers();
    getAllSongs();
  }

  Future<void> fetchSingers() async {
    try {
      CollectionReference collection =
          FirebaseFirestore.instance.collection('singers');
      collection.get().then((QuerySnapshot querySnapshot) {
        singers.clear();

        for (var doc in querySnapshot.docs) {
          var singerName = doc.id;
          var singerUrl = doc.get('image');
          singers.add(Singer(name: singerName, imageUrl: singerUrl));
          // singers.add(Singer(
          //     name: 'John Doe', imageUrl: 'http://example.com/john_doe.jpg'));
        }
      });
    } catch (e) {
      print("Error fetching singers: $e");
    }
  }

  Future<void> addSinger(SingerModel singer) async {
    try {
      CollectionReference collection =
          FirebaseFirestore.instance.collection('singers');
      await collection.doc(singer.name).set(singer.toJson());
      fetchSingers();
    } catch (e) {
      print("Error adding singer: $e");
    }
  }

  Future<void> deleteSinger(String singerName) async {
    try {
      CollectionReference collection =
          FirebaseFirestore.instance.collection('singers');
      await collection.doc(singerName).delete();
      fetchSingers();
    } catch (e) {
      print("Error deleting singer: $e");
    }
  }

  Future<SingerModel?> getSinger(String singerName) async {
    try {
      CollectionReference collection =
          FirebaseFirestore.instance.collection('singers');
      DocumentSnapshot doc = await collection.doc(singerName).get();
      return SingerModel.fromJson(doc.data() as Map<String, dynamic>);
    } catch (e) {
      print("Error getting singer: $e");
      return null;
    }
  }

  Future<void> getAllSongs() async {
    try {
      CollectionReference collection =
          FirebaseFirestore.instance.collection('singers');
      QuerySnapshot querySnapshot = await collection.get();
      for (var doc in querySnapshot.docs) {
        var data = doc.data();
        var singer = SingerModel.fromJson(data as Map<String, dynamic>);
        songs.addAll(singer.songs);
      }
    } catch (e) {
      print("Error getting all songs: $e");
    }
  }
}
