import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late SharedPreferences sharedPreferences;
  String? name;
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  void initPrefs() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    name = sharedPreferences.getString("name");
    setState(() {});
  }

  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Local Storage App"),
      ),
      body: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(hintText: "Enter Name"),
          ),
          ElevatedButton(
            onPressed: () {
              sharedPreferences.setString('name', nameController.text);
              name = sharedPreferences.getString('name');
              setState(() {});
            },
            child: Text("Save"),
          ),
          Text("${name ?? "NULL"}"),
        ],
      ),
    );
  }
}
