import 'package:flutter/material.dart';
import 'package:mark_1/login.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:mark_1/Update_profile.dart';
import 'dart:convert';
bool  _isLoader = false;


List mapResponce = [];

class Me extends StatefulWidget {
  final String? id;

  Me({this.id});
  @override
  State<Me> createState() => _MeState(id : id);
}

class _MeState extends State<Me> {
  final String? id;

  _MeState({this.id
  });
  @override
  void initState() {
    mapResponce = [];
    run();
    super.initState();
  }
  Future run() async {
    // var link = "http://192.168.1.49/flutter_api/profile.php";
    var link = "https://mitro-college-project.000webhostapp.com/Api/profile.php";

    final Uri url = Uri.parse(link);

    var response = await http.post(url,body:{
      "id": id,
    });

      setState((){
        mapResponce = jsonDecode(response.body);
      });


  }

  List<Padding> getHobby(){
    List<Padding> hobby = [];
    for(int i = 0; i<mapResponce[1].length; i++){
      var newValue =    Padding(
        padding: const EdgeInsets.all(2.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.circle,
            ),
            Text(" "+mapResponce[1][i]['Hobby_name'],
              style: TextStyle(fontSize: 17),
            )
          ],
        ),
      );
      hobby.add(newValue);
    }
    return hobby;
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
      home:  _isLoader == false ?

      Scaffold(

        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "Profile",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
              child: Column(
            children: [

              SizedBox(
                height: 20,
              ),
              Container(
                height: 200,
                width: 385,
                decoration:  BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (mapResponce.isEmpty?"Firstname": mapResponce[0]["User_Fname"].toString())+" "+
                              (mapResponce.isEmpty?"Lasttname":    mapResponce[0]["User_Lname"].toString()),
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          mapResponce.isEmpty?"Email":mapResponce[0]["User_Email"].toString(),
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    (mapResponce[0]["User_Image"] == "") ||  (mapResponce[0]["User_Image"] == null) ?
                    CircleAvatar(
                      backgroundColor: Colors.grey.shade400,
                      radius: 50,
                      child: CircleAvatar(
                          radius: 45,

                          backgroundImage: AssetImage('assets/user.jfif')
                      ),
                    )
                        :
                    CircleAvatar(
                      backgroundColor: Colors.grey.shade400,
                      radius: 50,
                      child: CircleAvatar(
                        radius: 45,

                        backgroundImage: NetworkImage("https://mitro-college-project.000webhostapp.com/Api/"+mapResponce[0]["User_Image"].toString()),

                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 30,
              ),
              Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Icon(
                        Icons.place,
                        size: 25,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Flexible(

                        child: Text(
                          (mapResponce[0]["User_Add_Area"] == null?"Address":mapResponce[0]["User_Add_Area"].toString())+" "+
                              (mapResponce[0]["User_Add_City"] == null?"":mapResponce[0]["User_Add_City"].toString())+" "+
                              (mapResponce[0]["User_Add_State"] == null?"":mapResponce[0]["User_Add_State"].toString())+" "+
                              (mapResponce[0]["User_Add_PinCode"]==null?"":mapResponce[0]["User_Add_PinCode"].toString()),
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                      SizedBox(
                        width: 2,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Icon(
                        Icons.contacts,
                        size: 25,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        (mapResponce[0]["User_Mob"]==null?"Mobile no":mapResponce[0]["User_Mob"].toString()),
                        style: TextStyle(fontSize: 17),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Icon(
                        Icons.people,
                        size: 25,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        (mapResponce[0]["User_Gender"] == null ? "Gender":mapResponce[0]["User_Gender"].toString()),
                        style: TextStyle(fontSize: 17),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Icon(
                        Icons.interests_rounded,
                        size: 25,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Hobbies",
                        style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  (mapResponce.isEmpty)
                      ? SizedBox(width: 0,):
                  Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    children: [

                      Column(
                        children:
                         getHobby(),

                      )

                    ],
                  ),
                )


                ],
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
                                  pageBuilder: (context, animation, secondaryAnimation) =>  MyLogin(),
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

                                ModalRoute.withName("/login")
                            );
                            mapResponce = [];
                            // print(mapResponce);
                          },
                          child: const Text(
                            "LogOut",
                            style: TextStyle(fontSize: 15),
                          ))),
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
                              pageBuilder: (context, animation, secondaryAnimation) =>  Update_profile(mapResponce : mapResponce),
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

                          ModalRoute.withName("/Update_Profile")
                          );
                        },
                        child: const Text(
                          "Update Profile",
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
      ):
      Scaffold(
        backgroundColor: Colors.white,
    body: Center(

    child: CircularProgressIndicator(),
    ),
    ),
    );
  }
}
