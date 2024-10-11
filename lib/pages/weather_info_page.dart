import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:willyweather/features/weather/bloc/weather_bloc.dart';
import 'package:willyweather/features/weather/bloc/weather_event.dart';
import 'package:willyweather/features/weather/bloc/weather_state.dart';
import 'package:willyweather/models/weather_info_model.dart';
import 'package:willyweather/pages/weather_search_page.dart';
import 'package:willyweather/services/weather_info_service.dart';

class WeatherInfoPage extends StatefulWidget {
  const WeatherInfoPage({Key? key}) : super(key: key);

  @override
  State<WeatherInfoPage> createState() => _WeatherInfoPageState();
}

class _WeatherInfoPageState extends State<WeatherInfoPage> {
  final WeatherBloc loadWeatherBloc =
      WeatherBloc(WeatherInfoService("e539700379953cad19f56981ef0bf4a6"));

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

  @override
  void initState() {
    loadWeatherBloc.add(WeatherInitialFetchEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showSearchPage(context);
          },
          child: Icon(Icons.search),
        ),
        body: BlocConsumer<WeatherBloc, WeatherState>(
          bloc: loadWeatherBloc,
          listener: (context, state) {},
          builder: (context, state) {
            switch (state.runtimeType) {
              case WeatherFetchLoadingState:
                return AnimatedSwitcher(
                    duration: Duration(milliseconds: 200),
                    child: Center(child: Lottie.asset("assets/loading.json")));
              case WeatherFetchSuccessState:
                final successState = state as WeatherFetchSuccessState;
                return AnimatedSwitcher(
                  duration: Duration(milliseconds: 200),
                  child: Center(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(successState.weatherInfo.cityName),
                          Container(
                              constraints:
                                  BoxConstraints(maxWidth: 150, maxHeight: 150),
                              child: Lottie.asset(getWeatherAnimation(
                                  successState.weatherInfo.mainCondition))),
                          Text(
                              '${successState.weatherInfo.temperature.round()}°C')
                        ],
                      ),
                    ),
                  ),
                );
              case WeatherFetchErrorState:
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
        ));
  }

  Future<void> _showSearchPage(BuildContext context) async {
    final result = await Navigator.push(
      context,
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => WeatherSearchPage(),
      ),
    );

    if (result is WeatherInfo) {
      loadWeatherBloc.add(WeatherChangeEvent(result));
    }
  }
}
