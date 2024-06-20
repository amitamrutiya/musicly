import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:musicly/components/app_text_field.dart';
import 'package:musicly/components/big_text.dart';
import 'package:musicly/components/error_snackbar.dart';
import 'package:musicly/components/submit_button.dart';
import 'package:musicly/constant/dimensions.dart';
import 'package:musicly/controller/singer_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:musicly/model/song_model.dart';

class AddSongForm extends StatefulWidget {
  const AddSongForm({super.key});

  @override
  State<AddSongForm> createState() => _AddSongFormState();
}

class _AddSongFormState extends State<AddSongForm> {
  final List<Singer> singers = Get.find<SingerController>().singers;
  var songNameController = TextEditingController();
  var youtubeLinkController = TextEditingController();
  List<MultiSelectItem<String>> items = [];

  @override
  void initState() {
    super.initState();
    items = singers
        .map((singer) => MultiSelectItem<String>(singer.name, singer.name))
        .toList();
  }

  @override
  void dispose() {
    songNameController.dispose();
    youtubeLinkController.dispose();
    super.dispose();
  }

  final bool _isLoading = false;
  List<String> _selectedSingers = [];

  final _formSongKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    CollectionReference signers =
        FirebaseFirestore.instance.collection('signers');
    Future<void> getSigners() async {
      await signers.get().then((value) {
        for (var element in value.docs) {
          print(element.data());
        }
      });
    }

    return Form(
      key: _formSongKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BigText(
            text: "Add Song",
            size: Dimensions.font26,
          ),
          SizedBox(height: Dimensions.height20),
          AppTextField(
            textController: songNameController,
            icon: Icons.music_note_rounded,
            labelText: 'Song Name',
            onSaved: (value) {
              setState(() {
                songNameController.text = value ?? "";
              });
            },
            validator: ((value) {
              if (value!.isEmpty) {
                return 'Please enter Song Name';
              } else {
                return null;
              }
            }),
          ),
          SizedBox(height: Dimensions.height15),
          AppTextField(
            textController: youtubeLinkController,
            icon: Icons.link,
            labelText: 'Youtube Link',
            onSaved: (value) {
              setState(() {
                youtubeLinkController.text = value ?? "";
              });
            },
            validator: ((value) {
              if (value!.isEmpty) {
                return 'Please enter Youtube Link';
              } else {
                return null;
              }
            }),
          ),
          SizedBox(height: Dimensions.height20),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(
                left: Dimensions.height10 / 2, right: Dimensions.height10 / 2),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Dimensions.radius15),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 4,
                      spreadRadius: 1,
                      offset: const Offset(1, 1),
                      color: Colors.grey.withOpacity(0.2))
                ]),
            child: MultiSelectDialogField(
              searchable: true,
              items: items,
              title: const Text("Singers"),
              selectedColor: Colors.blue,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Dimensions.radius15),
                border: Border.all(width: 1.0, color: Colors.white),
              ),
              buttonIcon: const Icon(
                Icons.person_2_outlined,
              ),
              buttonText: const Text(
                "Song Creator",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              onConfirm: (results) {
                _selectedSingers = results;
              },
              validator: ((value) {
                if (value!.isEmpty) {
                  return 'Please enter Song Creator';
                } else {
                  return null;
                }
              }),
            ),
          ),
          SizedBox(height: Dimensions.height30),
          submitButton(
            title: "Add Song",
            onPressed: () async {
              if (ConnectivityResult.none !=
                  await Connectivity().checkConnectivity()) {
                final isValid = _formSongKey.currentState!.validate();
                FocusScope.of(context).unfocus();
                if (isValid) {
                  _formSongKey.currentState!.save();

                  await handleAddSong();
                  songNameController.text = "";
                  youtubeLinkController.text = "";
                  _formSongKey.currentState!.reset();
                  _selectedSingers.clear();

                  Navigator.pop(context);
                }
              } else {
                showErrorSnackBar(
                    title: "Attention",
                    message: "Please Turn On Your Internet");
              }
            },
          )
        ],
      ),
    );
  }

  Future<void> handleAddSong() async {
    SongModel enterSong = SongModel(
        songName: songNameController.text,
        youtubeLink: youtubeLinkController.text,
        submitedAt: DateTime.now());

    List<Future> updateFutures = [];
    for (var author in _selectedSingers) {
      final authorData =
          FirebaseFirestore.instance.collection("singers").doc(author);
      print(authorData.get());
      updateFutures.add(authorData.update({
        "songs": FieldValue.arrayUnion([enterSong.toJson()])
      }));
    }

    try {
      await Future.wait(updateFutures);
      Get.snackbar(
        "All went well",
        "Song Added Successfully",
      );
    } catch (error) {
      print(error.toString());
      showErrorSnackBar(title: error.toString(), message: "Failed to add song");
    }
  }
}
