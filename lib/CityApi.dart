import 'dart:convert';
import 'package:http/http.dart' as http;

class CityApi {
  static const String apiKey = '55d342fb522c4fe897a203914230911';
  static const String baseUrl = 'http://api.weatherapi.com/v1/search.json';

  Future<List<String>> getCities(String search) async {
  final response = await http.get(Uri.parse('$baseUrl?&key=$apiKey&q=$search'));    //Get the city data from the weatherapi API

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);     //Return the city data
      final cities = data                                      //Insert city data into a List
          .map((city) => city['name'].toString())
          .toList();
      return cities;                                           //Return the city data
  } else {
    throw Exception('Failed to load weather data');
  }
}

}

