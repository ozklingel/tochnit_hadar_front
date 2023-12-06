import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../services/networking/HttpService.dart';
import '../../../../services/routing/go_router_provider.dart';

class userProfileScreen extends StatefulWidget {
  const userProfileScreen({super.key});

  @override
  State<userProfileScreen> createState() => _userProfileScreenState();
}

class _userProfileScreenState extends State<userProfileScreen>
    with SingleTickerProviderStateMixin {
  ImageProvider<Object>? profileimg = NetworkImage(
      "https://th01-s3.s3.eu-north-1.amazonaws.com/c2fb87a53199453ca9f2ac14fb672cfc.jpg");
  File? galleryFile;
  final picker = ImagePicker();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
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
    print("apprentices:" + myUser["apprentices"]);
    return userMap2;
  }

  Future<List<String>?> _getUserAprentice() async {
    List<String>? result = myUser["apprentices"].split(',');
    print(result);
    return result;
  }

  @override
  void dispose() {
    emailController.dispose();
    phoneController.dispose();
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

    return SingleChildScrollView(
        child: SizedBox(
            width: double.infinity,
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
                                      left: 7,
                                      child: InkWell(
                                        child: Container(
                                          child: Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: CircleAvatar(
                                              radius: 10,
                                              backgroundImage: AssetImage(
                                                  'assets/images/pencil2.png'), // No matter how big it is, it won't overflow
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
                                myUser!["phone"].replaceAll(' ', ''),
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
                              Column(
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
                                          offset: Offset(0,
                                              3), // changes position of shadow
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
                                          offset: Offset(0,
                                              3), // changes position of shadow
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
                                            child:
                                                Text('An error has occurred!'),
                                          );
                                        } else if (snapshot.hasData) {
                                          return Column(
                                            children: <Widget>[
                                              Align(
                                                alignment:
                                                    Alignment.centerRight,
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
                                                  scrollDirection:
                                                      Axis.vertical,
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
                              Column(
                                children: [
                                  Container(
                                    width: size.width * 9 / 10,
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
                                          offset: Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Column(children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
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
                                              GestureDetector(
                                                child: CircleAvatar(
                                                  radius: 10,
                                                  backgroundColor:
                                                      Colors.grey.shade200,
                                                  child: CircleAvatar(
                                                    radius: 70,
                                                    backgroundImage: AssetImage(
                                                        'assets/images/pencile.png'),
                                                  ),
                                                ),
                                                onTap: () =>
                                                    const editUserProfileRouteData()
                                                        .go(context),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
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
                                                        'שם',
                                                        textAlign:
                                                            TextAlign.right,
                                                        style: TextStyle(
                                                            color: Colors.grey),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 1.0),
                                                      child: Text(
                                                        'שם משפחה',
                                                        textAlign:
                                                            TextAlign.right,
                                                        style: TextStyle(
                                                            color: Colors.grey),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 1.0),
                                                      child: Text(
                                                        ' מייל',
                                                        textAlign:
                                                            TextAlign.right,
                                                        style: TextStyle(
                                                            color: Colors.grey),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 1.0),
                                                      child: Text(
                                                        'תאריך יום הולדת',
                                                        textAlign:
                                                            TextAlign.right,
                                                        style: TextStyle(
                                                            color: Colors.grey),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 1.0),
                                                      child: Text(
                                                        'עיר',
                                                        textAlign:
                                                            TextAlign.right,
                                                        style: TextStyle(
                                                            color: Colors.grey),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 1.0),
                                                      child: Text(
                                                        'אזור',
                                                        textAlign:
                                                            TextAlign.right,
                                                        style: TextStyle(
                                                            color: Colors.grey),
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
                                                        myUser!["firstName"],
                                                        textAlign:
                                                            TextAlign.right,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 1.0),
                                                      child: Text(
                                                        myUser!["lastName"],
                                                        textAlign:
                                                            TextAlign.right,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 1.0),
                                                      child: Text(
                                                        myUser!["email"],
                                                        textAlign:
                                                            TextAlign.right,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 1.0),
                                                      child: Text(
                                                        myUser!["dateOfBirthInMsSinceEpoch"]
                                                            as String,
                                                        textAlign:
                                                            TextAlign.right,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 1.0),
                                                      child: Text(
                                                        myUser!["city"],
                                                        textAlign:
                                                            TextAlign.right,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 1.0),
                                                      child: Text(
                                                        myUser!["region"],
                                                        textAlign:
                                                            TextAlign.right,
                                                      ),
                                                    ),
                                                  ),
                                                ]),
                                          ]),
                                    ]),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        ///scond container
                      ],
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            )));
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
                leading: const Icon(Icons.camera),
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

          HttpService.uploadPhoto(galleryFile!, "+972549247616");
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
