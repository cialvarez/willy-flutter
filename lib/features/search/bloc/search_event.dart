import 'package:flutter/material.dart';

@immutable
abstract class WeatherSearchEvent {}

class WeatherSearchTypingEvent extends WeatherSearchEvent {
  final String cityName;
  WeatherSearchTypingEvent({required this.cityName});
}
