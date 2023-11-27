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
  bool isLoading = true;
  late TabController tabController;
  int scrolength = 2000;
  late Map<String, dynamic> myUser;

  Future<Map<String, dynamic>> _getUserDetail() async {
    print("access");
    var data = await HttpService.getUserDetail("+972549247616");

    Map<String, dynamic> userMap = jsonDecode(data.body);
    Map<String, dynamic> userMap2 = userMap["attributes"];
    myUser = userMap2;
    print(myUser);
    return userMap2;
  }

  Future<List<String>?> _getUserAprentice() async {
    List<String>? result = myUser["apprentices"].split(',');
    print(result);
    return result;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 2, vsync: this, initialIndex: 1);
  }

  @override
  Widget build(BuildContext context) {
    //display image selected from gallery
    Size size = MediaQuery.of(context).size;

    return SizedBox(
        width: 200.0,
        height: scrolength.toDouble() * 200,
        child: Scaffold(
          appBar: AppBar(
            leading: GestureDetector(
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onTap: () => const HomeRouteData().go(context),
            ),
            title: const Text(
              'פרופיל אישי',
              style: TextStyle(
                fontWeight: FontWeight.w100,
                color: Colors.black,
              ),
            ),
          ),
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
                    Container(
                      height: size.height / 3.4,
                      width: size.width * 9 / 10,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(244, 248, 251, 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: size.height / 6,
                            width: size.width / 3,
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
                            myUser!["firstName"].replaceAll(' ', '') +
                                " " +
                                myUser!["lastName"].replaceAll(' ', ''),
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
                            text: 'תוכנית הדר',
                          ),
                          Tab(
                            text: 'פרטים אישיים',
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
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.all(15.0),
                                  padding: const EdgeInsets.all(24.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Column(children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        //empty for spacing
                                        Text(
                                          'כללי',
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontStyle: FontStyle.normal,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'סיווג משתמש',
                                                  textAlign: TextAlign.right,
                                                ),
                                                SizedBox(height: 10),
                                                Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 1.0),
                                                    child: Text(
                                                      'שיוך מוסדי',
                                                      textAlign:
                                                          TextAlign.right,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 1.0),
                                                    child: Text(
                                                      'אשכול',
                                                      textAlign:
                                                          TextAlign.right,
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 1.0),
                                                    child: Text(
                                                      myUser!["role"],
                                                      textAlign:
                                                          TextAlign.right,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 1.0),
                                                    child: Text(
                                                      myUser!["institution"],
                                                      textAlign:
                                                          TextAlign.right,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 1.0),
                                                    child: Text(
                                                      myUser!["cluster"],
                                                      textAlign:
                                                          TextAlign.right,
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                        ]),
                                  ]),
                                ),
                                Container(
                                  width: 400,
                                  margin: const EdgeInsets.all(15.0),
                                  padding: const EdgeInsets.all(3.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: FutureBuilder(
                                    future: _getUserAprentice(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot snapshot) {
                                      scrolength = snapshot.data.length;
                                      print(scrolength);
                                      if (snapshot.hasError) {
                                        return const Center(
                                          child: Text('An error has occurred!'),
                                        );
                                      } else if (snapshot.hasData) {
                                        return Column(
                                          children: <Widget>[
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    right: 24.0),
                                                child: Text(
                                                  'רשימת חניכים',
                                                  textAlign: TextAlign.right,
                                                ),
                                              ),
                                            ),
                                            ListView.builder(
                                                scrollDirection: Axis.vertical,
                                                shrinkWrap: true,
                                                physics:
                                                    ClampingScrollPhysics(),
                                                itemCount: scrolength,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return ListTile(
                                                    leading: CircleAvatar(
                                                      backgroundColor:
                                                          Colors.blue,
                                                      backgroundImage: AssetImage(
                                                          'assets/images/person.png'),
                                                    ),
                                                    title: Text(
                                                        snapshot.data[index],
                                                        textAlign:
                                                            TextAlign.right,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    onTap: () {},
                                                  );
                                                }),
                                          ],
                                        );
                                      } else {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Scaffold(
                            body: SingleChildScrollView(
                                child: Container(
                              width: size.width * 9 / 10,
                              margin: const EdgeInsets.all(15.0),
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Column(children: [
                                SizedBox(
                                  height: 10,
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
                                SizedBox(
                                  height: 30,
                                ),
//to fill
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(3.0),
                                    ),
                                    Text(
                                      "שם פרטי",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14),
                                    ),
                                    const Text('*',
                                        style: TextStyle(color: Colors.red)),
                                  ],
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
                                              color:
                                                  Colors.black), //<-- SEE HERE
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                      ),
                                    )),
                                SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(3.0),
                                    ),
                                    Text(
                                      " שם משפחה",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14),
                                    ),
                                    const Text('*',
                                        style: TextStyle(color: Colors.red)),
                                  ],
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
                                              color:
                                                  Colors.black), //<-- SEE HERE
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                      ),
                                    )),
                                SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(3.0),
                                    ),
                                    Text(
                                      " מיל",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14),
                                    ),
                                    const Text('*',
                                        style: TextStyle(color: Colors.red)),
                                  ],
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
                                              color:
                                                  Colors.black), //<-- SEE HERE
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                      ),
                                    )),
                                SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(3.0),
                                    ),
                                    Text(
                                      " תאריך יום הולדת",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14),
                                    ),
                                    const Text('*',
                                        style: TextStyle(color: Colors.red)),
                                  ],
                                ),
                                Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: TextField(
                                      controller:
                                          birthDayController, // <-- SEE HERE
                                      decoration: InputDecoration(
                                        hintText: myUser![
                                            "dateOfBirthInMsSinceEpoch"],
                                        isDense:
                                            true, // this will remove the default content padding

                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1,
                                              color:
                                                  Colors.black), //<-- SEE HERE
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                      ),
                                    )),
                                SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(3.0),
                                    ),
                                    Text(
                                      " עיר",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14),
                                    ),
                                    const Text('*',
                                        style: TextStyle(color: Colors.red)),
                                  ],
                                ),
                                Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: TextField(
                                      controller:
                                          cityController, // <-- SEE HERE
                                      decoration: InputDecoration(
                                        hintText: myUser!["city"],
                                        isDense:
                                            true, // this will remove the default content padding

                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1,
                                              color:
                                                  Colors.black), //<-- SEE HERE
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                      ),
                                    )),
                                SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(3.0),
                                    ),
                                    Text(
                                      " אזור",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14),
                                    ),
                                    const Text('*',
                                        style: TextStyle(color: Colors.red)),
                                  ],
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
                                              color:
                                                  Colors.black), //<-- SEE HERE
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
                            floatingActionButton: YourButtonWidget(),
                            floatingActionButtonLocation:
                                FloatingActionButtonLocation.centerFloat,
                          ),
                        ],
                      ),
                    ),
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

          HttpService.uploadPhoto(galleryFile!, "549247616");
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

  YourButtonWidget() {
    Size size = MediaQuery.of(context).size;

    return Container(
        color: Colors.white,
        child: Row(
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
                    height: size.height / 15,
                    width: 140,
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(color: Colors.black, width: 2),

                        primary: Colors.white,
                        shape: StadiumBorder(),
                        // primary: (_myController.text.isEmpty)
                        //     ? Colors.grey
                        //     : Color(sendButtonColor),
                        minimumSize: const Size.fromHeight(50), // NEW
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
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    )),
              ],
            ),
            Row(
              children: [
                Container(
                    height: size.height / 15,
                    width: 180,
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.blue[900], //change text color of button
                        foregroundColor:
                            Colors.white, //change background color of button
                        shape: StadiumBorder(),
                        // primary: (_myController.text.isEmpty)
                        //     ? Colors.grey
                        //     : Color(sendButtonColor),
                        minimumSize: const Size.fromHeight(50), // NEW
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
                            regionController.text + "-" + "cluster_id",
                            cityController.text + "-" + "city_id",
                            firstNameController.text + "-" + "name",
                            lastNameController.text + "-" + "last_name",
                            birthDayController.text + "-" + "birthday",
                            emailController.text + "-" + "email",
                          ];
                          var result = await HttpService.setUserDetail(
                              "userProfile",
                              "+972549247616",
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
        ));
  }
}
