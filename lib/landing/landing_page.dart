import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/auth/login/login.dart';

class Landing extends StatefulWidget {
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Image.asset(
                  'assets/images/logo2.png',
                  height: 200.0,
                  width: 300.0,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0.0,
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    CupertinoPageRoute(
                      builder: (_) => Login(),
                    ),
                  );
                },
                child: Container(
                  height: 45.0,
                  width: 130.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.0),
                    border:
                        Border.all(color: Color.fromARGB(255, 201, 201, 201)),
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        // Theme.of(context).colorScheme.secondary,
                        Color.fromARGB(255, 255, 253, 253),
                        Color.fromARGB(255, 0, 0, 0),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'LOGIN',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    CupertinoPageRoute(
                      builder: (_) => Login(),
                    ),
                  );
                },
                child: Container(
                  height: 45.0,
                  width: 130.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.0),
                    border:
                        Border.all(color: Color.fromARGB(255, 201, 201, 201)),
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        // Theme.of(context).colorScheme.secondary,
                        Color.fromARGB(255, 255, 255, 255),
                        Color.fromARGB(255, 0, 0, 0),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'SIGN UP',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
