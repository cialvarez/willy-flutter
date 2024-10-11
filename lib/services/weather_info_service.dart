import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:willyweather/models/weather_info_model.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class WeatherInfoService {
  static const baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherInfoService(this.apiKey);

  Future<WeatherInfo> getWeatherInfo(String cityName) async {
    final response = await http.get(Uri.parse(
        '$baseUrl?q=$cityName&appId=$apiKey&units=metric')); // todo: allow unit change
    if (response.statusCode == 200) {
      return WeatherInfo.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data!');
    }
  }

  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    String? city = placemarks[0].locality;
    return city ?? "";
  }
}
