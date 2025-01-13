import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'road_details.dart';

class ProjectDetailsPage extends StatefulWidget {
  @override
  _ProjectDetailsPageState createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage> {
  List<dynamic> roads = [];
  String? selectedRoad;

  @override
  void initState() {
    super.initState();
    fetchRoads();
  }

  Future<void> fetchRoads() async {
    try {
      final response = await http.get(Uri.parse('https://dev.roadathena.com/api/roads'));
      if (response.statusCode == 200) {
        setState(() {
          roads = json.decode(response.body);
        });
      } else {
        print('Failed to fetch roads: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching roads: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Project Details"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: roads.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Select Road",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: roads.any((road) => road['id'].toString() == selectedRoad) ? selectedRoad : null,
                    items: roads
                        .map((road) => DropdownMenuItem(
                              value: road['id'].toString(),
                              child: Text(road['name']),
                            ))
                        .toList(),
                    onChanged: (value) => setState(() => selectedRoad = value),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (selectedRoad != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RoadDetailsPage(selectedRoad: selectedRoad!),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please select a road")),
                        );
                      }
                    },
                    child: const Text("Next"),
                  ),
                ],
              ),
            ),
    );
  }
}