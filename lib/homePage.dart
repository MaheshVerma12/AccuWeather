import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:worksmart/splash/cached_data.dart';
import 'package:worksmart/weather_bloc/weather_bloc_bloc.dart';
import 'package:worksmart/weather_bloc/weather_bloc_state.dart';
import 'package:worksmart/getStrings.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final cityName;
  HomePage({super.key, required this.cityName});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late Animation animation1;
  late AnimationController animationController;
  SharedPreferences? prefs;
  late Future<void> _futureData;
  var result;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _futureData = createVar();
    animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2500));
    animation1 = Tween(begin: 0.0, end: 250.0).animate(animationController);
    animationController.addListener(() {
      setState(() {});
    });
    animationController.forward();
  }

  Future<void> createVar() async {
    result = await InternetConnection().hasInternetAccess;
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.purple[600],
        title: Text(
          "Local Weather Info",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
        ),
        centerTitle: true,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
        ),
      ),
      body: FutureBuilder<void>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.none) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.done ||
              result == false) {
            return SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.fromLTRB(40, 1.2 * kToolbarHeight, 40, 20),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Stack(
                    children: [
                      Align(
                        alignment: AlignmentDirectional(3, -0.3),
                        child: Container(
                          height: 300,
                          width: 300,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(-3, -0.3),
                        child: Container(
                          height: 300,
                          width: 300,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF673AB7),
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0, -1.2),
                        child: Container(
                          height: 300,
                          width: 600,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFFFAB40),
                          ),
                        ),
                      ),
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                        child: Container(
                          decoration:
                              const BoxDecoration(color: Colors.transparent),
                        ),
                      ),
                      BlocBuilder<WeatherBlocBloc, WeatherBlocState>(
                        builder: (context, state) {
                          if (state is WeatherBlocSuccess) {
                            var strObj = new GetStrings();
                            print(result);
                            if (result == true) {
                              CachedData obj1 = new CachedData(
                                  key: widget.cityName,
                                  weatherCode:
                                      state.weather.weatherConditionCode!,
                                  tempFeels: state
                                      .weather.tempFeelsLike!.celsius!
                                      .round(),
                                  weatherMain:
                                      state.weather.weatherMain!.toUpperCase(),
                                  date: DateFormat('EEEE dd')
                                      .add_jm()
                                      .format(state.weather.date!),
                                  sunrise: DateFormat()
                                      .add_jm()
                                      .format(state.weather.sunrise!),
                                  sunset: DateFormat()
                                      .add_jm()
                                      .format(state.weather.sunset!),
                                  tempMax: state.weather.tempMax!.celsius!
                                      .roundToDouble(),
                                  tempMin: state.weather.tempMin!.celsius!
                                      .roundToDouble());
                              obj1.storeCache();
                            }

                            return SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 25),
                                  Text(
                                    strObj.getGreeting(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Container(
                                        height: animation1.value,
                                        width: animation1.value,
                                        child: Image.asset(
                                            strObj.getWeatherIcon(result
                                                ? state.weather
                                                    .weatherConditionCode!
                                                : prefs!.getInt(
                                                    '${widget.cityName}_weathercode')!)),
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      result
                                          ? '${state.weather.tempFeelsLike!.celsius!.round()}°C'
                                          : "${prefs!.getInt('${widget.cityName}_tempfeels')}°C",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 55,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      (result)
                                          ? '${state.weather.areaName}'
                                          : '${widget.cityName}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      result
                                          ? state.weather.weatherMain!
                                              .toUpperCase()
                                          : '${prefs!.getString('${widget.cityName}_weathermain')}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Center(
                                    child: Text(
                                      (result)
                                          ? DateFormat('EEEE dd')
                                              .add_jm()
                                              .format(state.weather.date!)
                                          : '${prefs!.getString('${widget.cityName}_date')}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Image.asset('assets/sunny.png',
                                              scale: 8),
                                          const SizedBox(width: 5),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Sunrise",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                              SizedBox(height: 3),
                                              Text(
                                                (result)
                                                    ? DateFormat()
                                                        .add_jm()
                                                        .format(state
                                                            .weather.sunrise!)
                                                    : '${prefs!.getString('${widget.cityName}_sunrise')}',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Image.asset('assets/sunset.png',
                                              scale: 8),
                                          const SizedBox(width: 5),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Sunset',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                              SizedBox(height: 3),
                                              Text(
                                                (result)
                                                    ? DateFormat()
                                                        .add_jm()
                                                        .format(state
                                                            .weather.sunset!)
                                                    : '${prefs!.getString('${widget.cityName}_sunset')}',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    child: Divider(
                                      color: Colors.indigo,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Image.asset('assets/temperature.jfif',
                                              scale: 8),
                                          const SizedBox(width: 5),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Temp Max',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                              SizedBox(height: 3),
                                              Text(
                                                result
                                                    ? ((state.weather.tempMax!
                                                                .celsius!
                                                                .roundToDouble()) +
                                                            2)
                                                        .toString()
                                                    : '${prefs!.getDouble('${widget.cityName}_tempmax')! + 2}',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Image.asset('assets/temperature.jfif',
                                              scale: 8),
                                          const SizedBox(width: 5),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Temp min',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                              SizedBox(height: 3),
                                              Text(
                                                result
                                                    ? ((state.weather.tempMin!
                                                                .celsius!
                                                                .roundToDouble()) -
                                                            2)
                                                        .toString()
                                                    : '${prefs!.getDouble('${widget.cityName}_tempmin')! - 2}',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    child: Divider(
                                      color: Colors.indigo,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: Text(
                                            'Tip of the day ',
                                            style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.w900,
                                                fontStyle: FontStyle.italic,
                                                color: Colors.purple[700],
                                                letterSpacing: 2.5,
                                                decoration:
                                                    TextDecoration.underline,
                                                decorationStyle:
                                                    TextDecorationStyle.dashed),
                                          ),
                                        ),
                                        Center(
                                          child: FittedBox(
                                            fit: BoxFit.fill,
                                            child: Text(
                                              strObj.getTipString(state.weather
                                                  .weatherConditionCode!),
                                              style: TextStyle(
                                                fontSize: 27,
                                                fontWeight: FontWeight.w500,
                                                fontStyle: FontStyle.italic,
                                                color: Colors.blue[200],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
