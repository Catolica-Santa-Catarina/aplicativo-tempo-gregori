import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tempo_template/models/location.dart';
import 'package:tempo_template/services/location_service.dart';

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

    var apiKey = '220ba8ca770b4c863e46eb9925da78a6';
    var url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=${location.latitude}&lon=${location.longitude}&units=metric&appid=$apiKey');
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      // se a requisição foi feita com sucesso
      var data = response.body;
      log(data); // imprima o resultado
    } else {
      log(response.statusCode.toString()); // senão, imprima o código de erro
    }
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
