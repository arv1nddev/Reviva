import 'package:flutter/material.dart';

class SplashScreen
    extends
        StatefulWidget {
  const SplashScreen({
    super.key,
  });
  @override
  SplashScreenState createState() =>
      SplashScreenState();
}

class SplashScreenState
    extends
        State<
          SplashScreen
        > {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(
        seconds:
            3,
      ),
      () {
        Navigator.pushReplacementNamed(
          context,
          '/auth',
        );
      },
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage(
                'assets/images/revivaSplash.png',
              ),
            ),
            SizedBox(
              height:
                  20,
            ),
            Text(
              'Initializing Your Health Journey...',
              style: TextStyle(
                fontSize:
                    18,
                color: const Color.fromARGB(
                  255,
                  24,
                  24,
                  24,
                ),
                fontWeight:
                    FontWeight.bold,
              ),
            ),
            SizedBox(
              height:
                  25,
            ),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
