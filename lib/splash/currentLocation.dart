import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class CurrentLocation extends StatefulWidget {
  const CurrentLocation({super.key});

  @override
  State<CurrentLocation> createState() => _CurrentLocationState();
}

class _CurrentLocationState extends State<CurrentLocation> {
  String currentAddress = 'My Address';
  Position? currentPosition;

  Future<Position?> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      SnackBar(content: Text('Enable location service'));
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        SnackBar(content: Text('Location Permission is denied'));
      }
    }
    if (permission == LocationPermission.deniedForever) {
      SnackBar(content: Text('Permission denied forever'));
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
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _determinePosition();
              },
              child: Text('Locate me', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                  minimumSize:
                      Size((MediaQuery.of(context).size.width * 0.4), 50),
                  backgroundColor: Colors.purple[500]),
            ),
          ],
        ),
      ),
    );
  }
}
