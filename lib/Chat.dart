import 'package:flutter/material.dart';
import 'package:mark_1/models/chatUserModels.dart';
import 'package:mark_1/chatwidget.dart';

class Chat extends StatefulWidget {
  final String?  id;
  Chat({this.id});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  List<ChatUsers> chatUsers = [
    ChatUsers(name: "Jane Russel",  imageURL: "assets/user.jfif", time: "Now"),
    ChatUsers(name: "Glady's Murphy",  imageURL: "assets/user.jfif", time: "Yesterday"),
    ChatUsers(name: "Jorge Henry",imageURL: "assets/user.jfif", time: "31 Mar"),
    ChatUsers(name: "Philip Fox",  imageURL: "assets/user.jfif", time: "28 Mar"),
    ChatUsers(name: "Debra Hawkins",  imageURL: "assets/user.jfif", time: "23 Mar"),
    ChatUsers(name: "Jacob Pena",  imageURL: "assets/user.jfif", time: "17 Mar"),
    ChatUsers(name: "Andrey Jones",  imageURL: "assets/user.jfif", time: "24 Feb"),
    ChatUsers(name: "John Wick",  imageURL: "assets/user.jfif", time: "18 Feb"),
  ];
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text("Conversations",style: TextStyle(color: Colors.black),),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 16,left: 16,right: 16),
            child: Container(
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Search...",
                      hintStyle: TextStyle(color: Colors.grey.shade600),
                      prefixIcon: Icon(Icons.search,color: Colors.grey.shade600, size: 20,),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: EdgeInsets.all(8),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            width: 2.5,
                              color: Colors.grey.shade400

                          )
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            color: Colors.grey
                        )
                    ),
                    ),
                  ),
                  ListView.builder(
                    itemCount: chatUsers.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: 16),
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index){
                      return ConversationList(
                        name: chatUsers[index].name,
                        imageUrl: chatUsers[index].imageURL,
                        time: chatUsers[index].time,
                      );
                    },
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}