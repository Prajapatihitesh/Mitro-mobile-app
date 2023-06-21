import 'package:flutter/material.dart';
import 'package:mark_1/Me.dart';
import 'package:mark_1/Chat.dart';
import 'package:mark_1/home.dart';
import 'package:mark_1/My_friend.dart';
import 'package:mark_1/Search.dart';
int _selectedIndex = 2;

class ButtomNavbar extends StatefulWidget {
  final String? id;
  final int? no;



  ButtomNavbar({this.id, this.no});


  @override
  State<ButtomNavbar> createState() => _ButtomNavbarState(id: id, no:no);
}

class _ButtomNavbarState extends State<ButtomNavbar> {
  final String? id;
  final int? no;

  var _contain;
  _ButtomNavbarState({this.id,this.no}){
    _contain =  [
      My_friend(id: id),
      Search(),
      Home(id: id),
      Chat(id: id),
      Me(id: id)
    ];
      if(no == 4){
        _selectedIndex = 4;
      }
      else if(no == 3){
        _selectedIndex = 3;
      }
      else if(no == 0){
        _selectedIndex = 0;
      }
      else{
        _selectedIndex = 2;
      }


  }
@override


  void _onItemTapped(int index){

    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Container(
            child: _contain.elementAt(_selectedIndex),

          ),
        ),


        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem> [
            BottomNavigationBarItem(

              icon: Icon(Icons.people_alt_outlined),
              label: 'My Friend',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              label: 'Chat',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Me',
            ),
          ],
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.black,
          iconSize: 25,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}




