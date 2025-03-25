import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class WeekScreen extends StatefulWidget {
  const WeekScreen({super.key});

  @override
  State<WeekScreen> createState() => _WeekScreenState();
}

class _WeekScreenState extends State<WeekScreen> {
  // variables
  Map<String, dynamic>? data;
  List<dynamic>? dailyTemps, dailyDates, dailyWeatherCodes;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // function to fetch data form API
  void fetchData() async {
    // convert url to uri object
    Uri url = Uri.parse(
        "https://api.open-meteo.com/v1/forecast?latitude=52.52&longitude=13.41&daily=weather_code,temperature_2m_max&timezone=auto");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        data = jsonDecode(response.body);
        dailyTemps = data!["daily"]["temperature_2m_max"];
        dailyDates = data!["daily"]["time"];
        dailyWeatherCodes = data!["daily"]["weather_code"];
      });
    } else {
      print("Error has occured: ${response.statusCode}");
    }
  }

  // weather conditin variables using switch case
  String getConditions(int weatherCode) {
    switch (weatherCode) {
      case 0:
        return "Clear";
      case 1:
      case 2:
      case 3:
        return "Partly Cloudy";
      case 45:
      case 48:
        return "Fog";
      case 51:
      case 53:
      case 55:
        return "Drizzle";
      case 61:
      case 63:
      case 65:
        return "Rain";
      case 95:
        return "Thunderstorm";

      default:
        return "Unknown";
    }
  }

  // function to navigate back to previous screen
  void navigateBack() {
    Navigator.of(context).pop();
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
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.deepPurple,
                    Colors.purple,
                    Colors.black,
                  ],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 16, top: 60, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // back arrow container
                            GestureDetector(
                              onTap: () => navigateBack(),
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Colors.black,
                                  size: 30,
                                ),
                              ),
                            ),

                            // back text
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                "Back",
                                style: GoogleFonts.openSans(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            )
                          ],
                        ),

                        // container for image
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            // image
                            image: DecorationImage(
                              image: AssetImage("assets/images/cloud.png"),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // calender icon and this week text
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // icon
                          Icon(
                            Icons.calendar_month_rounded,
                            color: Colors.white,
                            size: 30,
                          ),

                          // text
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              "This Week",
                              style: GoogleFonts.openSans(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // display weather details
                    Expanded(
                      child: ListView.builder(
                        itemCount: dailyDates?.length ?? 0,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            padding: EdgeInsets.only(top: 5, bottom: 12),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom:
                                    BorderSide(width: 0.5, color: Colors.white),
                              ),
                            ),

                            // display time, conditoin, temp
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // time
                                Text(
                                  DateFormat("EEE").format(
                                      DateTime.parse(dailyDates![index])),
                                  style: GoogleFonts.openSans(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),

                                // conditions
                                Text(
                                  getConditions(dailyWeatherCodes![index]),
                                  style: GoogleFonts.openSans(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),

                                // temp
                                Text(
                                  "${dailyTemps![index].toString()} °C",
                                  style: GoogleFonts.openSans(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 65,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
