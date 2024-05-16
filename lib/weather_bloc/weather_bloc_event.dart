import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

abstract class WeatherBlocEvent extends Equatable {
  const WeatherBlocEvent();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class FetchWeather extends WeatherBlocEvent {
  final Position position;
  const FetchWeather(this.position);
  @override
  List<Object> get props => [position];
}
