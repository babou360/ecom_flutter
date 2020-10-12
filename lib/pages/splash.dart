import 'package:ecom/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'login.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState(){
    super.initState();
    Future.delayed(Duration(seconds: 5),()=>
    Navigator.of(context).pushReplacement(MaterialPageRoute(
    builder: (BuildContext context) =>
    StreamBuilder(
      stream: auth.authStateChanges(),
      builder:  (context,snapshot){
        if(snapshot.hasData){
          return Home();
        }else{
          // return LoginRegister();
          return Login();
        }
      }))
    ));
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFC107),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
           child: Text("Land Lord",style: GoogleFonts.lobster(
            // child: Text("Land Lord",style: GoogleFonts.monoton(
             fontSize: 50
           ),), 
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          color: Colors.yellow[700],
          height: 55,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Made With",style: GoogleFonts.akronim(
                    fontSize: 20
                  )),
                  SizedBox(width: 5),
                  Icon(Icons.favorite),
                  SizedBox(width: 5),
                  Text("By Babou360",style: GoogleFonts.akronim(
                    fontSize: 20
                  )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}