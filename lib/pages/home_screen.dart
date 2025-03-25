import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather_forecast_app/pages/week_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // variables
  Map<String, dynamic>? data;
  List<dynamic>? hourlyTimes, hourlyTemp, hourlyHumidity;
  String? timezOne, greetings, formattedDate, formattedTime;

  // function to fetch data from API
  void fetchData() async {
    // convert url string to uri
    Uri url = Uri.parse(
        "https://api.open-meteo.com/v1/forecast?latitude=52.52&longitude=13.41&hourly=temperature_2m,relative_humidity_2m&current=temperature_2m&timezone=auto");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        data = jsonDecode(response.body);
        hourlyTimes = data!["hourly"]["time"].sublist(0, 24);
        hourlyTemp = data!["hourly"]["temperature_2m"].sublist(0, 24);
        hourlyHumidity = data!["hourly"]["relative_humidity_2m"].sublist(0, 24);
        timezOne = data!["timezone"];

        // determine greeting and format time
        DateTime currentTime = DateTime.parse(data!["current"]["time"]);
        int currentHour = currentTime.hour;
        if (currentHour < 12) {
          greetings = "Good Morining";
        } else if (currentHour < 18) {
          greetings = "Good Afternoon";
        } else {
          greetings = "Good Evening";
        }

        // formatted date and time
        formattedDate = DateFormat("EEEE d").format(currentTime);
        formattedTime = DateFormat("h:mm a").format(currentTime);
      });
    } else {
      print("Error: ${response.statusCode}");
    }
  }

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

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // UI
  @override
  Widget build(BuildContext context) {
    // SCAFFOLD
    return Scaffold(
      // BODY
      body: data == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
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
                                text: "$timezOne \n",
                                style: TextStyle(
                                  fontWeight: FontWeight.w100,
                                  fontSize: 16,
                                  color: Colors.white.withValues(alpha: 0.7),
                                ),
                              ),

                              // gretting
                              TextSpan(
                                text: "$greetings",
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
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => WeekScreen(),
                              ),
                            );
                          },
                          child: Container(
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
                              text:
                                  "${data!["current"]["temperature_2m"].toString().substring(0, 2)} C \n",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 75,
                                color: Colors.white,
                              ),
                            ),

                            // humidity
                            TextSpan(
                              text:
                                  "${data!["current"]["relative_humidity_2m"].toString()}% Humidity \n",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),

                            // current date and time
                            TextSpan(
                              text: "$formattedDate, $formattedTime",
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
                        itemCount: hourlyTimes?.length ?? 0,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.only(top: 5, bottom: 12),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom:
                                    BorderSide(width: 0.5, color: Colors.white),
                              ),
                            ),

                            // display hour, temperature, humidity
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // hour
                                Text(
                                  DateFormat("h a").format(
                                      DateTime.parse(hourlyTimes![index])),
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
                                        color:
                                            Colors.white.withValues(alpha: 0.7),
                                      ),
                                    ),
                                    Text(
                                      "${hourlyHumidity![index].toString()}%",
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
                                      "${hourlyTemp![index].toString()} C",
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
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
