import 'dart:convert';
import 'dart:io';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/utils/controllers/subordinate_scroll_controller.dart';
import 'package:hadar_program/src/models/user/user.dto.dart';
import 'package:hadar_program/src/services/auth/user_service.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../services/networking/http_service.dart';
import '../../../../services/routing/go_router_provider.dart';

class UserProfileScreen extends StatefulHookConsumerWidget {
  const UserProfileScreen({super.key});

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen>
    with SingleTickerProviderStateMixin {
  File? galleryFile;
  final picker = ImagePicker();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final scrollControllers = <SubordinateScrollController?>[null, null];
  bool isLoading = true;
  Map<String, dynamic> myUser = {};

  Future<Map<String, dynamic>> _getUserDetail(String phone) async {
    var data = await HttpService.getUserDetail(phone);
    debugPrint(data.body);
    setState(() {
      myUser = jsonDecode(data.body);
    });
    //Map<String, dynamic> userMap2 = userMap["attributes"];
    //debugPrint("myUser:$myUser");
    // debugPrint(
    //   myUser["apprentices"][1]["first_name"] +
    //       " " +
    //       myUser["apprentices"][1]["last_name"],
    // );
    // print("ozzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz");
    //
    // print(myUser["apprentices"]);

    return myUser;
  }

  @override
  void dispose() {
    emailController.dispose();
    phoneController.dispose();
    for (final scrollController in scrollControllers) {
      scrollController?.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userServiceProvider);
    String imageUrl = user.valueOrNull!.avatar;

    debugPrint(user.valueOrNull!.avatar);
    final userDetails = useFuture(
      useMemoized(
        () => _getUserDetail(
          user.valueOrNull!.phone,
        ),
        [],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'פרופיל אישי',
          style: TextStyle(
            fontWeight: FontWeight.w100,
            color: Colors.black,
          ),
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverOverlapAbsorber(
                // This widget takes the overlapping behavior of the SliverAppBar,
                // and redirects it to the SliverOverlapInjector below. If it is
                // missing, then it is possible for the nested "inner" scroll view
                // below to end up under the SliverAppBar even when the inner
                // scroll view thinks it has not been scrolled.
                // This is not necessary if the "headerSliverBuilder" only builds
                // widgets that do not overlap the next sliver.
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                  context,
                ),
                sliver: SliverAppBar(
                  pinned: true,
                  expandedHeight: 260,
                  automaticallyImplyLeading: false,
                  // The "forceElevated" property causes the SliverAppBar to show
                  // a shadow. The "innerBoxIsScrolled" parameter is true when the
                  // inner scroll view is scrolled beyond its "zero" point, i.e.
                  // when it appears to be scrolled below the SliverAppBar.
                  // Without this, there are cases where the shadow would appear
                  // or not appear inappropriately, because the SliverAppBar is
                  // not actually aware of the precise position of the inner
                  // scroll views.
                  forceElevated: innerBoxIsScrolled,
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(260),
                    child: Column(
                      children: [
                        Builder(
                          builder: (context) {
                            if (userDetails.hasData) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromRGBO(244, 248, 251, 1),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 200,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            CircleAvatar(
                                              radius: 75,
                                              backgroundImage:
                                                  NetworkImage(imageUrl),
                                              backgroundColor:
                                                  Colors.grey.shade200,
                                            ),
                                            Align(
                                              alignment:
                                                  const Alignment(-0.34, 0.56),
                                              child: DecoratedBox(
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(50),
                                                  ),
                                                  color: AppColors.blue08,
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(24),
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    child: InkWell(
                                                      onTap: () {
                                                        _showPicker(
                                                          context: context,
                                                        );
                                                      },
                                                      child: const Padding(
                                                        padding:
                                                            EdgeInsets.all(6),
                                                        child: Icon(
                                                          FluentIcons
                                                              .edit_24_regular,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Center(
                                        child: Text(
                                          (myUser["firstName"] ??
                                                  'NOFIRSTNAME') +
                                              " " +
                                              (myUser["lastName"] ??
                                                  'NOLASTNAME'),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          "0${myUser["id"] ?? 'NOPHONE'}",
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                              );
                            }

                            if (userDetails.hasError) {
                              return const Center(
                                child: Text('An error has occurred!'),
                              );
                            }

                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                        if (user.valueOrNull?.role == UserRole.melave)
                          const TabBar(
                            tabs: [
                              Tab(text: 'תוכנית הדר'),
                              Tab(text: 'פרטים אישיים'),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ];
          },
          body: user.valueOrNull?.role == UserRole.melave
              ? TabBarView(
                  children: [
                    Builder(
                      builder: (context) {
                        final parentController =
                            PrimaryScrollController.of(context);
                        if (scrollControllers[0]?.parent != parentController) {
                          scrollControllers[0]?.dispose();
                          scrollControllers[0] =
                              SubordinateScrollController(parentController);
                        }

                        return CustomScrollView(
                          key: const PageStorageKey<String>('tabs-first'),
                          controller: scrollControllers[0],
                          slivers: [
                            SliverOverlapInjector(
                              // This is the flip side of the SliverOverlapAbsorber
                              // above.
                              handle: NestedScrollView
                                  .sliverOverlapAbsorberHandleFor(
                                context,
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: _GeneralTab(myUser: myUser),
                            ),
                          ],
                        );
                      },
                    ),
                    Builder(
                      builder: (context) {
                        final parentController =
                            PrimaryScrollController.of(context);
                        if (scrollControllers[1]?.parent != parentController) {
                          scrollControllers[1]?.dispose();
                          scrollControllers[1] =
                              SubordinateScrollController(parentController);
                        }

                        return CustomScrollView(
                          key: const PageStorageKey<String>('tab-second'),
                          controller: scrollControllers[1],
                          slivers: [
                            SliverOverlapInjector(
                              // This is the flip side of the SliverOverlapAbsorber
                              // above.
                              handle: NestedScrollView
                                  .sliverOverlapAbsorberHandleFor(
                                context,
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: _PersonalDetailsTab(myUser: myUser),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                )
              : Builder(
                  builder: (context) {
                    final parentController =
                        PrimaryScrollController.of(context);
                    if (scrollControllers[1]?.parent != parentController) {
                      scrollControllers[1]?.dispose();
                      scrollControllers[1] =
                          SubordinateScrollController(parentController);
                    }

                    return CustomScrollView(
                      key: const PageStorageKey<String>('tab-ahraitohnit'),
                      controller: scrollControllers[1],
                      slivers: [
                        SliverOverlapInjector(
                          // This is the flip side of the SliverOverlapAbsorber
                          // above.
                          handle:
                              NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context,
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: _GeneralTab(myUser: myUser),
                        ),
                        SliverToBoxAdapter(
                          child: _PersonalDetailsTab(myUser: myUser),
                        ),
                      ],
                    );
                  },
                ),
        ),
      ),
    );
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
    final user = ref.watch(userServiceProvider);

    final pickedFile = await picker.pickImage(source: img);
    XFile? xfilePick = pickedFile;
    setState(
      () {
        if (xfilePick != null) {
          galleryFile = File(pickedFile!.path);

          HttpService.uploadPhoto(galleryFile!, user.valueOrNull!.phone);
          setState(() {});
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            // is this context <<<
            const SnackBar(content: Text('Nothing is selected')),
          );
        }
      },
    );
  }
}

class _PersonalDetailsTab extends StatelessWidget {
  const _PersonalDetailsTab({
    required this.myUser,
  });

  final Map<String, dynamic> myUser;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.all(15.0),
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(
                  0,
                  3,
                ),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      //empty for spacing
                      Text(
                        ' פרטים אישיים',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w500,
                          fontSize: 19,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const Row(
                    children: [
                      Text(
                        ' ',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w500,
                          fontSize: 19,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(
                      FluentIcons.edit_24_regular,
                      color: AppColors.blue02,
                    ),
                    onPressed: () =>
                        const EditUserProfileRouteData().push(context),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 1.0,
                          ),
                          child: Text(
                            'שם',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 1.0,
                          ),
                          child: Text(
                            'שם משפחה',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 1.0,
                          ),
                          child: Text(
                            ' מייל',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 1.0,
                          ),
                          child: Text(
                            'טלפון',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 1.0,
                          ),
                          child: Text(
                            'תאריך יום הולדת',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 1.0,
                          ),
                          child: Text(
                            'עיר',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 1.0,
                          ),
                          child: Text(
                            'אזור',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 1.0,
                          ),
                          child: Text(
                            myUser["firstName"] ?? 'NOFIRSTNAME',
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 1.0,
                          ),
                          child: Text(
                            myUser["lastName"] ?? 'NOLASTNAME',
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 1.0,
                          ),
                          child: Text(
                            myUser["email"] ?? 'NOEMAIL',
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 1.0,
                          ),
                          child: Text(
                            "0${myUser["id"] ?? 'NOPHONE'}",
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 1.0,
                          ),
                          child: Text(
                            (myUser["dateOfBirthInMsSinceEpoch"] ??
                                'NODATEOFBIRTH'),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 1.0,
                          ),
                          child: Text(
                            myUser["city"] ?? 'NOCITY',
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 1.0,
                          ),
                          child: Text(
                            myUser["region"] ?? 'NOREGION',
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GeneralTab extends ConsumerWidget {
  const _GeneralTab({
    required this.myUser,
  });

  final Map<String, dynamic> myUser;

  @override
  Widget build(BuildContext context, ref) {
    final user = ref.watch(userServiceProvider);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'כללי',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'סיווג משתמש',
                            textAlign: TextAlign.right,
                          ),
                          if (user.valueOrNull?.role == UserRole.melave) ...[
                            const SizedBox(height: 10),
                            const Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: 1.0,
                                ),
                                child: Text(
                                  'שיוך מוסדי',
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: 1.0,
                                ),
                                child: Text(
                                  'אשכול',
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 1.0,
                              ),
                              child: Text(
                                myUser["role"] ?? 'EMPTY ROLE',
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                          if (user.valueOrNull?.role == UserRole.melave) ...[
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 1.0,
                                ),
                                child: Text(
                                  (myUser["institution"] ?? 'NOINSTITUTION'),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 1.0,
                                ),
                                child: Text(
                                  myUser["cluster"] ?? 'NOCLUSTER',
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        if (user.valueOrNull?.role == UserRole.melave)
          Builder(
            builder: (context) {
              // print(scrolength);
              return Column(
                children: <Widget>[
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: 24.0,
                      ),
                      child: Text(
                        'רשימת חניכים',
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: myUser["apprentices"].length,
                    itemBuilder: (
                      BuildContext context,
                      int index,
                    ) {
                      return ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.blue,
                          backgroundImage: AssetImage(
                            'assets/images/person.png',
                          ),
                        ),
                        title: Text(
                          myUser["apprentices"][index]["name"] +
                              " " +
                              myUser["apprentices"][index]["last_name"],
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () => Toaster.unimplemented(),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                ],
              );
            },
          ),
      ],
    );
  }
}
