import 'dart:async';
import 'package:flutter/material.dart';
import 'location_app.dart'; 
import 'informing_via_email_sms.dart'; 

class AccidentAnimation extends StatefulWidget {
  @override
  _AccidentAnimationState createState() => _AccidentAnimationState();
}

class _AccidentAnimationState extends State<AccidentAnimation> {
  int countdown = 10;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  void startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (countdown > 0) {
          countdown--;
        } else {
          _timer.cancel();
          navigateToInformingPage();
        }
      });
    });
  }

  void navigateToInformingPage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => InformingViaEmailSms()),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: 360,
            height: 800,
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 10,
                  strokeAlign: BorderSide.strokeAlignOutside,
                ),
                borderRadius: BorderRadius.circular(45),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 90,
                  top: 140,
                  child: Container(
                    width: 180,
                    height: 180,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          top: 0,
                          child: Container(
                            width: 180,
                            height: 180,
                            decoration: ShapeDecoration(
                              color: Color(0xFFE52A2D),
                              shape: StarBorder.polygon(sides: 3),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 78,
                          top: 99,
                          child: Container(
                            width: 22,
                            height: 22,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: OvalBorder(),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 78,
                          top: 43,
                          child: Container(
                            width: 22,
                            height: 22,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: OvalBorder(),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 100.87,
                          top: 89.80,
                          child: Transform(
                            transform: Matrix4.identity()
                              ..translate(0.0, 0.0)
                              ..rotateZ(3.12),
                            child: Container(
                              width: 22,
                              height: 38.81,
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: StarBorder.polygon(sides: 3),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  top: 320,
                  child: SizedBox(
                    width: 320,
                    height: 62,
                    child: Text(
                      'An Accident has been detected!',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 40,
                        fontFamily: 'Hammersmith One',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 88,
                  top: 610,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    },
                    child: Container(
                      width: 182,
                      height: 64,
                      decoration: ShapeDecoration(
                        color: Color(0xFFF39B9C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child:Center(
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Color(0xFF2B2B2B),
                            fontSize: 30,
                            fontFamily: 'Hammersmith One',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 145,
                  top: 492,
                  child: Container(
                    width: 92,
                    height: 75,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          top: 0,
                          child: SizedBox(
                            width: 44,
                            height: 75,
                            child: Text(
                              '1',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 60,
                                fontFamily: 'Hammersmith One',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 22,
                          top: 0,
                          child: SizedBox(
                            width: 70,
                            height: 40,
                            child: Text(
                              '$countdown',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 60,
                                fontFamily: 'Hammersmith One',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
