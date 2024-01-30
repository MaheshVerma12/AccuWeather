import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Counter app with Bloc pattern"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "0",
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 29),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                onPressed: () {},
                child: Icon(Icons.add),
              ),
              FloatingActionButton(
                onPressed: () {},
                child: Icon(Icons.remove),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
