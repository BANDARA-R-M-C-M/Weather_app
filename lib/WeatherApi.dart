import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherApi {
  static const String apiKey = '98537a50725420b092d6d20e8920ccdb';
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5/weather?units=metric';

  Future<Map<String, dynamic>> getWeather(String city) async {
    final response = await http.get(Uri.parse('$baseUrl&q=$city&appid=$apiKey'));  //Get the weather data from the openweather API

    if (response.statusCode == 200) {
      return json.decode(response.body);        //Return the weather data
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
