import 'package:flutter/material.dart';
import 'package:mark_1/chatDetails.dart';

class ConversationList extends StatefulWidget{
  String name;
  String imageUrl;
  String time;
  ConversationList({ required this.name, required this.imageUrl, required this.time});
  @override
  _ConversationListState createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: (){
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation,
                  secondaryAnimation) =>ChatDetails(
                     name: widget.name,
                     imageUrl: widget.imageUrl,
                    time: widget.time,
              ),
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
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade400)
          ),
          padding: EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: AssetImage(widget.imageUrl),
                      maxRadius: 30,
                    ),
                    SizedBox(width: 16,),
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(widget.name, style: TextStyle(fontSize: 16),),
                        ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(widget.time,style: TextStyle(fontSize: 12),),
            ],
          ),
        ),
      ),
    );
  }
}