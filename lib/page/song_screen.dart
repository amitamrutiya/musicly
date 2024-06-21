import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:musicly/constant/dimensions.dart';
import 'package:musicly/model/singer_model.dart';
import 'package:musicly/model/song_model.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class SongScreen extends StatefulWidget {
  const SongScreen({super.key, required this.title, required this.imageUrl});
  final String title;
  final String imageUrl;

  @override
  State<SongScreen> createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> {
  var videoPlay = false;
  final _controller = YoutubePlayerController();

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 70,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.title,
              style: const TextStyle(color: Colors.white),
            ),
            SizedBox(width: Dimensions.width20),
            CircleAvatar(
              backgroundImage: NetworkImage(widget.imageUrl),
            )
          ],
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("singers")
              .where("name", isEqualTo: widget.title)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              QuerySnapshot querySnapshot = snapshot.data as QuerySnapshot;
              var data = querySnapshot.docs[0].data();
              SingerModel singer =
                  SingerModel.fromJson(data as Map<String, dynamic>);
              return ListView.builder(
                itemCount: singer.songs.length,
                itemBuilder: (context, index) {
                  SongModel song = singer.songs[index];
                  return ListTile(
                    title: Text(song.songName,
                        style: const TextStyle(fontSize: 20)),
                    leading: Icon(
                      Icons.music_note,
                      size: Dimensions.iconSize24,
                    ),
                    onTap: () async {
                      // Only proceed if the permission was granted
                      final url = song.youtubeLink;
                      Uri uri = Uri.parse(url);
                      String videoId = uri.queryParameters['v'] ?? "";
                      YoutubePlayerController controller =
                          YoutubePlayerController();
                      controller.loadVideoById(videoId: videoId);

                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return YoutubePlayer(
                            controller: controller,
                          );
                        },
                      ).then((value) {
                        controller.pauseVideo();
                        controller.close();
                      });
                    },
                  );
                },
              );
            } else {
              return const Center(child: Text('No data found'));
            }
          }),
    );
  }
}
