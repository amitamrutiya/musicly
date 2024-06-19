import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musicly/components/big_text.dart';
import 'package:musicly/components/bottom_model_sheet.dart';
import 'package:musicly/components/drawer.dart';
import 'package:musicly/constant/dimensions.dart';
import 'package:musicly/controller/auth_controller.dart';
import 'package:musicly/controller/singer_controller.dart';
import 'package:musicly/model/song_model.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<SongModel> songs = Get.find<SingerController>().songs;

  final AuthController authController =
      Get.put<AuthController>(AuthController());
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 70,
          title: Text(
            widget.title,
            style: const TextStyle(color: Colors.white),
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
            authController.user != null
                ? IconButton(
                    onPressed: () async => await authController.userSignOut(),
                    icon: const Icon(Icons.logout),
                  )
                : Container(),
          ],
        ),
        drawer: const CustomDrawer(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ListView.separated(
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(songs[index].songName),
                      trailing: const Icon(Icons.music_note),
                      leading: const Icon(Icons.play_arrow),
                      onTap: () async {
                        // Only proceed if the permission was granted
                        final url = songs[index].youtubeLink;
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
                  separatorBuilder: (context, index) => const Divider()),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context) {
                return Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: const BottomModelSheet(),
                );
              },
            );
          },
          tooltip: 'Add Songs',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
