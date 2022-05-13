import 'dart:async';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hey_plan/Models/profile_model.dart';
import 'package:hey_plan/Pages/start.dart';
import 'package:hey_plan/Services/singleton.dart';
import '../Globals/globals.dart';
import '../Models/tag_model.dart';
import '../Widgets/loading_widget.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

/// ### Profile page widget starting with a Scaffold
///
/// Shown when pressing the user icon on while on any of the pages inside
/// the program after logging in.
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

/// Profile page state
class _ProfilePageState extends State<ProfilePage> {
  /// [Singleton] instance to acces all services
  final Singleton singleton = Singleton.instance;

  /// [LoadingWidget] instance to acces loading widget
  final LoadingWidget l = LoadingWidget();

  /// [TextEditingController] for the description textbox
  final TextEditingController _controllerDesc = TextEditingController();

  List<TagModel> allTags = [];

  /// tag indexes for deletion on selected
  List<TagModel> tagSelectedForDelete = [];

  /// [bool] Shows or hides the [FloatingActionButton] that saves the descripton text to the cloud
  bool editing = false;
  bool loading = false;

  /// TODO: bool if any tag is selected to show delete option
  bool tagSelected = false;

  /// ### Get the logged user profile data
  ///
  /// Async function to get profile data. First awaits for the image url from
  /// firebase storage, then the description and tag uid list from fire database
  /// and finally the tag names from the same database using the tag uids.
  Future<ProfileModel> getProfile() async {
    // Get image url from firestore
    String imageURL = await singleton.storage.getImageUrl(singleton.auth.user!.uid);
    // Get description string and tag uid string list
    var profileDoc = await singleton.db.getProfileData(singleton.auth.user!.uid);
    // Put the description on the description textbox
    _controllerDesc.text = profileDoc['desc'];
    //  Grab the tag names with its uids
    List<TagModel> tags = await singleton.db.getProfileTags(profileDoc['tags']);
    allTags = await singleton.db.getTags();

    if (loading) {
      loading = false;
      Navigator.pop(context);
    }

    // Return a ProfileModel using all the information gathered and the already known user data
    return ProfileModel(singleton.auth.user!.uid, singleton.auth.user!.displayName!, singleton.auth.user!.email!,
        profileDoc['desc'], imageURL, tags);
  }

  /// ### Pick and upload image to firestore
  ///
  /// Async function that prompts the user to pick an image file from the device
  Future uploadPhoto() async {
    // Await the user input and save the result, can be cancelled to return null
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
    // If picked file is not null
    if (result != null) {
      // Create a File object
      File file = File(result.files.single.path!);
      return file;
    } else {
      // Else return 1 ( User cancelled )
      return 1;
    }
  }

  /// ### Logout the user and navigate to start
  ///
  /// First logout and remove all temporal user data via the function in
  /// the [AuthService], then push a replacement until [StartPage]
  void exitUser() async {
    // Logout through the singleton service function
    await singleton.auth.logout();
    // TODO: pop until instead of push replacement ( Sometimes screen would blackout otherwise )
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Perfil",
          style: GoogleFonts.fredokaOne(fontSize: 30),
        ),
      ),
      floatingActionButton: editing
          ? FloatingActionButton(
              child: const Icon(Icons.save),
              onPressed: () async {
                // Upload and replace the description written on the textbox with the currently existing one on the cloud
                await singleton.db.editDescription(singleton.auth.user!.uid, _controllerDesc.text);
                setState(() {
                  // Hide the save button
                  editing = false;
                });
              })
          : Container(),
      body: FutureBuilder<ProfileModel>(
        future: getProfile().timeout(const Duration(seconds: 10)),
        builder: (BuildContext context, AsyncSnapshot<ProfileModel> snapshot) {
          // List of widgets that the future will show when finished
          List<Widget> children;
          // If the results from the future are correct
          if (snapshot.hasData) {
            children = <Widget>[
              imageRowWidget(snapshot.data!),
              descriptionWidget(snapshot.data!.description),
              tagsPickerWidget(snapshot.data!.tags),
              exitButton(),
            ];
          }
          // If the result from the future has an error
          else if (snapshot.hasError) {
            if (kDebugMode) {
              print("Snapshot Error: ${snapshot.error}");
            }
            exitUser();
            children = <Widget>[Container()];
          }
          // If the result from the future still isnt correct or has an error
          else {
            children = const <Widget>[
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting result...'),
              )
            ];
          }
          return SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: children,
              ),
            ),
          );
        },
      ),
    );
  }

  /// ### Description widget changing from a [Container] to a [TextField] on tap
  ///
  /// Requires a [String] description to show on the [Container] while the user
  /// isn't editing it. On tapped, the [Container] swaps to a [TextField] in order
  /// to let the user edit the description. When finished the user can tap the
  /// save [FloatingActionButton] to save the newly written description, to the
  /// profile cloud storage on FireStore.
  Widget descriptionWidget(String description) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: editing
          ? SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              height: MediaQuery.of(context).size.height / 5,
              child: TextField(
                  controller: _controllerDesc,
                  maxLines: 7,
                  expands: false,
                  autofocus: true,
                  decoration: const InputDecoration(fillColor: Color(inputBorderColor))))
          : GestureDetector(
              onTap: () {
                setState(() {
                  editing = true;
                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.75,
                height: MediaQuery.of(context).size.height / 5,
                child: Center(
                    child: Text(
                  description,
                  textAlign: TextAlign.center,
                  maxLines: 7,
                  style: GoogleFonts.amaranth(fontSize: defaultFontSize),
                )),
                decoration: BoxDecoration(
                    color: const Color(lighterBackgroundAccent),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    border: Border.all(color: Colors.grey, width: 1)),
              ),
            ),
    );
  }

  /// ### Widget representing the top row of the profile icluding the image and name
  ///
  /// Requires the [ProfileModel] user data which contains the image URL shown as
  /// a rounded image and the user name next to it as a [Text]. The profile image
  /// can be tapped to prompt the user with a file picker so he can change it [uploadPhoto].
  /// Afterward the image is uploaded to the FireStore cloud [uploadProfilePhoto], finally the widget
  /// gets reloaded to show the new image.
  Widget imageRowWidget(ProfileModel data) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 4,
        decoration: const BoxDecoration(color: Color(darkerBackgroundAccent)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              data.photoURL == null
                  ? SizedBox(width: MediaQuery.of(context).size.width, child: const CircularProgressIndicator())
                  : GestureDetector(
                      onTap: () async {
                        loading = true;
                        l.showLoadingWidget(context, "Updating...");
                        var photo = await uploadPhoto();
                        if (photo != 1) {
                          await singleton.storage.uploadProfilePhoto(singleton.auth.user!.uid, photo);
                          setState(() {});
                        }
                      },
                      child: data.photoURL == ""
                          ? DottedBorder(
                              strokeWidth: 2,
                              dashPattern: const [11, 11],
                              child: Center(
                                child: SizedBox(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text("Subir foto",
                                          style: TextStyle(fontSize: defaultFontSize, color: Color(textButtonColor))),
                                      Icon(Icons.add_a_photo,
                                          size: defaultFontSize * 1.5, color: Color(textButtonColor))
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(
                              height: MediaQuery.of(context).size.height / 3.3,
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: const Color(inputBorderColor),
                                      borderRadius: const BorderRadius.all(Radius.circular(999)),
                                      border: Border.all(color: const Color(darkestBackroundAccent), width: 5)),
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(data.photoURL!),
                                  ),
                                ),
                              ),
                            ),
                    ),
              Text(
                singleton.auth.user!.displayName!,
                style: GoogleFonts.fredokaOne(fontSize: defaultFontSize),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// ### Button to exit the user profile and logout
  ///
  /// On pressed calls [logout] and [Navigator.pushReplacement] which sends the
  /// user to the [StartPage]
  Widget exitButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.75,
        child: TextButton.icon(
            onPressed: () async {
              await singleton.auth.logout();
              Navigator.pushReplacementNamed(context, '/');
            },
            style: TextButton.styleFrom(
                primary: Colors.black,
                elevation: 1,
                padding: const EdgeInsets.all(15),
                backgroundColor: const Color(accentColor),
                textStyle: GoogleFonts.farro(fontSize: defaultFontSize)),
            label: const Text("Salir"),
            icon: const Icon(Icons.logout)),
      ),
    );
  }

  /// ### Tag picker with display and removal
  ///
  /// There are 3 parts to this widget:
  /// * [Tags] contains the users tags and displays its names as multiple bubbles
  /// on the screen
  /// * [TextButton] which only shows after selecting at least one tag, on pressed
  /// removes all selected tags from the user profile on the Firebase cloud
  /// * [TODO Button] which allows for the selection of tags.
  Widget tagsPickerWidget(List<TagModel> tags) {
    List<MultiSelectItem<TagModel?>> tagDropdownItems =
        allTags.map((e) => MultiSelectItem<TagModel?>(e, e.name)).toList();
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.25,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
                top: 0,
                left: 10,
                child: MultiSelectBottomSheetField(
                    items: tagDropdownItems,
                    listType: MultiSelectListType.CHIP,
                    onConfirm: (o) {
                      List<TagModel?> select = o as List<TagModel?>;
                      if (select != []) {
                        singleton.db.addTagToProfile(singleton.auth.user!.uid, select.map((e) => e!.uid).toList());
                      }
                      o.clear();
                      setState(() {});
                    })),
            tagSelectedForDelete.isNotEmpty
                ? Positioned(
                    child: TextButton(
                    child: const Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
                    onPressed: () async {
                      await singleton.db.removeTagsFromProfile(
                          singleton.auth.user!.uid, tagSelectedForDelete.map((e) => e.uid).toList());
                      tagSelectedForDelete.clear();
                      setState(() {});
                    },
                  ))
                : Container(),
            Positioned(
              bottom: 0,
              child: Tags(
                itemCount: tags.length,
                itemBuilder: (int index) {
                  final tag = tags[index];
                  return ItemTags(
                    index: index,
                    //key: Key(index.toString()),
                    title: tag.name,
                    textStyle: GoogleFonts.farro(fontSize: defaultFontSize * 0.8),
                    onPressed: (i) {
                      TagModel clickedTag = tags[i.index!];
                      if (tagSelectedForDelete.any((tag) => tag.uid == clickedTag.uid)) {
                        tagSelectedForDelete.removeWhere((tag) => tag.uid == clickedTag.uid);
                      } else {
                        tagSelectedForDelete.add(clickedTag);
                      }
                      setState(() {});
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
