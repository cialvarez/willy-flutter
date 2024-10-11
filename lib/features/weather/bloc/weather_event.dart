import 'package:flutter/material.dart';
import 'package:willyweather/models/weather_info_model.dart';

@immutable
abstract class WeatherEvent {}

class WeatherInitialFetchEvent extends WeatherEvent {}

class WeatherChangeEvent extends WeatherEvent {
  final WeatherInfo weatherInfo;

  WeatherChangeEvent(this.weatherInfo);
}
