class GetStrings {
  String getGreeting() {
    DateTime str = DateTime.now();
    String timevar = "${str.hour}";
    int timevarint = int.parse(timevar);

    if (timevarint < 12) {
      return ("Good Morning !");
    } else {
      return ("Good Evening !");
    }
  }

  String getWeatherIcon(int code) {
    switch (code) {
      case >= 200 && < 300:
        return "assets/thunderstorm.png";
      case >= 300 && < 400:
        return 'assets/drizzle.png';
      case >= 500 && < 600:
        return "assets/raining.png";
      case >= 600 && < 700:
        return "assets/snow.png";
      case >= 700 && < 800:
        return "assets/haze.png";
      case == 800:
        return "assets/sunny.png";
      case > 800 && < 900:
        return "assets/cloudy_icon.png";
      default:
        return "assets/sunny.png";
    }
  }

  String getTipString(int code) {
    switch (code) {
      case >= 200 && < 300:
        return "Try to stay indoors !";
      case >= 300 && < 400:
        return 'Enjoy the droplets :)';
      case >= 500 && < 600:
        return "Don't forget to take an umbrella :)";
      case >= 600 && < 700:
        return "Don't forget to play snowfight :)";
      case >= 700 && < 800:
        return "Don't forget your mask :)";
      case == 800:
        return "Smile, today is a clear day :)";
      case > 800 && < 900:
        return "Enjoy the clouds :)";
      default:
        return "Have a good day :)";
    }
  }
}
