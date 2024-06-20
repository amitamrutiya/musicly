import 'package:flutter/material.dart';
import 'package:musicly/components/add_singer_form.dart';
import 'package:musicly/components/add_song_form.dart';
import 'package:musicly/constant/dimensions.dart';

class BottomModelSheet extends StatefulWidget {
  const BottomModelSheet({super.key});

  @override
  State<BottomModelSheet> createState() => _BottomModelSheetState();
}

class _BottomModelSheetState extends State<BottomModelSheet> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const AddSongForm(),
            SizedBox(height: Dimensions.height20),
            const AddSingerForm()
          ],
        ),
      ),
    );
  }
}
