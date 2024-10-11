import 'package:flutter/material.dart';
import 'package:willyweather/models/weather_info_model.dart';

@immutable
abstract class WeatherSearchState {}

class WeatherSearchInitialState extends WeatherSearchState {}

class WeatherSearchInProgressState extends WeatherSearchState {}

class WeatherSearchSuccessState extends WeatherSearchState {
  final WeatherInfo weatherInfo;

  WeatherSearchSuccessState(this.weatherInfo);
}

class WeatherSearchErrorState extends WeatherSearchState {}
