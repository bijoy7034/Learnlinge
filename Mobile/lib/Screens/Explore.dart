import 'package:flutter/material.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 13.0, right: 13, top: 60),
              child: TextFormField(
                style: const TextStyle(
                  color: Colors.white, // Set the desired text color
                ),
                decoration: InputDecoration(filled: true,
                    contentPadding: EdgeInsets.symmetric(vertical:0, horizontal:19),
                    fillColor: Colors.grey[900], labelText: "Search", focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Color.fromRGBO(88, 101, 242, 0.9)),
                    ), border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                    ), labelStyle: const TextStyle(color: Colors.white60)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a vale';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ),

    );
  }
}
