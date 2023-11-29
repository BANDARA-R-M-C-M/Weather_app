import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'weatherapi.dart';

class Widgets extends StatelessWidget {
  final String city;

  Widgets({required this.city});     //Constructor for the city get the city name

  @override
  Widget build(BuildContext context) {    
    return FutureBuilder<Map<String, dynamic>>(
      future: WeatherApi().getWeather(city),                              //Get the weather data from the openweather API
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {        //If the connection is waiting
          return Container(                                               //Show a loading animation along with a "Loading...." text
            padding: EdgeInsets.fromLTRB(0, 120, 0, 0),
            height: MediaQuery.of(context).size.height,
              child:Column(
                children: [
                  Lottie.asset(
                  'assets/weather/loading.json',
                  width: 300,
                  height: 300,
                ),
                Center(
                  child: Text(
                    "Loading....",
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
        } else if (!snapshot.hasData) {                             //If there is no data
          return Container(                                         //Show a 404 error animation along with a "No Weather Data Available!!!" text
            padding: EdgeInsets.fromLTRB(0, 120, 0, 0),
            height: MediaQuery.of(context).size.height,
              child:Column(
                children: [
                  Lottie.asset(
                  'assets/weather/Error-404.json',
                  width: 300,
                  height: 300,
                ),
                Center(
                  child: Text(
                    "No Weather Data Available!!!",
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
        } else {
          var description = snapshot.data!['weather'][0]['description'];      //If there is data, get weather description from weather API
          var temperature = snapshot.data!['main']['temp'];                   //Temperature status
          var windspeed = snapshot.data!['wind']['speed'];                    //Windspeed status
          var humidity = snapshot.data!['main']['humidity'];                  //Humidity status
          var cityName = snapshot.data!['name'];                              //City name
          var clouds = snapshot.data!['clouds']['all'];                       //Clouds status
          var icon = snapshot.data!['weather'][0]['icon'];                    //Weather icon code

          return Column(                                                    //Return the weather data 
            children: [                                                     //and stylings
              Center(
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 40, 20, 0),
                    child: Column(                                       //Column for the weather data and weather description
                      children: [
                        Text(
                          cityName,                                      //Text for the city name
                            style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold
                            )
                          ),
                        Text(
                          description,                                  //Text for the weather description
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            )
                          )
                        ]
                    )
                  )
                ),
              Center(                                               //Center for the weather icon
                child: Container(
                  width: 300,
                  height: 300,
                  alignment: Alignment.center,
                  child: Lottie.asset(
                    'assets/weather/$icon.json',
                  ),
                ),
              ),
              Center(                                               //Center for the temperature
                child: Container(
                  margin: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      temperature.toString() + "°C",               //Text for the temperature
                        style: TextStyle(
                          fontSize: 55,
                          fontWeight: FontWeight.bold
                        ),
                      )
                    ]
                  )
                )
              ),
              Center(                                                       //Center for the additional weather data (windspeed, humidity, clouds)
                child: Container(
                  padding: EdgeInsets.all(15),
                  margin: EdgeInsets.fromLTRB(16, 16, 16, 50),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(89, 175, 236, 0.278),
                    borderRadius: BorderRadius.circular(30)
                  ),
                  child: Row(                                               //Row for the additional weather data (windspeed, humidity, clouds)
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(                                             //Column for the windspeed
                          children: [
                            Lottie.asset(
                              'assets/weather/windspeed.json',
                              width: 80,
                              height: 80,
                            ),
                            Text(
                              'Windspeed'
                            ),
                            Text(windspeed.toString() + " km/h",             //Text for the windspeed
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                        Column(                       //Column for the humidity
                          children: [
                              Transform.scale(        //Transform for the humidity Lottie animation (to make it bigger)
                                scale: 1.5,                               
                                child: Lottie.asset(
                                width: 80,
                                height: 80,
                                'assets/weather/humidity.json',
                              ),
                            ),
                            Text(
                              'Humidity'
                            ),
                            Text(humidity.toString() + "%",     //Text for the humidity
                              style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                        Column(                                 //Column for the clouds
                          children: [
                            Lottie.asset(
                              'assets/weather/cloudy.json',
                              width: 80,
                              height: 80
                            ),
                            Text(
                              'Clouds'
                            ),
                            Text(
                              clouds.toString() + "%",            //Text for the clouds
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                                )
                              )
                            ]
                          )
                        ]
                      )
                    )
                  )
               ]
              ); 
            }
          },
        );
      }
    }
