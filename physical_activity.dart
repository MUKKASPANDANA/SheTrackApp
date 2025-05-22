import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PhysicalActivityScreen extends StatefulWidget {
  @override
  _PhysicalActivityScreenState createState() => _PhysicalActivityScreenState();
}

class _PhysicalActivityScreenState extends State<PhysicalActivityScreen> {
  String selectedType = 'Walking';
  String selectedIntensity = 'Medium';
  double duration = 30;
  bool showAdvancedOptions = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      body: Center(
        child: Container(
          width: 340,
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                blurRadius: 15,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFFF2F1FF),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.directions_run,
                  size: 34,
                  color: Color(0xFF6E62E5),
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Physical Activity',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              SizedBox(height: 24),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Type',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF666666),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Color(0xFFE0E0E0)),
                ),
                child: DropdownButtonFormField<String>(
                  value: selectedType,
                  items: ['Walking', 'Running', 'Cycling', 'Yoga']
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedType = value!;
                    });
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: InputBorder.none,
                  ),
                  icon: Icon(Icons.keyboard_arrow_down, color: Color(0xFF6E62E5)),
                  isExpanded: true,
                ),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Duration (minutes)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF666666),
                  ),
                ),
              ),
              SizedBox(height: 8),
              SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: Color(0xFF6E62E5),
                  inactiveTrackColor: Color(0xFFE0E0E0),
                  thumbColor: Color(0xFF6E62E5),
                  trackHeight: 4.0,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.0),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 20.0),
                ),
                child: Slider(
                  value: duration,
                  min: 0,
                  max: 120,
                  divisions: 12,
                  label: duration.round().toString(),
                  onChanged: (value) {
                    setState(() {
                      duration = value;
                    });
                  },
                ),
              ),
              Text(
                '${duration.round()} min',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF6E62E5),
                ),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Intensity',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF666666),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Color(0xFFE0E0E0)),
                ),
                child: DropdownButtonFormField<String>(
                  value: selectedIntensity,
                  items: ['Low', 'Medium', 'High']
                      .map((intensity) => DropdownMenuItem(
                            value: intensity,
                            child: Text(intensity),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedIntensity = value!;
                    });
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: InputBorder.none,
                  ),
                  icon: Icon(Icons.keyboard_arrow_down, color: Color(0xFF6E62E5)),
                  isExpanded: true,
                ),
              ),
              SizedBox(height: 16),
              Theme(
                data: ThemeData(
                  checkboxTheme: CheckboxThemeData(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                child: CheckboxListTile(
                  value: showAdvancedOptions,
                  onChanged: (value) {
                    setState(() {
                      showAdvancedOptions = value!;
                    });
                  },
                  title: Text(
                    'Advanced Options',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF666666),
                    ),
                  ),
                  activeColor: Color(0xFF6E62E5),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              if (showAdvancedOptions)
                Container(
                  margin: EdgeInsets.only(top: 12, bottom: 16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFFF7F7FF),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Additional settings will appear here',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF888888),
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Log activity logic here
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Activity logged: $selectedType for ${duration.round()} minutes at $selectedIntensity intensity',
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFF6B5C),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  minimumSize: Size(double.infinity, 0),
                  elevation: 0,
                ),
                child: Text(
                  'Log Activity',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}