import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:testtech/create_project.dart';
import 'package:testtech/employee_details.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _nomController;
  late TextEditingController _prenomController;
  late TextEditingController _mailController;
  late TextEditingController _usernameController;

  late TextEditingController _newNomController;
  late TextEditingController _newPrenomController;
  late TextEditingController _newMailController;
  late TextEditingController _newUsernameController;
  late final Map<String, dynamic> _projects ;
  late final Map<String, dynamic> _affectedProjects ;
  List<DropdownMenuItem<String>> dropdownItems = [];
  List<DropdownMenuItem<String>> dropdownItems1 = [];
  var list = [];


  Future<void> postProjectData({
    required String idpro,
    required List<Map<String, String>> list,
  }) async {
    final url = Uri.parse('http://63.250.52.98:9305/projectsdone/UsersProject');

    final data = {
      'project': {'idpro': idpro},
      'list': list,
    };

    // Encode data as JSON for proper request format
    final encodedData = jsonEncode(data);

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: encodedData,
    );

    if (response.statusCode == 200) {
      print("Post Successful!");
      Navigator.pop(context); // Close the bottom sheet
      // Clear text field content
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Project assaigned successfully'),
          duration: Duration(seconds: 2),
        ),
      );
      print(response.body);
    } else {

    }

  }





  bool _isLoading1 = true;


  Future<void> fetchProjects() async {
    final response = await http.get(Uri.parse('http://63.250.52.98:9305/projects'));

    if (response.statusCode == 200) {
      print(response.body);
      setState(() {
        _projects = json.decode(response.body);
        // Extract descriptions and put them in a list
        List<dynamic> projects = _projects['content'];

        // Extract descriptions and put them in a list
        dropdownItems = projects.map((project) {
          return DropdownMenuItem<String>(
            value: project['idpro'].toString(),
            child: Text(project['description']),
          );
        }).toList();

        // Print the list of descriptions

        // Print the list of descriptions
        _isLoading1 = false;
      });
    } else {
      throw Exception('Failed to load employees');
    }
  }
  Future<void> fetchAffectedProjects() async {
    final response = await http.get(Uri.parse('http://63.250.52.98:9305/assign/user-projects'));

    if (response.statusCode == 200) {
      print(response.body);
      setState(() {
        _affectedProjects = json.decode(response.body);
        // Extract descriptions and put them in a list




        // Print the list of descriptions
        _isLoading1 = false;
      });
    } else {
      throw Exception('Failed to load employees');
    }
  }



  late final Map<String, dynamic> _employees ;
  bool _isLoading = true;
  Future<void> addEmployee() async {
    final url = 'http://63.250.52.98:9305/persons/new';
    Map<String, String> data = {
      "nom": "${_newNomController.text}",
      "prenom": "${_newPrenomController.text}",
      "username": "${_newUsernameController.text}",
      "mail": "${_newMailController.text}"
    };

    var response = await http.post(Uri.parse(url),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      print("Post Successful!");
      Navigator.pop(context); // Close the bottom sheet
      // Clear text field content
      _newNomController.clear();
      _newMailController.clear();
      _newUsernameController.clear();
      _newPrenomController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Employee added successfully'),
          duration: Duration(seconds: 2),
        ),
      );
      print(response.body);
    } else {
      print("Failed to add Employee: ${response.statusCode}");
      print(response.body);
    }
  }

  Future<void> updateUser(String id, String nom, String prenom, String username, String mail) async {
    final url = 'http://63.250.52.98:9305/persons/upuserr/$id';

    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'nom': nom,
        'prenom': prenom,
        'username': username,
        'mail': mail,
      }),
    );

    if (response.statusCode == 200) {
      // Successfully updated the user
      print('User updated successfully.');
    } else {
      // Error occurred while updating the user
      print('Failed to update the user. Status code: ${response.statusCode}');
    }
  }
  Future<void> fetchEmployees() async {
    final response = await http.get(Uri.parse('http://63.250.52.98:9305/persons'));

    if (response.statusCode == 200) {
      print(response.body);
      setState(() {
        _employees = json.decode(response.body);
        print(_employees["content"]);
        List<dynamic> employees = _employees['content'];

        dropdownItems1 = employees.map((employee) {
          return DropdownMenuItem<String>(
            value: employee['idperson'].toString(),
            child: Text(employee['username']),
          );
        }).toList();
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load employees');
    }
  }
  String? selectedProject;
  String? selectedEmployee;



  @override
  void initState() {
    super.initState();
    fetchEmployees();
    fetchProjects();
    fetchAffectedProjects();
    _nomController = TextEditingController();
    _prenomController = TextEditingController();
    _mailController = TextEditingController();
    _usernameController = TextEditingController();

    _newNomController = TextEditingController();
    _newPrenomController = TextEditingController();
    _newMailController = TextEditingController();
    _newUsernameController = TextEditingController();



  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _mailController.dispose();
    _usernameController.dispose();

    _newNomController.dispose();
    _newPrenomController.dispose();
    _newMailController.dispose();
    _newUsernameController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FilledButton.icon(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateProjectPage()));
                },
                style: ElevatedButton.styleFrom(
                  elevation: 3,

                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Adjust padding as needed
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // Adjust border radius as needed
                  ),
                ),

                icon: Icon(Icons.folder),
                label: Text("Create Project")),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome 👋, Admin!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25
              ),
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                Expanded(
                    child: FilledButton.icon(
                        onPressed: (){
                          showModalBottomSheet(
                            isScrollControlled: true,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
                              ),
                              context: context,
                              builder:(BuildContext context){

                                return Container(
                                  height: MediaQuery.of(context).size.height * 0.65, // Adjust height as needed

                                  padding: EdgeInsets.all(16),
                                  width: double.infinity,
                                  child: Column(

                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.add),
                                          SizedBox(width: 10,),
                                          Text("Add New Empoyee",
                                          style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)
                                        ],
                                      ),
                                      SizedBox(height: 20,),
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15),
                                            border: Border.all()
                                        ),
                                        padding: EdgeInsets.all(8.0),
                                        child: TextField(
                                          controller: _newNomController,
                                          decoration: InputDecoration(
                                            labelText: 'Entrer le nom',
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15),
                                            border: Border.all()
                                        ),
                                        padding: EdgeInsets.all(8.0),
                                        child: TextField(
                                          controller: _newPrenomController,
                                          decoration: InputDecoration(
                                            labelText: 'Entrer le prenom',
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15),
                                            border: Border.all()
                                        ),
                                        padding: EdgeInsets.all(8.0),
                                        child: TextField(
                                          controller: _newUsernameController,
                                          decoration: InputDecoration(
                                            labelText: 'Entrer le username',
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15),
                                            border: Border.all()
                                        ),
                                        padding: EdgeInsets.all(8.0),
                                        child: TextField(
                                          controller: _newMailController,
                                          decoration: InputDecoration(
                                            labelText: 'Entrer le mail',
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 15,),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: FilledButton.icon(
                                              onPressed: (){
                                                addEmployee();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                elevation: 3,

                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(15), // Adjust border radius as needed
                                                ),
                                              ),

                                              label: Text("Save New Employee"),

                                            icon: Icon(Icons.save),),
                                          ),
                                        ],
                                      )



                                    ],
                                  ),
                                );
                              });
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 3,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15), // Adjust border radius as needed
                          ),
                        ),

                        icon: Icon(Icons.add),
                        label: Text("Add Empoyee")))
              ],
            ),
            SizedBox(height: 10,),

            Row(
              children: [
                FilledButton.icon(
                    onPressed: (){
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context){
                            return Container(
                              height: 500,
                              padding: EdgeInsets.all(12),
                              child: Column(
                                children: [
                                  SizedBox(height: 10,),
                                  Row(
                                    children: [
                                      Icon(Icons.folder),
                                      SizedBox(width: 15,),
                                      Text("Projects",style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17
                                      ),)
                                    ],
                                  ),
                                  SizedBox(height: 20,),
                                  _isLoading1
                                      ? Center(child: CircularProgressIndicator(),):
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: _affectedProjects["content"].length,
                                      itemBuilder: (context, index) {
                                        final project = _affectedProjects["content"][index]["projecto"];
                                        final employeee = _affectedProjects["content"][index]["persono"];
                                        return Column(
                                          children: [
                                            Card(
                                              elevation: 4,
                                              child:ExpansionTile(
                                                title: Container(
                                                  child: SingleChildScrollView(
                                                    scrollDirection: Axis.horizontal,
                                                    child: Row(
                                                      children: [
                                                        Icon(Icons.folder),
                                                        SizedBox(width: 5,),
                                                        SizedBox(
                                                          width: 230,
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(project["description"],style: TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 17
                                                              ),),
                                                              Text("Nom: ${project["nom"]}",),
                                                    
                                                              Text("Date : ${project["date"]}")
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                children: [
                                                  Padding(
                                                      padding: EdgeInsets.all(15),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text("Employee : ",style: TextStyle(fontWeight: FontWeight.bold),),
                                                        Card(
                                                          elevation: 3,
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Row(
                                                              children: [
                                                                Icon(Icons.person),
                                                                SizedBox(width: 10,),
                                                                Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(employeee["username"],style: TextStyle(fontWeight: FontWeight.bold,
                                                                    fontSize: 16),),
                                                                    Text(employeee["mail"],)

                                                                  ],
                                                                )

                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  )

                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 10,)
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              )

                            );
                          });
                    },
                    label: Text("View Projects ",style: TextStyle(fontSize: 13)),
                  style: ElevatedButton.styleFrom(
                    elevation: 3,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // Adjust border radius as needed
                    ),
                  ),

                  icon: Icon(Icons.folder),
                ),
                SizedBox(width: 12,),
                FilledButton.icon(
                  onPressed: (){
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context){
                          return Container(
                            height: 400,
                            width: double.infinity,
                            padding: EdgeInsets.all(12),
                            child: _isLoading1
                                ? Center(child: CircularProgressIndicator(),)
                                :
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.link),
                                    SizedBox(width: 10,),
                                    Text("Assaign Project to Employee",style: TextStyle(fontWeight: FontWeight.bold),)
                                  ],
                                ),
                                SizedBox(height: 20,),
                                Text("Please select employee"),
                                SizedBox(height: 10,),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color: Colors.black54,
                                      )
                                  ),
                                  child: DropdownButtonFormField<String>(

                                    icon : Icon(Icons.person),
                                    hint: Text("Select Employee"),
                                    value: selectedEmployee,
                                    items: dropdownItems1,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedEmployee = value!;
                                        // Store selected value
                                      });
                                      print('Selected Employee: $selectedEmployee');
                                    },
                                  ),
                                ),
                                SizedBox(height: 20,),
                                Text("Please select project"),
                                SizedBox(height: 10,),
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
                                    icon: Icon(Icons.folder),
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

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // Adjust border radius as needed
                    ),
                  ),

                  label: Text("Assaign Project",style: TextStyle(fontSize: 13),),
                  icon: Icon(Icons.link),
                )

              ],
            ),
            SizedBox(height: 20,),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : Expanded(
                  child: ListView.builder(
                                itemCount: _employees["content"].length,
                                itemBuilder: (context, index) {
                  final employee = _employees["content"][index];
                  return Column(
                    children: [
                      GestureDetector(
                        child: Card(
                          elevation: 4,
                          child:Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(Icons.person),
                                SizedBox(width: 5,),
                                SizedBox(
                                  width: 230,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(employee["username"],style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        fontSize: 17
                                      ),),
                                      Text("Email : ${employee["mail"]}")
                                    ],
                                  ),
                                ),
                                IconButton(onPressed: (){
                                  showDialog(context: context, builder: (BuildContext context){
                                    return(
                                        AlertDialog(
                                          title: Text('Edit ${employee["username"]}'),
                                          content: SingleChildScrollView(
                                            child: SizedBox(
                                              height: 400,
                                              child: Column(

                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                      border: Border.all()
                                                    ),
                                                    padding: EdgeInsets.all(10.0),
                                                    child: TextField(
                                                      controller: _nomController,
                                                      decoration: InputDecoration(
                                                        labelText: 'Entrer le nom',
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 5,),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        border: Border.all()
                                                    ),
                                                    padding: EdgeInsets.all(10.0),
                                                    child: TextField(
                                                      controller: _prenomController,
                                                      decoration: InputDecoration(
                                                        labelText: 'Entrer le prenom',
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 5,),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        border: Border.all()
                                                    ),
                                                    padding: EdgeInsets.all(10.0),
                                                    child: TextField(
                                                      controller: _usernameController,
                                                      decoration: InputDecoration(
                                                        labelText: 'Entrer le username',
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 5,),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        border: Border.all()
                                                    ),
                                                    padding: EdgeInsets.all(10.0),
                                                    child: TextField(
                                                      controller: _mailController,
                                                      decoration: InputDecoration(
                                                        labelText: 'Entrer le mail',
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 5,),



                                                ],
                                              ),
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(); // Close the dialog
                                              },
                                              child: Text('Cancel'),
                                            ),
                                            TextButton.icon(
                                              icon: Icon(Icons.edit,),


                                              onPressed: () {
                                                updateUser(employee["idperson"].toString(), _nomController.text, _prenomController.text, _usernameController.text, _mailController.text);

                                              },
                                              label: Text('Edit',),
                                            ),
                                          ],
                                        ));
                                  });

                                }, icon: Icon(Icons.edit))
                              ],
                            ),
                          ),
                        ),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>EmployeeDetails(
                            id: employee["idperson"].toString(),

                          )));
                        },
                      ),
                      SizedBox(height: 10,)
                    ],
                  );
                                },
                              ),
                ), 
          ],
        ),
      ),
    );
  }
}
