import 'package:shared_preferences/shared_preferences.dart';

class CachedData {
  String key;
  int weatherCode;
  int tempFeels;
  String weatherMain;
  String date;
  String sunrise;
  String sunset;
  double tempMax;
  double tempMin;
  CachedData(
      {required this.weatherCode,
      required this.tempFeels,
      required this.weatherMain,
      required this.date,
      required this.sunrise,
      required this.sunset,
      required this.tempMax,
      required this.tempMin,
      required this.key});
  void storeCache() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('${key}_weathercode', weatherCode);
    await prefs.setInt('${key}_tempfeels', tempFeels);
    await prefs.setString('${key}_weathermain', weatherMain);
    await prefs.setString('${key}_date', date);
    await prefs.setString('${key}_sunrise', sunrise);
    await prefs.setString('${key}_sunset', sunset);
    await prefs.setDouble('${key}_tempmax', tempMax);
    await prefs.setDouble('${key}_tempmin', tempMin);
  }
}
