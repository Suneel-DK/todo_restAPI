import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
bool isLoading = true;
List items = [

];

@override
  void initState() {
  
    super.initState();
    fetchTasks();
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("Todo App"),
        centerTitle: true,
        actions: [],
      ),
     floatingActionButton: FloatingActionButton(
  onPressed: () async {
    final result = await Navigator.pushNamed(context, 'addTask');
    if (result == true) {
      fetchTasks();
    }
  },
  child: const Icon(Icons.add),
),

      body: Visibility(
        visible: isLoading,
        replacement: RefreshIndicator(
          onRefresh: fetchTasks,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement:const Center(child: Text("No Pending Tasks"),),
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder:  (context,index){
            final item = items[index] as Map;
            final id = item['_id'] as String;
            return Card(
              child: ListTile(
                leading: CircleAvatar(child: Text("${index +1}")),
                title: Text(item['title']),
                subtitle: Text(item['description']),
                trailing: IconButton(onPressed: (){deleteTasks(id);}, icon: const Icon(Icons.delete)),
              ),
            );
            }),
          ),
        ),
        child:const Center(child: CircularProgressIndicator(),),
      ),
    );
  }

  Future<void> fetchTasks()async{
    const url = 'http://api.nstack.in/v1/todos?page=1&limit=10';
  final responce = await http.get(Uri.parse(url));
  final json = jsonDecode(responce.body) as Map;
  final result = json['items'] as List;
  
  setState(() {
   items = result;
    isLoading =false;
  });
  
  }
  Future<void>deleteTasks(String id)async{
    var url = 'http://api.nstack.in/v1/todos/$id';
    final response = await http.delete(Uri.parse(url));
    if(response.statusCode == 200){
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    }
  }
}