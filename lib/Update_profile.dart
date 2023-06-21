import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:mark_1/ButtomNavbar.dart';

bool _isLoader = false;

// (mapResponce.isEmpty?"Firstname": mapResponce[0]["User_Fname"].toString())
enum Gender { Male, Female }

class Update_profile extends StatefulWidget {
  final List? mapResponce;

  Update_profile({this.mapResponce});
  @override
  State<Update_profile> createState() =>
      _Update_profileState(mapResponce: mapResponce);
}

class _Update_profileState extends State<Update_profile> {
  final List? mapResponce;
  File? image;
  _Update_profileState({this.mapResponce});

  TextEditingController _fname = TextEditingController();
  TextEditingController _lname = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _area = TextEditingController();
  TextEditingController _city = TextEditingController();
  TextEditingController _state = TextEditingController();
  TextEditingController _pin = TextEditingController();
  TextEditingController _mobile = TextEditingController();
  final ImagePicker _imagepicker = ImagePicker();
  String image_name = "";
  Gender? _gen = Gender.Male;
  List Hobby = [];
  List data = [];
  List selected_hobby = [];
  List<bool> variables = [];

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    image_name = mapResponce![0]["User_Image"] == null
        ? ""
        : mapResponce![0]["User_Image"];
    _fname.text = mapResponce![0]["User_Fname"] == null
        ? ""
        : mapResponce![0]["User_Fname"];

    _lname.text = mapResponce![0]["User_Lname"] == null
        ? ""
        : mapResponce![0]["User_Lname"];
    _email.text = mapResponce![0]["User_Email"] == null
        ? ""
        : mapResponce![0]["User_Email"];
    _area.text = mapResponce![0]["User_Add_Area"] == null
        ? ""
        : mapResponce![0]["User_Add_Area"];
    _city.text = mapResponce![0]["User_Add_City"] == null
        ? ""
        : mapResponce![0]["User_Add_City"];
    _state.text = mapResponce![0]["User_Add_State"] == null
        ? ""
        : mapResponce![0]["User_Add_State"];
    _pin.text = mapResponce![0]["User_Add_PinCode"] == null
        ? ""
        : mapResponce![0]["User_Add_PinCode"];
    _mobile.text =
        mapResponce![0]["User_Mob"] == null ? "" : mapResponce![0]["User_Mob"];
    if (mapResponce![0]["User_Gender"] != null) {
      if (mapResponce![0]["User_Gender"] == 'Male') {
        _gen = Gender.Male;
      } else {
        _gen = Gender.Female;
      }
    }

    selected_hobby = mapResponce![1];
    for (int i = 0; i < mapResponce![2].length; i++) {
      Hobby.add(mapResponce![2][i]['Hobby_name']);
    }
    variables = [];
    for (int i = 0; i < Hobby.length; i++) {
      variables.add(false);
      for (int j = 0; j < selected_hobby.length; j++) {
        if (selected_hobby[j]["Hobby_name"] == Hobby[i]) {
          selected_hobby.removeAt(j);
          variables[i] = true;
          break;
        }
      }
    }

    super.initState();
  }

  Future getImage(ImageSource media) async {
    var img = await _imagepicker.pickImage(source: media);

    setState(() {
      image = File(img!.path);
    });
  }

  void Clearimage() {
    setState(() {
      image = null;
      image_name = "";
    });
  }

  void myAlert(){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Please choose media to select'),
            content: Container(
              height: MediaQuery.of(context).size.height / 5,
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.black),
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.image),
                        Text(
                          'From Gallery',
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.black),
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera),
                        Text('From Camera'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.black),
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);

                      Clearimage();
                    },
                    child: Row(
                      children: [
                        Icon(Icons.clear),
                        Text('Remove Profile Picture'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  List<Padding> getChekebox() {
    List<Padding> check = [];
    for (int i = 0; i < Hobby.length; i++) {
      String value = Hobby[i];
      var newcheckbox = Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: CheckboxListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(width: 1.0, color: Colors.black54),
          ),
          title: Text(value),
          value: variables[i],
          onChanged: (bool? val) {
            setState(() {
              variables[i] = val!;
            });
          },
        ),
      );
      check.add(newcheckbox);
    }
    return check;
  }

  Future run() async {
    // var link = "http://192.168.1.49/flutter_api/Update_profile.php";
    var link =  "https://mitro-college-project.000webhostapp.com/Api/Update_profile.php";

    final Uri url = Uri.parse(link);

    data = [];
    for (int i = 0; i < variables.length; i++) {
      if (variables[i] == true) {
        data.add(Hobby[i]);
      }
    }

    var request = http.MultipartRequest('POST',url);

    if(image != null){
      image_name = image!.path.split("/").last;
      request.files.add(
          http.MultipartFile.fromBytes(
              'picture',
              image!.readAsBytesSync(),
              filename: image_name
          )
      );
              // print(image_name);
    }
    else{
      request.fields.addAll({"picture": image_name});
    }


    request.fields.addAll({
      "id": mapResponce![0]["User_Id"],
      "fname": _fname.text,
      "lname": _lname.text,
      "email": _email.text,
      "area": _area.text,
      "city": _city.text,
      "state": _state.text,
      "pin": _pin.text,
      "mob": _mobile.text,
      "gen": _gen!.name,
      "hobbys": jsonEncode(data)
    });
    var response2 = await request.send();
    // .then((value) => {
    //   value.stream.bytesToString().then((value) => print)
    // });


    if ( response2.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Update Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      setState(() {
        _isLoader = false;
      });
      Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                ButtomNavbar(id: mapResponce![0]["User_Id"], no: 4),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.ease;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
          ModalRoute.withName("/ButtomNavbar"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _isLoader == false
          ? Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: const Text(
                  "Edit Profile",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              body: SingleChildScrollView(
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        image == null
                            ? (image_name.isEmpty
                                ? CircleAvatar(
                                    backgroundImage:
                                        AssetImage('assets/user.jfif'),
                                    radius: 50,
                                    child: InkWell(
                                      onTap: () {
                                        myAlert();
                                        setState(() {});
                                      },
                                    ),
                                  )
                                : CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        "https://mitro-college-project.000webhostapp.com/Api/" +
                                            image_name),
                                    radius: 50,
                                    child: InkWell(
                                      onTap: () {
                                        myAlert();
                                        setState(() {});
                                      },
                                    ),
                                  ))
                            : CircleAvatar(
                                backgroundImage: FileImage(
                                  File(image!.path),
                                ),
                                radius: 50,
                                child: InkWell(
                                  onTap: () {
                                    myAlert();
                                    setState(() {});
                                  },
                                ),
                              ),
                        Form(
                          autovalidateMode: AutovalidateMode.always,
                          key: _formKey,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 30,
                              ),
                              TextFormField(
                                  controller: _fname,
                                  decoration: InputDecoration(
                                      fillColor: Colors.grey.shade100,
                                      filled: true,
                                      labelText: 'First Name',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  validator: MultiValidator([
                                    RequiredValidator(
                                        errorText: "Data Are Not Empty"),
                                  ])),
                              const SizedBox(
                                height: 30,
                              ),
                              TextFormField(
                                  controller: _lname,
                                  decoration: InputDecoration(
                                      fillColor: Colors.grey.shade100,
                                      filled: true,
                                      labelText: 'Last Name',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  validator: MultiValidator([
                                    RequiredValidator(
                                        errorText: "Data Are Not Empty"),
                                  ])),
                              const SizedBox(
                                height: 30,
                              ),
                              TextFormField(
                                  controller: _email,
                                  decoration: InputDecoration(
                                      fillColor: Colors.grey.shade100,
                                      filled: true,
                                      labelText: 'Email',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  validator: MultiValidator([
                                    RequiredValidator(
                                        errorText: "Data Are Not Empty"),
                                    EmailValidator(
                                        errorText: "Not Valid Email Format"),
                                  ])),
                              const SizedBox(
                                height: 30,
                              ),
                              TextFormField(
                                  controller: _area,
                                  decoration: InputDecoration(
                                      fillColor: Colors.grey.shade100,
                                      filled: true,
                                      labelText:
                                          'Area of Your Permanent Address',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  validator: MultiValidator([
                                    RequiredValidator(
                                        errorText: "Data Are Not Empty"),
                                  ])),
                              const SizedBox(
                                height: 30,
                              ),
                              TextFormField(
                                  controller: _city,
                                  decoration: InputDecoration(
                                      fillColor: Colors.grey.shade100,
                                      filled: true,
                                      labelText: 'City',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  validator: MultiValidator([
                                    RequiredValidator(
                                        errorText: "Data Are Not Empty"),
                                  ])),
                              const SizedBox(
                                height: 30,
                              ),
                              TextFormField(
                                  controller: _state,
                                  decoration: InputDecoration(
                                      fillColor: Colors.grey.shade100,
                                      filled: true,
                                      labelText: 'State',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  validator: MultiValidator([
                                    RequiredValidator(
                                        errorText: "Data Are Not Empty"),
                                  ])),
                              const SizedBox(
                                height: 30,
                              ),
                              TextFormField(
                                  controller: _pin,
                                  decoration: InputDecoration(
                                      fillColor: Colors.grey.shade100,
                                      filled: true,
                                      labelText: 'Pin code',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  validator: MultiValidator([
                                    RequiredValidator(
                                        errorText: "Data Are Not Empty"),
                                  ])),
                              const SizedBox(
                                height: 30,
                              ),
                              TextFormField(
                                  controller: _mobile,
                                  decoration: InputDecoration(
                                      fillColor: Colors.grey.shade100,
                                      filled: true,
                                      labelText: 'Mobile No',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  validator: MultiValidator([
                                    RequiredValidator(
                                        errorText: "Data Are Not Empty"),
                                  ])),
                              const SizedBox(
                                height: 30,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: RadioListTile<Gender>(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          side: BorderSide(
                                              width: 1.0,
                                              color: Colors.black54),
                                        ),
                                        tileColor: Colors.grey.shade100,
                                        contentPadding: EdgeInsets.all(0.0),
                                        title: Text('Male'),
                                        value: Gender.Male,
                                        groupValue: _gen,
                                        onChanged: (Gender? val) {
                                          setState(() {
                                            _gen = val;
                                          });
                                        }),
                                  ),
                                  SizedBox(
                                    width: 50,
                                  ),
                                  Expanded(
                                    child: RadioListTile<Gender>(
                                        contentPadding: EdgeInsets.all(0.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          side: BorderSide(
                                              width: 1.0,
                                              color: Colors.black54),
                                        ),
                                        tileColor: Colors.grey.shade100,
                                        title: Text('Female'),
                                        value: Gender.Female,
                                        groupValue: _gen,
                                        onChanged: (Gender? val) {
                                          setState(() {
                                            _gen = val;
                                          });
                                        }),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Column(
                                children: getChekebox(),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 60,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                                height: 50,
                                width: 150,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black87),
                                    onPressed: () {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation,
                                                    secondaryAnimation) =>
                                                ButtomNavbar(
                                                    id: mapResponce![0]
                                                        ["User_Id"],
                                                    no: 4),
                                            transitionsBuilder: (context,
                                                animation,
                                                secondaryAnimation,
                                                child) {
                                              const begin = Offset(1.0, 0.0);
                                              const end = Offset.zero;
                                              const curve = Curves.ease;

                                              var tween = Tween(
                                                      begin: begin, end: end)
                                                  .chain(
                                                      CurveTween(curve: curve));

                                              return SlideTransition(
                                                position:
                                                    animation.drive(tween),
                                                child: child,
                                              );
                                            },
                                          ),
                                          ModalRoute.withName("/ButtomNavbar"));
                                    },
                                    child: const Text(
                                      "Cancel",
                                      style: TextStyle(fontSize: 15),
                                    ))),
                            SizedBox(
                              height: 50,
                              width: 150,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black87),
                                  onPressed: () {
                                    setState(() {
                                      _isLoader = true;
                                    });
                                    run();
                                  },
                                  child: const Text(
                                    "Save",
                                    style: TextStyle(fontSize: 15),
                                  )),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 60,
                        ),
                      ],
                    )),
              ),
            )
          : Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }
}
