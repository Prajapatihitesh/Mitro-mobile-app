import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mark_1/Me.dart';


class view_user extends StatefulWidget {
  final List? mapResponce;
  final String? id;

  view_user(this.mapResponce,{this.id});
  @override
  State<view_user> createState() => _view_userState(mapResponce:mapResponce, id:id);
}

class _view_userState extends State<view_user> {
  final List? mapResponce;
  final String? id;

  _view_userState({this.mapResponce,this.id});

  List<Padding> getHobby(){
    List<Padding> hobby = [];
    for(int i = 1; i<=mapResponce![0].length-1; i++){
      var newValue =    Padding(
        padding: const EdgeInsets.all(2.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.circle,
            ),
            Text(" "+mapResponce![0][i]['Hobby_name'],
              style: TextStyle(fontSize: 17),
            )
          ],
        ),
      );
      hobby.add(newValue);
    }
    return hobby;
  }
  void alert(){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Send Friend Request to '+ mapResponce![0][0]['User_Fname'] + " " +mapResponce![0][0]['User_Lname']),
            content: Container(
              height: MediaQuery.of(context).size.height /10 ,
              width: MediaQuery.of(context).size.width/2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(

                  height: 50,
                  width: 120,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.black),
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child:
                    Text('Cancel'),

                  ),
                ),
                  SizedBox(
                    height: 50,
                    width: 120,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.black),
                      //if user click this button, user can upload image from gallery
                      onPressed: () {
                        Navigator.pop(context);
                        send();
                      },
                      child:
                          Text(
                            'Confirm',
                          ),
                    ),
                  ),

                ],
              ),
            ),
          );
        });
  }
  Future send() async{
    var link = "https://mitro-college-project.000webhostapp.com/Api/friend_request.php";
    final Uri url = Uri.parse(link);

    var response = await http.post(url,body: {
      "my_id":mapResponce![0][0]["User_Id"].toString(),
      "friend_id":id
    });

    if(jsonDecode(response.body) == "Success"){
      Fluttertoast.showToast(
          msg: "Send Friend Request Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    else{
      Fluttertoast.showToast(
          msg: "Already Request send",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
     home: Scaffold(

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
                          Text(  mapResponce![0][0]['User_Fname'] + " " +mapResponce![0][0]['User_Lname'],
                            style: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            mapResponce![0][0]["User_Email"],
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),

                      (mapResponce![0][0]["User_Image"] == "") ||  (mapResponce![0][0]["User_Image"] == null)
                      ?
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

                          backgroundImage: NetworkImage("https://mitro-college-project.000webhostapp.com/Api/"+mapResponce![0][0]["User_Image"].toString()),

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
                                (mapResponce![0][0]["User_Add_Area"]==null || mapResponce![0][0]["User_Add_City"]==null ||mapResponce![0][0]["User_Add_State"]==null
                                || mapResponce![0][0]["User_Add_PinCode"]==null)? "Address":
                              mapResponce![0][0]["User_Add_Area"].toString()+" "+
                                  mapResponce![0][0]["User_Add_City"].toString()+" "+
                                  mapResponce![0][0]["User_Add_State"].toString()+" "+
                                  mapResponce![0][0]["User_Add_PinCode"].toString(),
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
                            (mapResponce![0][0]["User_Mob"]==null?"Mobile no":mapResponce![0][0]["User_Mob"].toString()),
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
                            (mapResponce![0][0]["User_Gender"]==null?"Gender":mapResponce![0][0]["User_Gender"].toString()),
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
                      ),

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
                                Navigator.pop(context);

                                // print(mapResponce);
                              },
                              child: const Text(
                                "Back",
                                style: TextStyle(fontSize: 15),
                              ))),
                      SizedBox(
                        height: 50,
                        width: 150,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black87),
                            onPressed: () {
                              alert();
                            },
                            child: const Text(
                              "Send Request",
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
      ),
    );
  }
}
