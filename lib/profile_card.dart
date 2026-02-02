import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Responsive Design')),
      body: Center(
        child: Container(
          color: Colors.grey[200],
          child: Column(
            children: [
              _buildAvatar(),
              Text('Poindexter Dankworth'),
            ],
          ),
        ),
      ),
    );
  }
}


// function that returns a widget
Widget _buildAvatar() {
  return Container(
    width: 100,
    height: 100,
    decoration: BoxDecoration(
      color: Colors.blueAccent,
      shape: BoxShape.circle,
    ),
    child: Icon(Icons.person, size: 75, color: Colors.white),
  );
}