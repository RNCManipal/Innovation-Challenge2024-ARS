import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'infopage.dart';

class Utils {
  static void emptyFunction() {}
}

class intropage extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<intropage> {
  bool _visible = false;
  bool _fadeinover = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 250),
        () => setState(() => _visible = true));
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _fadeinover = true; // Start fade-in
        Future.delayed(const Duration(seconds: 6), () {
          setState(() => _fadeinover = false);
        });
      });
    });

    Future.delayed(const Duration(seconds: 9), () {
      setState(() {
        _navigateToInfoPage();
        // Navigate to InfoPage after animation ends
      });
    });
  }

  void _navigateToInfoPage() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) {
        return infopage();
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 160),
              AnimatedOpacity(
                opacity: _visible ? 1.0 : 0.0,
                duration: const Duration(seconds: 1),
                curve: Curves.easeIn,
                child: Container(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/Vector.png',
                        width: 124,
                        height: 111,
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Accident',
                            style: GoogleFonts.hammersmithOne(
                              color: Colors.black,
                              fontSize: 40.0,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Detection',
                            style: GoogleFonts.hammersmithOne(
                              color: Colors.red,
                              fontSize: 40.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          AnimatedContainer(
            duration: Duration(seconds: 4),
            curve: Curves.easeIn,
            color: _fadeinover ? Colors.red : Colors.transparent,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
        ],
      ),
    );
  }
}
