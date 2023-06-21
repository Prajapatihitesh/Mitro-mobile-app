import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:mark_1/view_user.dart';
import 'dart:convert';
bool  _isLoader = false;
List mapResponce = [];

// String id ="1";
class Home extends StatefulWidget {
  final String? id;

  Home({this.id});

  @override
  State<Home> createState() => _HomeState(id: id);
}

class _HomeState extends State<Home> {
  final String? id;

  _HomeState({this.id});

  void initState() {
    mapResponce = [];
    getdata();
  }

  Future getdata() async {
    // var link = "http://192.168.1.49/flutter_api/Home_api.php";
    var link =
        "https://mitro-college-project.000webhostapp.com/Api/Home_api.php";
    final Uri url = Uri.parse(link);
    var response = await http.post(url, body: {
      "id": id,
    });
    setState(() {
      mapResponce = jsonDecode(response.body);
    });
  }

  // Show all user information in card
  List<Container> getUser() {
    List<Container> User = [];
    for (int i = 0; i < mapResponce.length; i++) {
      var newuser = Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        child: InkWell(
          onTap: () {
            List mapResponce2 = [];
            setState(() {
              mapResponce2.add(mapResponce[i]);
            });
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation)=>view_user(mapResponce2, id:id),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.ease;

                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
            ),
            // ModalRoute.withName("/view_user"),
          );
          },
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            color: Colors.grey.shade400,
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    (mapResponce[i][0]["User_Image"] == "") ||  (mapResponce[i][0]["User_Image"] == null)

                ? CircleAvatar(
                            radius: 40,
                            backgroundImage: AssetImage('assets/user.jfif'),
                          )
                        : CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(
                                "https://mitro-college-project.000webhostapp.com/Api/" +
                                    mapResponce[i][0]["User_Image"]),
                          ),
                    Container(
                      width: 250,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 5.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Row(
                              children: [
                                Text(
                                  "Name: ",
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.grey.shade800),
                                ),
                                SizedBox(
                                  width: 180,
                                  child: Text(
                                    mapResponce[i][0]['User_Fname'] +
                                        " " +
                                        mapResponce[i][0]['User_Lname'],
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade800),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Row(
                              children: [
                                Text(
                                  'Email: ',
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.grey.shade800),
                                ),
                                SizedBox(
                                  width: 180,
                                  child: Text(
                                    mapResponce[i][0]["User_Email"],
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade800),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Row(
                              children: [
                                Text(
                                  'Rating: ',
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.grey.shade800),
                                ),
                                Text(
                                  "Very Good",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade800),
                                ),
                              ],
                            ),
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
      );
      User.add(newuser);
    }

    return User;
  }

  @override
  Widget build(BuildContext context) {
    if(mapResponce.isEmpty){
      setState(() {
        _isLoader = true;
      });
    }
    else{
      setState(() {
        _isLoader = false;
      });
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _isLoader == false ?
      Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text(
              "Home",
              style: TextStyle(color: Colors.black),
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
              child: Column(
                children: getUser(),
              ),
            ),
          )):
      Scaffold(
        backgroundColor: Colors.white,
        body: Center(

          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
