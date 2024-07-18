import 'package:flutter/material.dart';

class InformingViaEmailSms extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
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
                left: 130,
                top: 355,
                child: Container(
                  width: 100,
                  height: 100,
                  child: FlutterLogo(),
                ),
              ),
              Positioned(
                left: 81,
                top: 122,
                child: SizedBox(
                  width: 248,
                  height: 130,
                  child: Text(
                    'Informing emergency contacts',
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
                left: 89,
                top: 607,
                child: Container(
                  width: 182,
                  height: 64,
                  decoration: ShapeDecoration(
                    color: Color(0xFFF39B9C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 130,
                top: 620,
                child: SizedBox(
                  width: 152,
                  height: 38,
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
            ],
          ),
        ),
      ],
    );
  }
}