import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/CityApi.dart';
import 'Widgets.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromRGBO(44, 150, 226, 1),
          actions:[
            IconButton(
              icon: const Icon(
                  Icons.search,                                       //Search icon
                  size: 40,
                ),
              onPressed: () {                                                        
                showSearch(
                  context: context, 
                  delegate: mySearchDelegate(),                       //Call the search delegate
                  );
                }, 
              )
            ],
        elevation: 0,
      ),
      body: SingleChildScrollView(                                    //SingleChildScrollView for the home page
        child: Container(                                             //Container for the home page 
          width: MediaQuery.of(context).size.width,                   //and stylings
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(44, 150, 226, 1),
                    Color.fromRGBO(222, 222, 222, 1),
                  ],
                ),
              ),
        child: Column(                                                //Column for the home page contents
            mainAxisAlignment: MainAxisAlignment.center,  
          crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(                                                   //Text for the home page
                'How\'s',
                  style: TextStyle(
                  color: Colors.white,
                  fontSize: 50,
                ),
                  ),
              Text(
                'WEATHER!!!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              Lottie.asset(                                           //Lottie animation for the home page
                'assets/weather/home.json'
              ),
                Row(                                                  //Row for the "Search for Updates!" text
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(                                   //Lottie animation for the "Search for Updates!" text
                        'assets/weather/search.json',
                        height: 80,
                        width: 80,
                      ),
                      Text(
                        'Search for Updates!',                        //Text for the "Search for Updates!" text and stylings
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                  ),
              ],
          ),
        ),
      ),
    );
  }
}

class mySearchDelegate extends SearchDelegate{  //Search delegate class

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),       //Back button icon and functionality
      onPressed: (){                            //query is the text in the search bar
        if (query.isEmpty) {                    //If query is empty, pop the context
          Navigator.pop(context);   
        } else {                                //Else, clear the query and update suggestions
          query = '';
          showSuggestions(context);
        }
      }, 
      );
  }

  @override
  List<Widget> buildActions(BuildContext context) { //Actions for the search bar
    return [
      IconButton(
        icon: const Icon(Icons.clear),              //Clear button icon and functionality
        onPressed: (){
          query = '';                               //Clear the query
          showSuggestions(context);                 //Update suggestions
        }, 
        )
    ];
  }

  @override
  Widget buildResults(BuildContext context) => SingleChildScrollView(     //SingleChildScrollView for the search results
        child: Container(                                                 //Container for the search results
          width: MediaQuery.of(context).size.width,                       //and stylings
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
        decoration: BoxDecoration(                                        //Decoration for the search results home page
          gradient: LinearGradient(                                       //Linear gradient for the search results home page
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(62, 158, 227, 1),
              Color.fromRGBO(222, 222, 222, 1),
            ],
          ),
        ),
        child: Column(                                        //Column for the search results home page contents
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
                Widgets(city: query),                         //Widgets class for the search results home page
          ],
        ),
      ),
    );

  CityApi cityApi = CityApi();         //CityApi class for the search suggestions

  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: cityApi.getCities(query),                                       //Future for the search suggestions (call the getCities function)
      builder: (context, snapshot) {                                          //FutureBuilder for the search suggestions (snapshot is the data)
        if (snapshot.connectionState == ConnectionState.waiting) {            //If connection state is waiting, show a progress indicator
          return Center(                                                      //Center the progress indicator
            child: CircularProgressIndicator(                                 //CircularProgressIndicator for the progress indicator
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),       //and stylings
              strokeWidth: 4, // Width of the circular line
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              )
            );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {             //If no data is found, show a "No city suggestions found!!!" text
          return Center(
            child: Text(
              "No city suggestions found!!!"
              )
            );
        } else {                                              //Else, show the suggestions
          List<String> suggestions = snapshot.data!;          //suggestions is the cities data got from weather API as a List      
          return ListView.builder(                            //ListView.builder for the suggestions (build suggestions list)
            itemCount: suggestions.length,                    //itemCount is the length of the suggestions list
            itemBuilder: (context, index) => ListTile(        //ListTile for the suggestions (build suggestions list)
              title: Text(
                suggestions[index],                           //suggestions[index] is the suggestion at the index of the suggestions list
              ),
              onTap: () {
                query = suggestions[index];                   //query is the suggestion at the index of the suggestions list
                showResults(context);                         //Show the search results in the home page
              },
            ),
          );
        }
      },
    );
  }
}