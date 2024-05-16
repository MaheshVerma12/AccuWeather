import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:worksmart/model/teams.dart';

class NbaData extends StatelessWidget {
  NbaData({super.key});

  List<Team> teams = [];

  Future getTeams() async {
    final response = await http.get(
      Uri.parse('https://api.balldontlie.io/v1/teams'),
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader: '849c736a-e3d5-43b7-ad2e-4ae7c6dac5ad',
      },
    );
    print(response.body);
    var jsonData = jsonDecode(response.body);
    for (var eachTeam in jsonData['data']) {
      final team = Team(
          abbreviation: eachTeam['abbreviation'],
          full_names: eachTeam['full_name'],
          division: eachTeam['division']);
      teams.add(team);
    }
  }

  @override
  Widget build(BuildContext context) {
    getTeams();
    return Scaffold(
      appBar: AppBar(
        title: Text("NBA Teams List :)",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic)),
        centerTitle: true,
        backgroundColor: Colors.purple[600],
      ),
      body: FutureBuilder(
          future: getTeams(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Scrollbar(
                child: ListView.builder(
                  itemCount: teams.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(teams[index].abbreviation,
                            style: TextStyle(color: Colors.white)),
                        subtitle: Text(teams[index].full_names,
                            style: TextStyle(color: Colors.white)),
                        trailing: Text(teams[index].division,
                            style: TextStyle(color: Colors.white)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        onTap: () {},
                        leading: Icon(
                          Icons.sports_basketball,
                          color: Colors.white,
                        ),
                        contentPadding: EdgeInsets.all(10),
                        tileColor: Colors.indigo[300],
                      ),
                    );
                  },
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
