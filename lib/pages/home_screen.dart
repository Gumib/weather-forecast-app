import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // function to gradient hourly forecast text
  Widget gradientText(String text, double fontSize, FontWeight fontWeight) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => LinearGradient(
              colors: [Colors.orange, Colors.white],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight)
          .createShader(bounds),
      child: Text(
        text,
        style: GoogleFonts.openSans(fontSize: fontSize, fontWeight: fontWeight),
      ),
    );
  }

  // UI
  @override
  Widget build(BuildContext context) {
    // SCAFFOLD
    return Scaffold(
      // BODY
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.orange,
              Colors.purple.withValues(alpha: 0.6),
              Colors.black,
            ],
          ),
        ),

        // padding around contents
        child: Padding(
          padding: EdgeInsets.only(left: 16, top: 60, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // timezone, greeting and more icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.openSans(height: 1.1),
                      children: <TextSpan>[
                        // timezone
                        TextSpan(
                          text: "GMT+2\n",
                          style: TextStyle(
                            fontWeight: FontWeight.w100,
                            fontSize: 16,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),

                        // gretting
                        TextSpan(
                          text: "Good Afternoon",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // container for more icon
                  Container(
                    padding: EdgeInsets.all(2),
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        width: 0.5,
                        color: Colors.white,
                      ),
                    ),
                    child: Icon(
                      Icons.more_vert_rounded,
                      color: Colors.white,
                    ),
                  )
                ],
              ),

              // container for image
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Container(
                  height: 300,
                  width: 300,
                  decoration: BoxDecoration(
                    // image
                    image: DecorationImage(
                      image: AssetImage("assets/images/rain_cloud.png"),
                    ),
                  ),
                ),
              ),

              // temp, date and time
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.openSans(height: 1.2),
                    children: <TextSpan>[
                      // temperature
                      TextSpan(
                        text: "27 C\n",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 75,
                          color: Colors.white,
                        ),
                      ),

                      // humidity
                      TextSpan(
                        text: "40% Humidity\n",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),

                      // current date and time
                      TextSpan(
                        text: "Tuesday 25, 2:30PM",
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // hourly forecast text and drop down arrow
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // hourly forecast text
                    gradientText("Hourly Forecast", 20, FontWeight.bold),

                    // drop down arrow
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),

              // display of hourly forecast
              Expanded(
                  child: ListView.builder(
                itemCount: 24,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.only(top: 5, bottom: 12),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 0.5, color: Colors.white),
                      ),
                    ),

                    // display hour, temperature, humidity
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // hour
                        Text(
                          "3:00PM",
                          style: GoogleFonts.openSans(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),

                        // humidty
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Humidity",
                              style: GoogleFonts.openSans(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                            ),
                            Text(
                              "30%",
                              style: GoogleFonts.openSans(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),

                        // temp
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "28 C",
                              style: GoogleFonts.openSans(
                                fontWeight: FontWeight.w500,
                                fontSize: 50,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ))
            ],
          ),
        ),
      ),
    );
  }
}
