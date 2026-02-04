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
          padding: const EdgeInsets.all(20),
          constraints: const BoxConstraints(maxWidth:800),
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildAvatar(),
                    SizedBox(width: 20),
                    Expanded(child: _buildContent()),
                  ],
                );
              } else {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildAvatar(),
                    SizedBox(height: 15),
                    _buildContent(),
                  ],
                );
              }
            },
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
    decoration: BoxDecoration(color: Colors.blueAccent, shape: BoxShape.circle),
    child: Icon(Icons.person, size: 75, color: Colors.white),
  );
}

// content widget for the profile
Widget _buildContent() {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment:
        CrossAxisAlignment.start, // .start left justifies the column
    children: [
      Text(
        'Hingle McCringleberry',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      Text('Major: Computer Science'),
      Text('Favorite Class: CS364'),
      SizedBox(height: 20),
      ElevatedButton(onPressed: () {}, child: Text('Log in')),
    ],
  );
}
