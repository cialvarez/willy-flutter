import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:willyweather/features/search/bloc/search_bloc.dart';
import 'package:willyweather/features/search/bloc/search_event.dart';
import 'package:willyweather/features/search/bloc/search_state.dart';
import 'package:willyweather/models/weather_info_model.dart';
import 'package:willyweather/services/weather_info_service.dart';

class WeatherSearchPage extends StatefulWidget {
  const WeatherSearchPage({super.key});

  @override
  State<WeatherSearchPage> createState() => _WeatherSearchPageState();
}

class _WeatherSearchPageState extends State<WeatherSearchPage> {
  final WeatherSearchBloc loadWeatherBloc =
      WeatherSearchBloc(WeatherInfoService("e539700379953cad19f56981ef0bf4a6"));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Weather")),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(children: [
            TextField(
              keyboardType: TextInputType.streetAddress,
              autocorrect: false,
              decoration: InputDecoration(hintText: 'Type in a city name'),
              onChanged: (value) {
                loadWeatherBloc.add(WeatherSearchTypingEvent(cityName: value));
              },
            ),
            BlocConsumer<WeatherSearchBloc, WeatherSearchState>(
              bloc: loadWeatherBloc,
              // listenWhen: (previous, current) => current is WeatherActionState,
              // buildWhen: (previous, current) => current is! WeatherActionState,
              listener: (context, state) {},
              builder: (context, state) {
                switch (state.runtimeType) {
                  case WeatherSearchInProgressState:
                    return AnimatedSwitcher(
                        duration: Duration(milliseconds: 200),
                        child:
                            Center(child: Lottie.asset("assets/loading.json")));
                  case WeatherSearchSuccessState:
                    final successState = state as WeatherSearchSuccessState;
                    return AnimatedSwitcher(
                      duration: Duration(milliseconds: 200),
                      child: Center(
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(successState.weatherInfo.cityName),
                              Container(
                                  constraints: BoxConstraints(
                                      maxWidth: 150, maxHeight: 150),
                                  child: Lottie.asset(getWeatherAnimation(
                                      successState.weatherInfo.mainCondition))),
                              Text(
                                  '${successState.weatherInfo.temperature.round()}°C'),
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(
                                        context, successState.weatherInfo);
                                  },
                                  child: Text('Select'))
                            ],
                          ),
                        ),
                      ),
                    );
                  case WeatherSearchErrorState:
                    return AnimatedSwitcher(
                        duration: Duration(milliseconds: 200),
                        child: Center(
                            child: Column(
                          children: [
                            Lottie.asset("assets/failure.json"),
                            Text(
                                "Failed to load weather data!\nPlease try again later.")
                          ],
                        )));
                  default:
                    return const SizedBox();
                }
              },
            ),
          ])),
    );
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';
    switch (mainCondition) {
      case 'Thunderstorm':
      case 'Drizzle':
      case 'Rain':
        return 'assets/rainy.json';
      case 'Snow':
        return 'assets/snowy.json';
      case 'Atmosphere':
        return 'assets/misty.json';
      case 'Clear':
        return 'assets/sunny.json';
      case 'Clouds':
        return 'assets/cloudy.json';
      default:
        return 'assets/sunny.json';
    }
  }
}
