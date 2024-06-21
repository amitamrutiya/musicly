import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:musicly/components/app_text_field.dart';
import 'package:musicly/components/big_text.dart';
import 'package:musicly/components/error_snackbar.dart';
import 'package:musicly/components/submit_button.dart';
import 'package:musicly/constant/dimensions.dart';
import 'package:musicly/controller/singer_controller.dart';
import 'package:musicly/model/singer_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddSingerForm extends StatefulWidget {
  const AddSingerForm({super.key});

  @override
  State<AddSingerForm> createState() => _AddSingerFormState();
}

class _AddSingerFormState extends State<AddSingerForm> {
  var singerNameController = TextEditingController();
  var singerImageUrlContoller = TextEditingController();
  var singerDescriptionController = TextEditingController();

  final _formSingerKey = GlobalKey<FormState>();

  @override
  void dispose() {
    singerNameController.dispose();
    singerImageUrlContoller.dispose();
    singerDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formSingerKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BigText(
            text: "Add Singer",
            size: Dimensions.font26,
          ),
          SizedBox(height: Dimensions.height20),
          AppTextField(
            textController: singerNameController,
            icon: Icons.person_outlined,
            labelText: 'Singer Name',
            onSaved: (value) {
              setState(() {
                singerNameController.text = value ?? "";
              });
            },
            validator: ((value) {
              if (value!.isEmpty) {
                return 'Please enter Singer Name';
              } else {
                return null;
              }
            }),
          ),
          SizedBox(height: Dimensions.height20),
          AppTextField(
            textController: singerImageUrlContoller,
            icon: Icons.link,
            labelText: 'Singer Image Url',
            onSaved: (value) {
              setState(() {
                singerImageUrlContoller.text = value ?? "";
              });
            },
            validator: ((value) {
              if (value!.isEmpty) {
                return 'Please enter Singer Image Url';
              } else {
                return null;
              }
            }),
          ),
          SizedBox(height: Dimensions.height20),
          AppTextField(
            textController: singerDescriptionController,
            icon: Icons.description_outlined,
            labelText: 'Singer Description',
            onSaved: (value) {
              setState(() {
                singerDescriptionController.text = value ?? "";
              });
            },
            validator: ((value) {
              if (value!.isEmpty) {
                return 'Please enter Singer Description';
              } else {
                return null;
              }
            }),
          ),
          SizedBox(height: Dimensions.height30),
          submitButton(
            title: "Add Singer",
            onPressed: () async {
              final List<ConnectivityResult> connectivityResult =
                  await (Connectivity().checkConnectivity());
              if (connectivityResult.contains(ConnectivityResult.none)) {
                final isValid = _formSingerKey.currentState!.validate();

                if (isValid) {
                  _formSingerKey.currentState!.save();

                  await handleAddSinger();

                  singerNameController.clear();
                  singerImageUrlContoller.clear();
                  singerDescriptionController.clear();
                  _formSingerKey.currentState!.reset();

                  if (mounted) {
                    Navigator.pop(context);
                  }
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

  Future<void> handleAddSinger() async {
    SingerModel singer = SingerModel(
      name: singerNameController.text,
      image: singerImageUrlContoller.text,
      description: singerDescriptionController.text,
      songs: [],
    );

    await FirebaseFirestore.instance
        .collection('singers')
        .doc(singer.name)
        .set(singer.toJson())
        .then((_) async {
      Get.snackbar(
        "All went well",
        "Singer Added Successfully",
      );
    }).catchError((error) {
      showErrorSnackBar(title: error, message: "Failed to add singer");
    });

    SingerController singerController = Get.find<SingerController>();
    await singerController.fetchSingers();

    setState(() {});
  }
}
