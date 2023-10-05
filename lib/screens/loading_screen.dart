import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tempo_template/models/location.dart';
import 'package:tempo_template/models/weather_data.dart';
import 'package:tempo_template/screens/location_screen.dart';
import 'package:tempo_template/services/location_service.dart';

import '../services/networking.dart';
import '../utilities/constants.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  Future<Location> getLocation() async {
    LocationService locationService = LocationService();
    var location = await locationService.getCurrentLocation();

    return location;
  }

  Future<void> getData() async {
    var location = await getLocation();

    var url = 'https://api.openweathermap.org/data/2.5/weather?'
        'lat=${location.latitude}&lon=${location.longitude}&units=metric&appid=$apiKey';

    var networkHelper = NetworkHelper(url);
    var networkData = await networkHelper.getData();

    pushToLocationScreen(WeatherData.fromJson(networkData));
  }

  void pushToLocationScreen(WeatherData weatherData) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LocationScreen(
                  weatherData: weatherData,
                )));
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: SpinKitDoubleBounce(
        color: Colors.white,
        size: 100.0,
      )),
    );
  }
}
