import 'package:flutter/material.dart';
import 'package:willyweather/models/weather_info_model.dart';

@immutable
abstract class WeatherState {}

class WeatherInitialFetch extends WeatherState {}

class WeatherFetchLoadingState extends WeatherState {}

class WeatherFetchErrorState extends WeatherState {}

class WeatherFetchSuccessState extends WeatherState {
  final WeatherInfo weatherInfo;

  WeatherFetchSuccessState(this.weatherInfo);
}
