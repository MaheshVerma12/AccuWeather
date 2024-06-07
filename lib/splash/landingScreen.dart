import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worksmart/homePage.dart';
import 'package:worksmart/weather_bloc/weather_bloc_bloc.dart';
import 'package:worksmart/weather_bloc/weather_bloc_event.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  static final textController = new TextEditingController();
  static String cityName1 = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[300],
      appBar: AppBar(
        backgroundColor: Colors.indigo[400],
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(115),
                child: Image.asset("assets/Earth1.jpeg")),
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
                decoration: InputDecoration(
                  hintText: "eg. Kathmandu",
                  labelText: "City Name",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_pin),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                BlocProvider.of<WeatherBlocBloc>(context)
                    .add(FetchWeather(cityName: cityName1));
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage(
                            cityName: cityName1,
                          )),
                );
              },
              child: Text("Get weather information",
                  style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                  minimumSize:
                      Size((MediaQuery.of(context).size.width * 0.95), 50),
                  backgroundColor: Colors.purple[600]),
            ),
          ],
        ),
      ),
    );
  }
}
