import 'dart:convert';
import 'package:flutter/material.dart';

class ObjectInfoScreen extends StatelessWidget {
  final String detectedObject;

  ObjectInfoScreen({required this.detectedObject});

  Future<Map<String, dynamic>> loadObjectData(BuildContext context) async {
    String data = await DefaultAssetBundle.of(context).loadString('assets/objects.json');
    return json.decode(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Object Information'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: loadObjectData(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading data'));
          } else {
            var objects = snapshot.data!['objects'];
            var detectedObjectInfo = objects.firstWhere(
                  (obj) => obj['name'] == detectedObject,
              orElse: () => null,
            );

            if (detectedObjectInfo != null) {
              String material = detectedObjectInfo['properties']['Material'] ?? 'N/A';
              String capacity = detectedObjectInfo['properties']['Capacity'] ?? 'N/A';
              String safety = detectedObjectInfo['properties']['Safety'] ?? 'N/A';
              List<dynamic> commonUses = detectedObjectInfo['properties']['Common Uses'] ?? [];
              List<dynamic> features = detectedObjectInfo['properties']['Features'] ?? [];
              List<dynamic> doList = detectedObjectInfo['properties']['Do'] ?? [];
              List<dynamic> avoidList = detectedObjectInfo['properties']['Avoid']??[];
              List<dynamic> cleaningList = detectedObjectInfo['properties']['Cleaning']??[];
              List<dynamic> similarObjects = detectedObjectInfo['properties']['SimilarObjects'] ?? [];


              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      detectedObjectInfo['image'],
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fitWidth,
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            detectedObjectInfo['name'],
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            '${detectedObjectInfo['description']}',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            height: 200,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                buildCard(material, 'assets/logo/logo1.png', Color(0xFFC1121F)), // Change HEX color code here
                                SizedBox(width: 10),
                                buildCard(capacity, 'assets/logo/logo2.png', Color(0xFF023E8A)), // Change HEX color code here
                                SizedBox(width: 10),
                                buildCard(safety, 'assets/logo/logo3.png', Color(0xFF06D6A0)), // Change HEX color code here
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            decoration: BoxDecoration(
                              border: Border(left: BorderSide(width: 10.0, color: Color(0xFF012A4A))),
                            ),
                            padding: EdgeInsets.only(left: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Common Uses:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8),
                                // Displaying the common uses
                                for (var use in commonUses)
                                  Text(
                                    '- $use',
                                    style: TextStyle(fontSize: 16),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Card(
                            color: Color(0xFFABC4FF), // Background color for the card
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0), // Replace with your desired border radius
                              side: BorderSide(
                                color: Color(0xFFABC4FF), // You can add a border color if needed
                                width: 2.0, // You can adjust the border width as needed
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Features',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                  ),
                                  SizedBox(height: 8),
                                  // Displaying the features
                                  for (var feature in features)
                                    Text(
                                      '- $feature',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: 500, // Set your desired width here
                            child: Card(
                              color: Colors.white, // Background color for the card
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0), // Replace with your desired border radius
                                side: BorderSide(
                                  color: Color(0xFF06D6A0), // You can add a border color if needed
                                  width: 2.0, // You can adjust the border width as needed
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Stack(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Good practice',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Color(0xFF06D6A0),
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        // Displaying the features
                                        for (var item in doList)
                                          Text(
                                            '- $item',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                      ],
                                    ),
                                    Positioned(
                                      right: 0, // Change these values to position the image
                                      top: 0,
                                      child: SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: Image.asset(
                                          'assets/logo/logo4.png', // Replace with your image path
                                          fit: BoxFit.cover, // Adjust the fit as needed
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: 500, // Set your desired width here
                            child: Card(
                              color: Color(0xFFC1121F), // Background color for the card
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0), // Replace with your desired border radius
                                side: BorderSide(
                                  color: Color(0xFFC1121F), // You can add a border color if needed
                                  width: 2.0, // You can adjust the border width as needed
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Stack(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Avoid',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        // Displaying the features
                                        for (var item in avoidList)
                                          Text(
                                            '- $item',
                                            style: TextStyle(fontSize: 16, color: Colors.white),
                                          ),
                                      ],
                                    ),
                                    Positioned(
                                      right: 0, // Change these values to position the image
                                      top: 0,
                                      child: SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: Image.asset(
                                          'assets/logo/logo5.png', // Replace with your image path
                                          fit: BoxFit.cover, // Adjust the fit as needed
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: 500, // Set your desired width here
                            child: Card(
                              color: Colors.white, // Background color for the card
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0), // Replace with your desired border radius
                                side: BorderSide(
                                  color: Color(0xFFABC4FF), // You can add a border color if needed
                                  width: 2.0, // You can adjust the border width as needed
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Stack(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Cleaning procedure',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Color(0xFFABC4FF),
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        // Displaying the features
                                        for (var item in cleaningList)
                                          Text(
                                            '- $item',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                      ],
                                    ),
                                    Positioned(
                                      right: 0, // Change these values to position the image
                                      top: 0,
                                      child: SizedBox(
                                        width: 35,
                                        height: 35,
                                        child: Image.asset(
                                          'assets/logo/logo6.png', // Replace with your image path
                                          fit: BoxFit.cover, // Adjust the fit as needed
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                child: Text(
                                  'Similar Apparatus',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold, color: Color(0xFF012A4A)
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 200,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: similarObjects.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    var similarObject = similarObjects[index];
                                    return Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                                      child: loadCard(
                                        similarObject['name'],
                                        similarObject['image'],
                                        Color(0xFFffd8be), // Replace with your desired hex color code
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: 20), // Bottom padding
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                child: Text(
                                  'Tips',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Center( // Wrapping PageView with Center widget
                                child: SizedBox(
                                  height: 200, width: 500,
                                  child: PageView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                                        child: customCard(
                                          'Attire',
                                          'assets/logo/lab-coat.png',
                                          Colors.blue,
                                          'Always wear laboratory coats, safety goggles, closed-toe shoes, and other necessary personal protective equipment (PPE) as per lab regulations',
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                                        child: customCard(
                                          'Hygiene',
                                          'assets/logo/washing-hands.png',
                                          Color(0xFFffbc42),
                                          'Wash hands thoroughly before and after handling any materials or apparatus to prevent contamination.',
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                                        child: customCard(
                                          'Inspection',
                                          'assets/logo/investigation.png',
                                          Color(0xFFD81159),
                                          'Check laboratory apparatus for damage or defects before use and report any issues to supervisors.',
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                                        child: customCard(
                                          'Labeling',
                                          'assets/logo/product-development.png',
                                          Color(0xFF20bf55),
                                          'Properly label all containers, apparatus, and chemicals with their names, concentrations, and hazard warnings. Maintain detailed records of experiments and procedures.',
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                                        child: customCard(
                                          'Handling Chemicals',
                                          'assets/logo/laboratory.png',
                                          Color(0xFF8D58C6),
                                          'Handle chemicals with caution, following proper storage, usage, and disposal protocols. Read and understand the Safety Data Sheets (SDS) for each chemical.',
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                                        child: customCard(
                                          'Food products',
                                          'assets/logo/no-food.png',
                                          Color(0xFFCC2936),
                                          'Refrain from consuming food or beverages in laboratory areas to prevent accidental ingestion of chemicals.',
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                                        child: customCard(
                                          'Fume hoods',
                                          'assets/logo/fume-hood.png',
                                          Color(0xFF429EB3),
                                          'Utilize fume hoods for experiments involving volatile or harmful substances to control exposure to fumes and vapors.',
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                                        child: customCard(
                                          'Spillage',
                                          'assets/logo/chemical.png',
                                          Color(0xFFC884A6),
                                          'Clean up any spills promptly using appropriate absorbent materials and following specific cleanup procedures for different types of spills.',
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                                        child: customCard(
                                          'Waste',
                                          'assets/logo/trash.png',
                                          Color(0xFF4574C4),
                                          'Segregate and dispose of laboratory waste, including chemicals, glassware, and biological materials, according to established guidelines.',
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                                        child: customCard(
                                          'Rinse',
                                          'assets/logo/wash-bottle.png',
                                          Color(0xFFd56062),
                                          'Rinse laboratory apparatus, glassware, and equipment before and after use to remove any contaminants or residues.',
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                                        child: customCard(
                                          'Emergency Procedures',
                                          'assets/logo/first-aid-kit.png',
                                          Color(0xFFff5400),
                                          'Familiarize yourself with the location of safety equipment (eyewash stations, fire extinguishers) and emergency exits. Know the laboratorys emergency procedures.',
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                                        child: customCard(
                                          'Reporting Accidents',
                                          'assets/logo/danger.png',
                                          Color(0xFFE574BC),
                                          'Immediately report any accidents, spills, injuries, or hazardous situations to supervisors or designated personnel.',
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                                        child: customCard(
                                          'Cleanliness',
                                          'assets/logo/broom.png',
                                          Color(0xFF7A2900),
                                          'Keep the laboratory workspace clean, organized, and clutter-free to prevent accidents and promote efficiency.',
                                        ),
                                      ),
                                      // Add more cards as needed
                                      // ...
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(child: Text('Information not found'));
            }
          }
        },
      ),
    );
  }

  Widget buildCard(String propertyValue, String imagePath, Color borderColor) {
    return SizedBox(
      width: 150,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: borderColor, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Text(
                propertyValue,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget loadCard(String propertyValue, String imagePath, Color borderColor) {
    return SizedBox(
      width: 150,
      height: 250,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: borderColor, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: FadeInImage(
                  placeholder: AssetImage('assets/logo/logo1.png'), // Placeholder image path
                  image: NetworkImage(imagePath), // Load image from URL
                  fit: BoxFit.cover,
                  width: 100,
                  height: 100,
                ),
              ),
              SizedBox(height: 8),
              Text(
                propertyValue,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget customCard(String title, String imagePath, Color bgColor, String extraText) {
    return Card(
      color: bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
              height: 50,
              width: 50,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 6.0, right: 6.0),
            child: Text(
              extraText,
              style: TextStyle(
                color: Color(0xFFedf2f4),
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Opacity(
                opacity: 0.5,
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
