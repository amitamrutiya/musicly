  import 'package:musicly/model/song_model.dart';

  class SingerModel {
    final String _name;
    final String _image;
    final String _description;
    final List<SongModel> _songs;

    SingerModel(
        {required String name,
        required String image,
        required String description,
        required List<SongModel> songs})
        : _name = name,
          _image = image,
          _description = description,
          _songs = songs;

    SingerModel.fromJson(Map<String, dynamic> json)
        : _name = json['name'],
          _image = json['image'],
          _description = json['description'],
          _songs = (json['songs'] as List)
              .map((item) => SongModel.fromJson(item as Map<String, dynamic>))
              .toList();
              
    Map<String, dynamic> toJson() {
      Map<String, dynamic> data = <String, dynamic>{};

      data['name'] = _name;
      data['image'] = _image;
      data['description'] = _description;
      data['songs'] = _songs;
      return data;
    }

    // Getters
    String get name => _name;
    String get image => _image;
    String get description => _description;
    List<SongModel> get songs => _songs;
  }
