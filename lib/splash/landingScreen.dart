import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:worksmart/homePage.dart';
import 'package:worksmart/splash/cached_data.dart';
import 'package:worksmart/splash/currentLocation.dart';
import 'package:worksmart/weather_bloc/weather_bloc_bloc.dart';
import 'package:worksmart/weather_bloc/weather_bloc_event.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  static final textController = new TextEditingController();
  static String cityName1 = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  CurrentLocation obj = new CurrentLocation();
  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    _initializeSharedPreferences();
  }

  Future<void> _initializeSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    // Optionally, you can load initial data here if needed.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[300],
      appBar: AppBar(
        backgroundColor: Colors.purple[500],
        title: Text(
          "AccuWeather",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  height: 244,
                  width: 244,
                  child: Lottie.asset('assets/earthanimation.json')),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_pin, size: 30),
                  Text(
                    "Enter name of city for its weather information",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: textController,
                  onChanged: (value) => setState(() {
                    cityName1 = value;
                  }),
                  validator: (value) {
                    final regExp = RegExp(r'^[a-zA-Z]+(?:[\s-][a-zA-Z]+)*$');
                    if (value!.isNotEmpty && regExp.hasMatch(value)) {
                      return null;
                    } else {
                      return "Enter a valid non empty city name";
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "eg. Kathmandu",
                    labelText: "City Name",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_pin),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    final result =
                        await InternetAddress.lookup('www.google.com');
                    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                      if (_formKey.currentState!.validate()) {
                        BlocProvider.of<WeatherBlocBloc>(context)
                            .add(FetchWeather(cityName: cityName1));

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomePage(
                                    cityName: cityName1,
                                  )),
                        );
                      }
                    }
                  } on SocketException catch (_) {
                    if (prefs!.containsKey('${cityName1}_sunrise')) {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                actions: [
                                  TextButton(
                                    child: Text('Yes'),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                HomePage(cityName: cityName1)),
                                      );
                                    },
                                  ),
                                  TextButton(
                                    child: Text('No'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                                title: Text('Error'),
                                content: Text(
                                    'You are offline. Do you want to see cached data?'),
                                contentPadding: const EdgeInsets.all(8),
                              ));
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                actions: [
                                  TextButton(
                                    child: Text('Ok'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                                title: Text('Error'),
                                content: Text(
                                    'Cached data for the given city does not exist'),
                                contentPadding: const EdgeInsets.all(8),
                              ));
                    }
                  }
                },
                child: Text("Get weather information",
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                    minimumSize:
                        Size((MediaQuery.of(context).size.width * 0.95), 50),
                    backgroundColor: Colors.purple[500]),
              ),
              SizedBox(height: 5),
              ElevatedButton(
                onPressed: () async {
                  try {
                    final result =
                        await InternetAddress.lookup('www.google.com');
                    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CurrentLocation()),
                      );
                    }
                  } on SocketException catch (_) {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              actions: [
                                TextButton(
                                  child: Text('Close'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                              title: Text('Error'),
                              content: Text('No Internet Connection!'),
                              contentPadding: const EdgeInsets.all(8),
                            ));
                  }
                },
                child: Text("Current Location Weather",
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                    minimumSize:
                        Size((MediaQuery.of(context).size.width * 0.95), 50),
                    backgroundColor: Colors.purple[300]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
