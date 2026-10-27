import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "API LEARNING APP",
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const UserScreen(),
    );
  }
}
class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {

  String Name = " ";
  String Email = "";
  String Addres = "";
  bool isLoading = false;
  String errorMessage = "";

  Future<void>getUser()async{
    setState(() {
      isLoading = true;
      errorMessage = "";
    });
    
    try{
      final url = Uri.parse('https://jsonplaceholder.typicode.com/users/1');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          Name = data["name"];
          Email = data["email"];
          Addres = data["addres"]["city"];
        });
      }

      else{
        setState(() {
          errorMessage = "failed to load user ifomation";
        });
      }
    }

    catch(e) {
      setState(() {
        errorMessage = "error connect to the API";
      });
    }

    finally{
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("api learning app "),
        backgroundColor: Colors.grey,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.cloud_download,
                size: 80,
                color: Colors.green,
              ),
               SizedBox(height: 20),
               Text("learning API with flutter",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 20,),

              if(isLoading)
                const CircularProgressIndicator(),

              if(errorMessage.isNotEmpty)
                Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),

              if(Name.trim().isNotEmpty && !isLoading)
                Card(
                  child: Padding(padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Name: $Name", style: TextStyle(fontSize: 18)),

                        SizedBox(height: 10),
                        Text("Email: $Email"),

                        SizedBox(height: 10),
                        Text("City: $Addres"),

                      ],
                    ),

                  ),
                ),
                SizedBox(height: 20),

                    ElevatedButton(
                    onPressed: isLoading ? null : getUser,
                    child: const Text('Get User Information'),),
            ],
          ),
        ),
      ),


    );


  }
}


