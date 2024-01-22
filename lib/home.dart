import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'ObjectInfoScreen.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loading = true;
  late File _image;
  late List _output = []; // Initialize _output to an empty list
  final picker = ImagePicker(); //allows us to pick image from gallery or camera
  bool _showCameraIcon = false;
  bool _showGalleryIcon = false;
  double _searchIconSize = 60.0; // Initial size for the search icon


  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    Tflite.close();
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 5,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _output = output!;
      _loading = false;
    });

    // Show detection result in a pop-up window
    if (_output != null && _output.isNotEmpty) {
      String detectedLabel = _output[0]['label']; // Get the detected label

      if (detectedLabel != null && detectedLabel.isNotEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Detection Result'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    Image.file(_image),
                    SizedBox(height: 10),
                    Text(
                      'The object is: $detectedLabel',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the dialog
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ObjectInfoScreen(detectedObject: detectedLabel),
                          ),
                        );
                      },
                      child: Text('View Details'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    }
  }

  loadModel() async {
    await Tflite.loadModel(
      model: 'assets/model_unquant.tflite',
      labels: 'assets/labels.txt',
    );
  }

  pickImage(ImageSource source) async {
    var image = await picker.pickImage(source: source);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });
    classifyImage(_image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        centerTitle: true,
        title: Text(
          'Catalyst',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 23,
          ),
        ),
      ),
      body: Stack(
        children: [
          _output != null && _output.isNotEmpty
              ? Container(
            color: Color.fromRGBO(255, 255, 255, 1.0),
            padding: EdgeInsets.symmetric(horizontal: 35, vertical: 50),
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Center(
                      child: _loading == true
                          ? null
                          : Container(
                        child: Column(
                          children: [
                            Container(
                              height: MediaQuery.of(context)
                                  .size
                                  .width *
                                  0.5,
                              width: MediaQuery.of(context)
                                  .size
                                  .width *
                                  0.5,
                              child: ClipRRect(
                                borderRadius:
                                BorderRadius.circular(25),
                                child: Image.file(
                                  _image,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Divider(
                              height: 25,
                              thickness: 1,
                            ),
                            _output != null && _output.isNotEmpty
                                ? Text(
                              'The object is: ${_output[0]['label']}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            )
                                : Container(),
                            Divider(
                              height: 25,
                              thickness: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
              : Center(
            child: Container(
              width: 300, // Set the width and height of the circular container
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent, // Set the color as transparent
              ),
              child: ClipOval(
                child: Opacity(
                  opacity: 0.5, // Set the opacity value here (0.0 for fully transparent, 1.0 for fully opaque)
                  child: Image.asset(
                    'assets/logo/chemistrylab2.png', // Replace with your image path
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 40.0,
            left: MediaQuery.of(context).size.width / 2 - (_searchIconSize / 2),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _showCameraIcon = !_showCameraIcon;
                  _showGalleryIcon = !_showGalleryIcon;
                  _searchIconSize =
                  _searchIconSize == 60.0 ? 30.0 : 60.0; // Toggle size between 60.0 and 30.0
                });
              },
              child: Icon(
                Icons.search,
                size: _searchIconSize,
                color: Colors.indigo,
              ),
            ),
          ),
          Positioned(
            bottom: 40.0,
            left: MediaQuery.of(context).size.width / 2 - 120,
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 100),
              opacity: _showCameraIcon ? 1.0 : 0.0,
              child: IconButton(
                icon: Icon(Icons.camera_alt_rounded),
                onPressed: () => pickImage(ImageSource.camera),
                iconSize: 50,
                color: Colors.blue,
              ),
            ),
          ),
          Positioned(
            bottom: 40.0,
            right: MediaQuery.of(context).size.width / 2 - 120,
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 100),
              opacity: _showGalleryIcon ? 1.0 : 0.0,
              child: IconButton(
                icon: Icon(Icons.photo_library),
                onPressed: () => pickImage(ImageSource.gallery),
                iconSize: 50,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
