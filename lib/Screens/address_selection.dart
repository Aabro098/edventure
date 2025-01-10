import 'package:flutter/material.dart';

import '../constants/sub_divisons.dart';


class AddressSelection extends StatefulWidget {
  const AddressSelection({super.key});

  @override
  AddressSelectionState createState() => AddressSelectionState();
}

class AddressSelectionState extends State<AddressSelection> {
  String? selectedProvince;
  String? selectedDistrict;
  String? selectedMunicipality;

  List<String> districtOptions = [];
  List<String> municipalityOptions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Select Province'),
              value: selectedProvince,
              items: provincesAndDistricts.keys.map((province) {
                return DropdownMenuItem(
                  value: province,
                  child: Text(province),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedProvince = value;
                  selectedDistrict = null;
                  selectedMunicipality = null;
                  districtOptions = provincesAndDistricts[value!]!;
                  municipalityOptions = [];
                });
              },
            ),
            SizedBox(height: 16.0),

            // District Dropdown
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Select District'),
              value: selectedDistrict,
              items: districtOptions.map((district) {
                return DropdownMenuItem(
                  value: district,
                  child: Text(district),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedDistrict = value;
                  selectedMunicipality = null;
                  municipalityOptions = districtsAndMunicipalities[value!]!;
                });
              },
              isExpanded: true,
              disabledHint: Text('Select Province first'),
            ),
            SizedBox(height: 16.0),

            // Municipality Dropdown
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Select Municipality'),
              value: selectedMunicipality,
              items: municipalityOptions.map((municipality) {
                return DropdownMenuItem(
                  value: municipality,
                  child: Text(municipality),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedMunicipality = value;
                });
              },
              isExpanded: true,
              disabledHint: Text('Select District first'),
            ),
          ],
        ),
      ),
    );
  }
}
