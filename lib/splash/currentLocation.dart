import 'dart:io';
import 'package:worksmart/splash/cached_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:worksmart/homePage.dart';
import 'package:worksmart/weather_bloc/weather_bloc_bloc.dart';
import 'package:worksmart/weather_bloc/weather_bloc_event.dart';

class CurrentLocation extends StatefulWidget {
  const CurrentLocation({super.key});

  @override
  State<CurrentLocation> createState() => _CurrentLocationState();
}

class _CurrentLocationState extends State<CurrentLocation> {
  String currentAddress = 'My Address';
  Position? currentPosition;
  String? city;

  Future<Position?> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are denied forever, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      setState(() {
        currentPosition = position;
        currentAddress = "${place.locality}, ${place.country}";
        city = (place.locality).toString();
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[300],
      appBar: AppBar(
        title: Text('Find current location',
            style: TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold)),
        backgroundColor: Colors.purple[500],
      ),
      body: Container(
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Current Location: ',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                    decorationStyle: TextDecorationStyle.wavy,
                  ),
                ),
                Text(currentAddress,
                    style: TextStyle(fontSize: 20, color: Colors.white)),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Text(
                  'Latitude: ',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                    decorationStyle: TextDecorationStyle.wavy,
                  ),
                ),
                ((currentPosition) != null)
                    ? Text(currentPosition!.latitude.toString(),
                        style: TextStyle(fontSize: 20, color: Colors.white))
                    : Container(),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Text('Longitude: ',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                      decorationStyle: TextDecorationStyle.wavy,
                    )),
                (currentPosition != null)
                    ? Text(currentPosition!.longitude.toString(),
                        style: TextStyle(fontSize: 20, color: Colors.white))
                    : Container(),
              ],
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                _determinePosition();
              },
              child: Text('Locate me', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                  minimumSize:
                      Size((MediaQuery.of(context).size.width * 0.8), 50),
                  backgroundColor: Colors.purple[500]),
            ),
            SizedBox(height: 10),
            ElevatedButton(
                child: Text('Get current location data',
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  minimumSize:
                      Size((MediaQuery.of(context).size.width * 0.8), 50),
                  backgroundColor: Colors.purple[500],
                ),
                onPressed: () {
                  _determinePosition();
                  if (city != null) {
                    BlocProvider.of<WeatherBlocBloc>(context)
                        .add(FetchWeather(cityName: city));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomePage(
                                  cityName: city,
                                )));
                  } else {
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
                              content: Text('Locate yourself first!'),
                              contentPadding: const EdgeInsets.all(8),
                            ));
                  }
                }),
          ],
        ),
      ),
    );
  }
}
