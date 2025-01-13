import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RoadDetailsPage extends StatefulWidget {
  final String selectedRoad;

  const RoadDetailsPage({Key? key, required this.selectedRoad}) : super(key: key);

  @override
  _RoadDetailsPageState createState() => _RoadDetailsPageState();
}

class _RoadDetailsPageState extends State<RoadDetailsPage> {
  Map<String, dynamic>? roadDetails;
  final TextEditingController _laneNumberController = TextEditingController();
  final TextEditingController _startChainageController = TextEditingController();
  final TextEditingController _endChainageController = TextEditingController();
  String _selectedRoadType = 'SSL'; // Default value for dropdown
  final List<String> roadTypes = ['SSL', 'MCW', 'Expressway', 'Service Road'];

  @override
  void initState() {
    super.initState();
    fetchRoadDetails();
  }

  Future<void> fetchRoadDetails() async {
    try {
      final response = await http.get(Uri.parse('https://dev.roadathena.com/api/roads/${widget.selectedRoad}/'));
      if (response.statusCode == 200) {
        setState(() {
          roadDetails = json.decode(response.body);
          // Pre-fill fields with existing data
          _laneNumberController.text = roadDetails?['lane_number']?.toString() ?? '';
          _startChainageController.text = roadDetails?['start_chainage']?.toString() ?? '';
          _endChainageController.text = roadDetails?['end_chainage']?.toString() ?? '';
          _selectedRoadType = roadDetails?['road_type'] ?? 'SSL';
        });
      } else {
        print('Failed to fetch road details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching road details: $e');
    }
  }

  Future<void> updateRoadDetails() async {
    try {
      final Map<String, dynamic> updatedDetails = {
        'road_type': _selectedRoadType,
        'lane_number': int.tryParse(_laneNumberController.text) ?? 0,
        'start_chainage': double.tryParse(_startChainageController.text) ?? 0.0,
        'end_chainage': double.tryParse(_endChainageController.text) ?? 0.0,
      };

      final response = await http.patch(
        Uri.parse('https://dev.roadathena.com/api/roads/${widget.selectedRoad}/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedDetails),
      );

      if (response.statusCode == 200) {
        print('Road details updated successfully!');
        fetchRoadDetails(); // Refresh data
      } else {
        print('Failed to update road details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating road details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Road Details'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: roadDetails == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    value: roadTypes.contains(_selectedRoadType) ? _selectedRoadType : null,
                    items: roadTypes.map((type) {
                      return DropdownMenuItem(value: type, child: Text(type));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedRoadType = value!;
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Road Type'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _laneNumberController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Lane Number'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _startChainageController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Start Chainage'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _endChainageController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'End Chainage'),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: updateRoadDetails,
                    child: const Text('Update Details'),
                  ),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    _laneNumberController.dispose();
    _startChainageController.dispose();
    _endChainageController.dispose();
    super.dispose();
  }
}