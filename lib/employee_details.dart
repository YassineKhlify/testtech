import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EmployeeDetails extends StatefulWidget {
  final String id;
  EmployeeDetails({required this.id});


  @override
  _EmployeeDetailsState createState() => _EmployeeDetailsState();
}

class _EmployeeDetailsState extends State<EmployeeDetails> {
  late final Map<String, dynamic> _employee ;
  late final Map<String, dynamic> _projects ;

  bool _isLoading = true;
  bool _isLoading1 = true;
  List<DropdownMenuItem<String>> dropdownItems = [];
  List descriptions = [];

  Future<void> fetchEmployee() async {
    final response = await http.get(Uri.parse('http://63.250.52.98:9305/persons/${widget.id}'));

    if (response.statusCode == 200) {
      print(response.body);
      setState(() {
        _employee = json.decode(response.body);
        print(_employee["nom"]);
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load employees');
    }
  }
  Future<void> fetchProjects() async {
    final response = await http.get(Uri.parse('http://63.250.52.98:9305/projects'));

    if (response.statusCode == 200) {
      print(response.body);
      setState(() {
        _projects = json.decode(response.body);
        // Extract descriptions and put them in a list
        List<dynamic> projects = _projects['content'];

        // Extract descriptions and put them in a list
        descriptions = projects.map((project) => project['description']).toList();
        dropdownItems = projects.map((project) {
          return DropdownMenuItem<String>(
            value: project['description'],
            child: Text(project['description']),
          );
        }).toList();

        // Print the list of descriptions
        print(descriptions);

        // Print the list of descriptions
        _isLoading1 = false;
      });
    } else {
      throw Exception('Failed to load employees');
    }
  }

  void initState(){
    super.initState();
    fetchEmployee();
    fetchProjects();
  }
  String? selectedProject;

  @override
  Widget build(BuildContext context) {
    final id = widget.id;
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FilledButton.icon(
                onPressed: (){
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context){
                        return Container(
                          height: 250,
                          width: double.infinity,
                          padding: EdgeInsets.all(12),
                          child: _isLoading1
                          ? Center(child: CircularProgressIndicator(),)
                          :
                          Column(
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.link),
                                  SizedBox(width: 10,),
                                  Text("Assaign Project to Employee",style: TextStyle(fontWeight: FontWeight.bold),)
                                ],
                              ),
                              SizedBox(height: 20,),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: Colors.black54,
                                    )
                                ),
                                child: DropdownButtonFormField<String>(
                                  hint: Text("Select Project"),
                                  value: selectedProject,
                                  items: dropdownItems,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedProject = value!; // Store selected value
                                    });
                                    print('Selected project: $selectedProject');
                                  },
                                ),
                              ),
                              SizedBox(height: 20,),

                              Row(
                                children: [
                                  Expanded(
                                    child: FilledButton.icon(
                                      onPressed: (){
                                      },
                                      style: ElevatedButton.styleFrom(
                                        elevation: 3,

                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15), // Adjust border radius as needed
                                        ),
                                      ),

                                      label: Text("Save"),

                                      icon: Icon(Icons.save),),
                                  ),
                                ],
                              )


                            ],
                          )
                          ,
                        );
                      });
                },
                style: ElevatedButton.styleFrom(
                  elevation: 3,

                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Adjust padding as needed
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // Adjust border radius as needed
                  ),
                ),

                icon: Icon(Icons.link),
                label: Text("Assaign Project")),
          )

        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            _isLoading
            ? Center(child: CircularProgressIndicator())
            :Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Icon(Icons.person),
                    SizedBox(width: 15,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Username : ${_employee['username']}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                        Text("Nom : ${_employee['nom']}",),
                        Text("Prenom : ${_employee['prenom']}",),
                        Text("Mail : ${_employee['mail']}",)




                      ],

                    )
                  ],
                ),
              ),
            ),



          ],
        ),
      ),
    );
  }
}
