import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ComplaintForm extends StatefulWidget {
  @override
  State<ComplaintForm> createState() => _ComplaintFormState();
}

class _ComplaintFormState extends State<ComplaintForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _subjectController = TextEditingController();
  final _complaintController = TextEditingController();

  String? _selectedDepartment;
  String? _selectedSemester;
  String? _selectedSection;

  final List<String> _departments = [
    'Computer Science',
    'Software Engineering',
    'Other'
  ];

  final List<String> _semesters = [
    '1st Semester',
    '2nd Semester',
    '3rd Semester',
    '4th Semester',
    '5th Semester',
    '6th Semester',
    '7th Semester',
    '8th Semester',
  ];

  final List<String> _sections = [
    'A',
    'B',
    'C',
    'D',
  ];

  final _databaseRef = FirebaseDatabase.instance.ref('complaints');

  void _submitComplaint(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final phone = _phoneController.text.trim();
      final subject = _subjectController.text.trim();
      final complaint = _complaintController.text.trim();

      // Push data to Firebase
      _databaseRef.push().set({
        'name': name,
        'phone': phone,
        'department': _selectedDepartment,
        'semester': _selectedSemester,
        'section': _selectedSection,
        'subject': subject,
        'complaint': complaint,
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Clear input fields
      _nameController.clear();
      _phoneController.clear();
      _subjectController.clear();
      _complaintController.clear();
      _selectedDepartment = null;
      _selectedSemester = null;
      _selectedSection = null;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Complaint submitted successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width > 600 ? 500 : double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blueGrey.shade200, // First color
                          Colors.blueGrey.shade200, // Second color
                          Colors.blueGrey.shade200, // Third color
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                             Text(
                              'Submit Your Complaint',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey.shade900,
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildTextField(_subjectController, 'Subject', 'Enter the subject of your complaint'),
                            const SizedBox(height: 15),
                            _buildTextField(
                              _complaintController,
                              'Complaint Details',
                              'Describe your complaint in detail',
                              maxLines: 5,
                              minLines: 5,
                            ),
                            const SizedBox(height: 15),
                            _buildTextField(_nameController, 'Name', 'Enter your full name'),
                            const SizedBox(height: 15),
                            _buildTextField(
                                _phoneController, 'Phone Number', 'Enter your phone number',
                                keyboardType: TextInputType.phone),
                            const SizedBox(height: 15),
                            _buildDropdownField(
                              label: 'Department',
                              value: _selectedDepartment,
                              items: _departments,
                              onChanged: (value) {
                                setState(() {
                                  _selectedDepartment = value;
                                });
                              },
                            ),
                            const SizedBox(height: 15),
                            _buildDropdownField(
                              label: 'Semester',
                              value: _selectedSemester,
                              items: _semesters,
                              onChanged: (value) {
                                setState(() {
                                  _selectedSemester = value;
                                });
                              },
                            ),
                            const SizedBox(height: 15),
                            _buildDropdownField(
                              label: 'Section',
                              value: _selectedSection,
                              items: _sections,
                              onChanged: (value) {
                                setState(() {
                                  _selectedSection = value;
                                });
                              },
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () => _submitComplaint(context),
                              child: const Text(
                                'Submit',
                                style: TextStyle(fontSize: 18,color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 300,)
                ],
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.blueGrey.shade700
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label,
      String hint, {
        TextInputType keyboardType = TextInputType.text,
        int maxLines = 1,
        int minLines = 1,
      }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      minLines: minLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.teal, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.black, width: 1),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $label';
        }
        return null;
      },
    );
  }


  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.teal, width: 2), // Focused border
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.black, width: 1), // Unfocused border
        ),
      ),
      value: value,
      items: items
          .map((item) => DropdownMenuItem<String>(
        value: item,
        child: Text(item),
      ))
          .toList(),
      onChanged: onChanged,
      dropdownColor: Colors.blueGrey.shade100, // Dropdown menu background color
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a $label';
        }
        return null;
      },
    );
  }

}
