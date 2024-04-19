import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'alunav',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 8, 36, 84),
        ),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: MyHomePage(
          title: 'Guide',
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController searchController;
  late Map<String, Map<String, List<String>>> filteredBuildings;
  late bool isSearching;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    filteredBuildings = {};
    isSearching = false;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  _showSearchbar() {
    setState(() {
      isSearching = true;
    });

    showBottomSheet(
      showDragHandle: true,
      backgroundColor: Colors.red,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 100,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: TextField(
                  controller: searchController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Search',
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                  ),
                  onChanged: (query) {
                    setState(() {
                      filteredBuildings.clear();
                      buildings.forEach((building, floors) {
                        Map<String, List<String>> filteredFloors = {};
                        floors.forEach((floor, countries) {
                          List<String> filteredCountries = countries
                              .where((country) => country
                                  .toLowerCase()
                                  .contains(query.toLowerCase()))
                              .toList();
                          if (filteredCountries.isNotEmpty) {
                            filteredFloors[floor] = filteredCountries;
                          }
                        });
                        if (filteredFloors.isNotEmpty) {
                          filteredBuildings[building] = filteredFloors;
                        }
                      });
                    });
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      isSearching = false;
                      searchController.clear();
                      filteredBuildings.clear();
                    });
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 8, 36, 84),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Row(
          children: [
            Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text('ME', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),)
          ],
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height ,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Visibility(
                  visible: !isSearching,
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height ,
                      child:  Center(
                          child:  Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: MediaQuery.of(context).size.height/4 ,
                                ),
                                Image.asset("assets/logo/alu_logo.png"),
                                const Text(
                                  "Lost? start searching",
                                  style: TextStyle(
                                    color:  Colors.blueAccent,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 16,

                                  ),
                                ),
                              ],
                            )
                          ))),
                ),

                // Search results
                Visibility(
                  visible: isSearching,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Search Results',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        SizedBox(height: 16),
                        SizedBox(
                          height: MediaQuery.of(context).size.height /
                              1.35, // Adjust height as needed
                          child: ListView.builder(
                            itemCount: filteredBuildings.length,
                            itemBuilder: (BuildContext context, int index) {
                              String buildingName =
                                  filteredBuildings.keys.elementAt(index);
                              String floor =
                                  filteredBuildings[buildingName]!.keys.first;
                              String country = filteredBuildings[buildingName]!
                                  .values
                                  .first
                                  .first;

                              // Get the image path for the building
                              String imagePath =
                                  buildingImages[buildingName] ?? '';

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Container(
                                      height: 250,
                                      width: 400,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.lightBlue,
                                        image: DecorationImage(
                                          image: AssetImage(imagePath),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Building: $buildingName', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                        Text('Floor: $floor', style: TextStyle(color: Colors.white),),
                                        Text('Class: $country', style: TextStyle(color: Colors.white),),
                                      ],
                                    ),
                                  ),

                                  SizedBox(height: 16),
                                  // Placeholder for directions
                                  Divider(color: Colors.white24,),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: _showSearchbar, // Ensure this calls _showSearchbar
        tooltip: 'Look up a place',
        label: Text('search'),
        icon: const Icon(Icons.search),
      ),
    );
  }
}

// Dictionary for buildings, floors, and classes
Map<String, Map<String, List<String>>> buildings = {
  'Entrepreneurship Commons': {
    'Ground Floor': ['Nigeria', 'South Africa', 'Ghana'],
    '1st Floor': ['Angola', 'Zimbabwe', 'Uganda'],
    '2nd Floor': ['Kenya-Burundi', 'Ethiopia', 'Tanzania'],
  },
  'Learning Commons': {
    'Ground Floor': ['Gambia', 'Botswana', 'Senegal'],
    '1st Floor': ['Ivory Coast', 'Zambia', 'Namibia'],
    '2nd Floor': ['Mozambique', 'Cameroon', 'Mauritius'],
  },
  'Social Commons': {
    'Ground Floor': ['Egypt', 'Algeria', 'Morocco'],
    '1st Floor': ['Tunisia', 'Libya', 'Sierra Leone'],
    '2nd Floor': ['Sudan', 'Somalia', 'Liberia'],
  },
};

// Dictionary for building images
Map<String, String> buildingImages = {
  'Learning Commons': 'assets/learning_commons.png',
  'Entrepreneurship Commons': 'assets/entrepreneurship_commons.png',
  'Social Commons': 'assets/social_commons.png',
};
