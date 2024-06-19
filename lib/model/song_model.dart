import 'package:cloud_firestore/cloud_firestore.dart';

class SongModel {
  late String _songName;
  late String _youtubeLink;
  late DateTime _submitedAt;

  SongModel({required songName, required youtubeLink, required submitedAt}) {
    _songName = songName;
    _youtubeLink = youtubeLink;
    _submitedAt = submitedAt;
  }
  SongModel.fromJson(Map<String, dynamic> json) {
    _songName = json['songName'];
    _youtubeLink = json['youtubeLink'];
    _submitedAt = (json['submitedAt'] as Timestamp).toDate();
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};

    data['songName'] = _songName;
    data['youtubeLink'] = _youtubeLink;
    data['submitedAt'] = _submitedAt;
    return data;
  }

  // Getters
  String get songName => _songName;
  String get youtubeLink => _youtubeLink;
  DateTime get submitedAt => _submitedAt;
}
