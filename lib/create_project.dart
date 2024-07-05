import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class CreateProjectPage extends StatefulWidget {
  @override
  State<CreateProjectPage> createState() => _CreateProjectPageState();
}

class _CreateProjectPageState extends State<CreateProjectPage> {
  late GoogleMapController _mapController;
  LatLng? _selectedLocation;
  Set<Marker> _markers = {};
  late TextEditingController _projectNameController;
  late TextEditingController _projectDescriptionController;
  final String url = 'http://63.250.52.98:9305/projects/create'; // Your endpoint URL

  Future<void> postData() async {
    Map<String, String> data = {
      "nom": "${_projectNameController.text}",
      "description": "${_projectDescriptionController.text}",
      "latitude": "${_selectedLocation!.latitude.toString()}",
      "longitude": "${_selectedLocation!.longitude.toString()}"
    };

    var response = await http.post(Uri.parse(url),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      print("Post Successful!");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Project added successfully'),
          duration: Duration(seconds: 2),
        ),
      );
      print(response.body);
    } else {
      print("Failed to post data: ${response.statusCode}");
      print(response.body);
    }
  }


  
  @override
  void initState() {
    super.initState();
    _projectNameController = TextEditingController();
    _projectDescriptionController = TextEditingController();




  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.folder),
            SizedBox(width: 5,),
            Text("Create Project",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),)
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all()
              ),
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: _projectNameController,
                decoration: InputDecoration(
                  labelText: 'Entrer le nom du projet',
                ),
              ),
            ),
            SizedBox(height: 15,),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all()
              ),
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: _projectDescriptionController,
                decoration: InputDecoration(
                  labelText: 'Entrer la description du projet',
                ),
              ),
            ),
            SizedBox(height: 15,),
            Text("Select Project Location : "),


            SizedBox(height: 16.0),

            Expanded(
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(36.63364352606837, 10.246481271254885),
                      zoom: 10.0,
                    ),
                    onTap: (LatLng latLng) {
                      setState(() {
                        _selectedLocation = latLng;
                        _markers.clear();
                        _markers.add(
                          Marker(
                            markerId: MarkerId('selected-location'),
                            position: _selectedLocation!,
                            infoWindow: InfoWindow(title: 'Selected Location'),
                          ),
                        );
                      });
                    },
                    markers: _markers,
                    onMapCreated: (GoogleMapController controller) {
                      _mapController = controller;
                    },
                  ),
                  if (_selectedLocation != null)
                    Positioned(
                      bottom: 16.0,
                      left: 16.0,
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Latitude: ${_selectedLocation!.latitude}',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            Text(
                              'Longitude: ${_selectedLocation!.longitude}',
                              style: TextStyle(fontSize: 16.0),
                            ),

                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 10.0),

            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                      onPressed: (){
                        postData();
                      },
                    style: ElevatedButton.styleFrom(
                      elevation: 3,

                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Adjust padding as needed
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15), // Adjust border radius as needed
                      ),
                    ),

                    label: Text("Add Project"),
                    icon: Icon(Icons.save),),

                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
