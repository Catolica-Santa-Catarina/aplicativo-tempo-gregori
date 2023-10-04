import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tempo_template/models/location.dart';
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

    var cityName = networkData["name"];
    var temperature = networkData["main"]["temp"];
    var condition = networkData["weather"][0]["id"];

    log('cityName: $cityName, temperature: $temperature, condition: $condition');
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // obtém a localização atual
            getLocation();
          },
          child: const Text('Obter Localização'),
        ),
      ),
    );
  }
}
