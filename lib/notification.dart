import 'package:flutter/material.dart';
import 'package:mark_1/ButtomNavbar.dart';
import 'package:mark_1/view_user.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';


List myResponse = [];
bool  _isLoader = false;

class notification extends StatefulWidget {

  final String?  id;
  notification({this.id});

  @override
  State<notification> createState() => _notificationState(id:id);
}

class _notificationState extends State<notification> {
  final String?  id;
  _notificationState({this.id});
  void initState(){
    myResponse = [];
    getNotification();
    _isLoader = true;

  }
  Future getNotification() async {
    var link ="https://mitro-college-project.000webhostapp.com/Api/notification.php";
    final Uri url = Uri.parse(link);

    var response = await http.post(url,body:{
      "id":id,
    });
    setState(() {
      myResponse = jsonDecode(response.body);
      _isLoader = false;

    });
  }

  Future accept(rid) async{
    var link ="https://mitro-college-project.000webhostapp.com/Api/accept.php";
    final Uri url = Uri.parse(link);

    var response = await http.post(url,body:{
      "id":id,
      "rid":rid
    });
    if(response.statusCode == 200){
      setState(() {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
          return ButtomNavbar(id:id,no: 0);
        },),
         ModalRoute.withName("/my_friend"),);
      });
    }
  }
  Future reject(rid) async{
  var link = "https://mitro-college-project.000webhostapp.com/Api/remove_Friend.php";
  final Uri url = Uri.parse(link);

  var response = await http.post(url,body: {
  "my_id":id,
  "friend_id":rid
  });
  if(jsonDecode(response.body) == "Success"){
  Fluttertoast.showToast(
  msg: "Remove Friend Request Successfully",
  toastLength: Toast.LENGTH_SHORT,
  gravity: ToastGravity.CENTER,
  timeInSecForIosWeb: 1,
  backgroundColor: Colors.green,
  textColor: Colors.white,
  fontSize: 16.0);
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
  return ButtomNavbar(id:id,no: 0);
  },),
  ModalRoute.withName("/my_friend"),);

  }
  else{
  Fluttertoast.showToast(
  msg: "Something Wrong",
  toastLength: Toast.LENGTH_SHORT,
  gravity: ToastGravity.CENTER,
  timeInSecForIosWeb: 1,
  backgroundColor: Colors.red,
  textColor: Colors.white,
  fontSize: 16.0);
  }
}
  List<Container> notifications() {
    List<Container> User = [];
    for (int i = 0; i < myResponse.length; i++) {
      var newrequest =  Container(
        height: 80,
        margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        child: InkWell(
          onTap: (){

            List myResponse2 = [];
            setState(() {
              myResponse2.add(myResponse[i]);
            });
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation)=>view_user(myResponse2, id:id),
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: Colors.grey.shade400,
            elevation: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child:(myResponse[i][0]["User_Image"] == "") ||  (myResponse[i][0]["User_Image"] == null)

                      ? CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage('assets/user.jfif'),
                  )
                      : CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(
                        "https://mitro-college-project.000webhostapp.com/Api/" +
                            myResponse[i][0]["User_Image"]),
                  ),
                ),
                Container(
                  child: Text(myResponse[i][0]["User_Fname"]+" "+myResponse[i][0]["User_Lname"],
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                SizedBox(
                  width: 50,
                  height: 50,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.black54,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
                      ),
                      onPressed: () {
                        accept(myResponse![i][0]["User_Id"]);
                      },
                      child: Icon(
                        Icons.check,
                        size: 20,
                      )),
                ),
                SizedBox(
                  width: 50,
                  height: 50,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.black54,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
                      ),
                      onPressed: () {
                        reject(myResponse![i][0]["User_Id"]);
                      },
                      child: Icon(
                        Icons.close_rounded,
                        size: 20,
                      )),
                ),
              ],
            ),
          ),
        ),
      );

      User.add(newrequest);
    }

    return User;
  }

  @override
  Widget build(BuildContext context) {
    return _isLoader == false ?

      Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.black,),onPressed: (){
          Navigator.pop(context);
        },),
        elevation: 0,
        title: Text("Notification",style: TextStyle(color: Colors.black),),
      ),
      body: myResponse.isEmpty?
          Center(child: Text("Currently No Friends Request send",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),):
      SingleChildScrollView(
        child: Column(
          children: notifications(),
        ),
      ),
    ):
    Scaffold(
      backgroundColor: Colors.white,
      body: Center(

        child: CircularProgressIndicator(),
      ),
    );
  }
}
