import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AppTask extends StatefulWidget {
  const AppTask({super.key});

  @override
  State<AppTask> createState() => _AppTaskState();
}

class _AppTaskState extends State<AppTask> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Task"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Task Name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Task Description'),
              maxLines: 5,
            ),
          ),
         ElevatedButton(
  onPressed: () async {
    await submitData();
    Navigator.pop(context, true);
  },
  child: const Text("Add Task"),
),

        ],
      ),
    );
  }

  Future<void> submitData() async {
    final title = _titleController.text;
    final description = _descriptionController.text;

    
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };

    const url = 'http://api.nstack.in/v1/todos';
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    if (mounted) {
      if (response.statusCode == 201) {
        _titleController.text= '';
        _descriptionController.text='';
        successMessage("Data Added Successfully");
      } else {
        errorMessage('Data not Added');
      }
    }
  }

  void successMessage(String message){
   final snackBar = SnackBar(content: Text(message),backgroundColor: Colors.green,);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  
  void errorMessage(String message){
   final snackBar = SnackBar(content: Text(message),backgroundColor: Colors.red,);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
