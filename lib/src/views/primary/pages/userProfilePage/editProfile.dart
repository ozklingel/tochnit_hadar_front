import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../services/networking/HttpService.dart';
import '../chatBox/errorDialog.dart';
import '../chatBox/successDialog.dart';

class profileEditPage extends StatefulWidget {
  const profileEditPage({super.key});

  @override
  State<profileEditPage> createState() => _profileEditPageState();
}

class _profileEditPageState extends State<profileEditPage>
    with SingleTickerProviderStateMixin {
  ImageProvider<Object>? profileimg =
      NetworkImage('https://picsum.photos/250?image=9');
  File? galleryFile;
  final picker = ImagePicker();
  final emailController = TextEditingController();
  final firstNameController = TextEditingController();
  final regionController = TextEditingController();
  final lastNameController = TextEditingController();
  final birthDayController = TextEditingController();
  final cityController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isLoading = true;
  late TabController tabController;
  int scrolength = 2000;
  late Map<String, dynamic> myUser;
  Future<Map<String, dynamic>> _getUserDetail() async {
    print("access");
    var data = await HttpService.getUserDetail("1");

    Map<String, dynamic> userMap = jsonDecode(data.body);
    Map<String, dynamic> userMap2 = userMap["attributes"];
    myUser = userMap2;
    print(myUser);
    return userMap2;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    //display image selected from gallery

    return SizedBox(
        width: 200.0,
        height: scrolength.toDouble() * 1000,
        child: Scaffold(
          body: FutureBuilder<Map<String, dynamic>>(
            future: _getUserDetail(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('An error has occurred!'),
                );
              } else if (snapshot.hasData) {
                return Column(
                  children: [
                    SafeArea(
                      child: Container(
                        height: 45.0,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    //empty for spacing
                                    Text(
                                      ' ',
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 19,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      height: 40,
                                    ),
                                    Text(
                                      ' פרופיל אישי',
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 19,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    GestureDetector(
                                      child: Icon(
                                        Icons.arrow_forward,
                                        color: Colors.black,
                                      ),
                                      onTap: () =>
                                          const HomeRouteData().go(context),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 180,
                      width: 400,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue[50],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 110,
                            width: 90,
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 75,
                                  backgroundColor: Colors.grey.shade200,
                                  child: CircleAvatar(
                                    radius: 70,
                                    backgroundImage: profileimg,
                                  ),
                                ),
                                Positioned(
                                  bottom: 1,
                                  left: 1,
                                  child: InkWell(
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: CircleAvatar(
                                          radius: 10,
                                          backgroundImage: AssetImage(
                                              'assets/images/pencile.png'), // No matter how big it is, it won't overflow
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 3,
                                          color: Colors.white,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(
                                            50,
                                          ),
                                        ),
                                        color: Colors.white,
                                      ),
                                    ),
                                    onTap: () {
                                      _showPicker(context: context);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            myUser!["firstName"] + " " + myUser!["lastName"],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            myUser!["phone"],
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                    ),
                    Material(
                      color: Colors.white,
                      child: TabBar(
                        controller: tabController,
                        tabs: [
                          Tab(
                            text: 'פרטים אישיים',
                          ),
                          Tab(
                            text: 'תוכנית הדר',
                          ),
                        ],
                        labelColor: Colors.black,
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: tabController,
                        children: [
                          SingleChildScrollView(
                              child: Container(
                            width: 400,
                            margin: const EdgeInsets.all(15.0),
                            padding: const EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.white)),
                            child: Column(children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      GestureDetector(
                                        child: CircleAvatar(
                                          radius: 10,
                                          backgroundColor: Colors.grey.shade200,
                                          child: CircleAvatar(
                                            radius: 70,
                                            backgroundImage: AssetImage(
                                                'assets/images/pencile.png'),
                                          ),
                                        ),
                                        onTap: () =>
                                            const userProfileRouteData()
                                                .go(context),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        ' ',
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 19,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      //empty for spacing
                                      Text(
                                        ' פרטים אישיים',
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 19,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 30,
                              ), //to fill
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(left: 1.0, bottom: 4.0),
                                  child: Text("שם פרטי",
                                      textAlign: TextAlign.right,
                                      style: TextStyle(fontSize: 14)),
                                ),
                              ),
                              Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: TextField(
                                    controller:
                                        firstNameController, // <-- SEE HERE
                                    decoration: InputDecoration(
                                      hintText: myUser!["firstName"],
                                      isDense:
                                          true, // this will remove the default content padding

                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: Colors.black), //<-- SEE HERE
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                    ),
                                  )),
                              SizedBox(
                                height: 30,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(left: 1.0, bottom: 4.0),
                                  child: Text(
                                    "שם משפחה",
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ),
                              Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: TextField(
                                    controller:
                                        lastNameController, // <-- SEE HERE
                                    decoration: InputDecoration(
                                      hintText: myUser!["lastName"],
                                      isDense:
                                          true, // this will remove the default content padding

                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: Colors.black), //<-- SEE HERE
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                    ),
                                  )),
                              SizedBox(
                                height: 30,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(left: 1.0, bottom: 4.0),
                                  child: Text(
                                    "מייל",
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ),
                              Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: TextField(
                                    controller: emailController,
                                    // <-- SEE HERE
                                    decoration: InputDecoration(
                                      hintText: myUser!["email"],
                                      isDense:
                                          true, // this will remove the default content padding

                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: Colors.black), //<-- SEE HERE
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                    ),
                                  )),
                              SizedBox(
                                height: 30,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(left: 1.0, bottom: 4.0),
                                  child: Text(
                                    "תאריך יום הולדת",
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ),
                              Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: TextField(
                                    controller:
                                        birthDayController, // <-- SEE HERE
                                    decoration: InputDecoration(
                                      hintText:
                                          myUser!["dateOfBirthInMsSinceEpoch"],
                                      isDense:
                                          true, // this will remove the default content padding

                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: Colors.black), //<-- SEE HERE
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                    ),
                                  )),
                              SizedBox(
                                height: 30,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(left: 1.0, bottom: 4.0),
                                  child: Text(
                                    "עיר",
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ),
                              Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: TextField(
                                    controller: cityController, // <-- SEE HERE
                                    decoration: InputDecoration(
                                      hintText: myUser!["city"],
                                      isDense:
                                          true, // this will remove the default content padding

                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: Colors.black), //<-- SEE HERE
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                    ),
                                  )),
                              SizedBox(
                                height: 30,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(left: 1.0, bottom: 4.0),
                                  child: Text(
                                    "אזור",
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ),
                              Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: TextField(
                                    controller:
                                        regionController, // <-- SEE HERE
                                    decoration: InputDecoration(
                                      hintText: myUser!["region"],
                                      isDense:
                                          true, // this will remove the default content padding

                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: Colors.black), //<-- SEE HERE
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                    ),
                                  )),
                              SizedBox(
                                height: 50,
                              ),
                            ]),
                          )),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            //empty for spacing
                            Text(
                              ' ',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 19,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            //empty for spacing
                            Container(
                                height: 40,
                                width: 140,
                                alignment: Alignment.bottomCenter,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    side: BorderSide(
                                        color: Colors.black, width: 2),

                                    primary: Colors.white,
                                    shape: StadiumBorder(),
                                    // primary: (_myController.text.isEmpty)
                                    //     ? Colors.grey
                                    //     : Color(sendButtonColor),
                                    minimumSize:
                                        const Size.fromHeight(50), // NEW
                                  ),
                                  onPressed: () async {
                                    if ("result" == "success") {
                                      //showFancyCustomDialog(context);
                                    } else {
                                      // showAlertDialog(context);
                                    }
                                  },
                                  child: const Text(
                                    "שליחת פנייה",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.black),
                                  ),
                                )),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                                height: 40,
                                width: 180,
                                alignment: Alignment.bottomCenter,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue[
                                        900], //change text color of button
                                    foregroundColor: Colors
                                        .white, //change background color of button
                                    shape: StadiumBorder(),
                                    // primary: (_myController.text.isEmpty)
                                    //     ? Colors.grey
                                    //     : Color(sendButtonColor),
                                    minimumSize:
                                        const Size.fromHeight(50), // NEW
                                  ),
                                  onPressed: () async {
                                    print(emailController.text);
                                    if (emailController.text != "" ||
                                        birthDayController.text != "" ||
                                        lastNameController.text != "" ||
                                        firstNameController.text != "" ||
                                        cityController.text != "" ||
                                        regionController.text != "") {
                                      List<String> listOfcontrolerText = [
                                        regionController.text + "-" + "region",
                                        cityController.text + "-" + "city",
                                        firstNameController.text +
                                            "-" +
                                            "firstName",
                                        lastNameController.text +
                                            "-" +
                                            "lastName",
                                        birthDayController.text +
                                            "-" +
                                            "dateOfBirthInMsSinceEpoch",
                                        emailController.text + "-" + "email",
                                      ];
                                      var result =
                                          await HttpService.setUserDetail(
                                              "userProfile",
                                              "1",
                                              listOfcontrolerText);
                                      if (result == "success") {
                                        showFancyCustomDialog(context);
                                      } else {
                                        showAlertDialog(context);
                                      }
                                    } else {
                                      showAlertDialog(context);
                                    }
                                  },
                                  child: const Text(
                                    "שמירה",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ))
                          ],
                        ),
                        Row(
                          children: [
                            //empty for spacing
                            Text(
                              ' ',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 19,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ));
  }

  void _showPicker({
    required BuildContext context,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  getImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(
                      'assets/images/pencile.png'), // No matter how big it is, it won't overflow
                ),
                title: const Text('Camera'),
                onTap: () {
                  getImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future getImage(
    ImageSource img,
  ) async {
    final pickedFile = await picker.pickImage(source: img);
    XFile? xfilePick = pickedFile;
    setState(
      () {
        if (xfilePick != null) {
          galleryFile = File(pickedFile!.path);
          print(galleryFile);
          var list = [galleryFile?.path];
          HttpService.uploadPhotos(list.cast<String>());
          setState(() {
            profileimg = FileImage(galleryFile!);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
              const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );
  }
}
