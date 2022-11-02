import 'dart:convert';
import 'dart:io';

import '../../values/strings_en.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  String? _localImage;
  bool _inProccess = false;
  // String? _fileExtension;

  _chooseFile() {
    return showModalBottomSheet(
      context: context,
      builder: ((builder) => Container(
            height: 150,
            padding: const EdgeInsets.all(5),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton.icon(
                    icon: const Icon(Icons.camera_alt_outlined),
                    label: const Text('Camera'),
                    onPressed: () {
                      _getImage(ImageSource.camera);
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.photo),
                    label: const Text('Gallery'),
                    onPressed: () {
                      _getImage(ImageSource.gallery);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          )),
    );
  }

  // Future<PermissionStatus> _getImagePermission() async {
  //   PermissionStatus permission = await Permission.camera.status;
  //   if (permission != PermissionStatus.granted &&
  //       permission != PermissionStatus.permanentlyDenied) {
  //     print('allow permision');
  //     PermissionStatus permissionStatus = await Permission.camera.request();
  //     return permissionStatus;
  //   } else {
  //     return permission;
  //   }
  // }

  _getImage(ImageSource source) async {
    // final permissionStatusPhotos = await _getImagePermission();
    setState(() {
      _inProccess = true;
    });
    XFile? pickedFile;
    File? cropedFile;

    var permissionStatusPhotos = await Permission.photos.status;
    if (permissionStatusPhotos.isGranted) {
      pickedFile = (await ImagePicker().pickImage(source: source));
      if (pickedFile != null) {
        File file = File(pickedFile.path);

        cropedFile = File((await ImageCropper().cropImage(
          sourcePath: file.path,
          aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
          // aspectRatioPresets: [CropAspectRatioPreset.square],
          compressQuality: 100,
          maxHeight: 700,
          maxWidth: 700,
          // compressFormat: ImageCompressFormat.jpg,
        ))!
            .path);

        setState(() {
          if (cropedFile != null) {
            _localImage = base64Encode(cropedFile.readAsBytesSync());
          }
          _inProccess = false;
        });
      } else {
        setState(() {
          _inProccess = false;
        });
      }
    } else {
      return 'Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          TITLE_EDIT_PROFILE,
        ),
      ),
      body: _inProccess
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SizedBox(
              height: deviceSize.height,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: deviceSize.height * 0.2,
                    color: Theme.of(context).primaryColor,
                  ),
                  Positioned(
                    top: deviceSize.height * 0.112,
                    left: deviceSize.width * 0.319445,
                    // right: 10.0,
                    child: Stack(
                      children: [
                        Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 4,
                              color: Theme.of(context).backgroundColor,
                            ),
                            boxShadow: [
                              BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  color: Colors.black.withOpacity(0.1),
                                  offset: const Offset(0, 10)),
                            ],
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: _localImage != null
                                  ? MemoryImage(base64Decode(_localImage!))
                                  : const NetworkImage(
                                      "https://t3.ftcdn.net/jpg/03/46/83/96/240_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg",
                                    ) as ImageProvider,
                            ),
                          ),
                        ),
                        Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 4,
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                ),
                                color: Theme.of(context).primaryColor,
                              ),
                              child: GestureDetector(
                                onTap: _chooseFile,
                                child: const Icon(Icons.edit),
                              ),
                            )),
                      ],
                    ),
                  ),
                  Positioned(
                    top: deviceSize.height * 0.32,
                    left: 10.0,
                    right: 10.0,
                    child: Form(
                      // key: _form,
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              TextFormField(
                                // initialValue: _initValues['full_name'],
                                decoration: const InputDecoration(
                                    labelText: TITLE_NAME),
                                textInputAction: TextInputAction.next,

                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return TITLE_ENTER_NAME;
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                // initialValue: _initValues['mobile_no'],
                                decoration: const InputDecoration(
                                    labelText: TITLE_MOBILE),
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,

                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return TITLE_ENTER_MOBILE;
                                  }
                                  if (value.length != 10) {
                                    return TITLE_ENTER_ONLY_10_DIGIT;
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                // initialValue: _initValues['email'],
                                decoration: const InputDecoration(
                                    labelText: TITLE_EMAIL),
                                textInputAction: TextInputAction.next,

                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return TITLE_ENTER_EMAIL;
                                  }
                                  return null;
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: deviceSize.height * 0.0639,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary:
                                              Theme.of(context).primaryColor),
                                      child: const Text(TITLE_SAVE),
                                      onPressed: () {},
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
