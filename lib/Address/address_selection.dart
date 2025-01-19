import 'package:edventure/Services/auth_services.dart';
import 'package:edventure/utils/elevated_button.dart';
import 'package:edventure/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/sub_divisons.dart';
import '../providers/user_provider.dart';

class AddressSelection extends StatefulWidget {
  const AddressSelection({super.key});

  @override
  AddressSelectionState createState() => AddressSelectionState();
}

class AddressSelectionState extends State<AddressSelection> {
  String? selectedProvince;
  String? selectedDistrict;
  String? selectedMunicipality;
  int? wardNumber;
  bool isLoading = false;

  List<String> districtOptions = [];
  List<String> municipalityOptions = [];

  final _formKey = GlobalKey<FormState>();
  final TextEditingController addressController = TextEditingController();

  Future<void> updateAddress() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
    });

    try {
      await AuthService().updateUser(
        context: context,
        address: addressController.text,
      );

      if (mounted) {
        Provider.of<UserProvider>(context, listen: false)
            .updateUserAddress(addressController.text);

        await Provider.of<UserProvider>(context, listen: false)
            .refreshUser(context);

        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(context, e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Address'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Select Province'),
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
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Select District'),
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
                disabledHint: const Text('Select Province first'),
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                decoration:
                    const InputDecoration(labelText: 'Select Municipality'),
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
                disabledHint: const Text('Select District first'),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Ward No'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter ward number';
                  }
                  final ward = int.tryParse(value);
                  if (ward == null || ward < 1 || ward > 32) {
                    return 'Ward number must be between 1 and 32';
                  }
                  return null;
                },
                onSaved: (value) {
                  wardNumber = int.tryParse(value!);
                },
              ),
              const SizedBox(height: 16.0),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : AppElevatedButton(
                      text: 'Save',
                      color: Colors.green.shade400,
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          final address =
                              '$selectedProvince, $selectedDistrict, $selectedMunicipality - $wardNumber';
                          addressController.text = address;
                          updateAddress();
                          Navigator.pop(context);
                        }
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
