import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musicly/components/big_text.dart';
import 'package:musicly/constant/dimensions.dart';
import 'package:musicly/constant/image_string.dart';
import 'package:musicly/controller/singer_controller.dart';
import 'package:musicly/page/song_screen.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final List<Singer> singers = Get.find<SingerController>().singers;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
              padding: const EdgeInsets.all(0),
              margin: const EdgeInsets.all(0),
              child: ListView(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: Image.asset(ImageString.singer_image),
                  ),
                ],
              )),
          Container(
            padding: const EdgeInsets.all(10),
            child: BigText(
              text: "Select Your Favorite Singers",
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: singers.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    singers[index].name,
                    style: TextStyle(
                        fontSize: Dimensions.font20, color: Colors.black),
                  ),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(singers[index].imageUrl),
                  ),
                  onTap: () {
                    Get.back();
                    Get.to(() => SongScreen(
                          title: singers[index].name,
                          imageUrl: singers[index].imageUrl,
                        ));
                  },
                );
              },
              separatorBuilder: (context, index) => const Divider(),
            ),
          ),
        ],
      ),
    );
  }
}
