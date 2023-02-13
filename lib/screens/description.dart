import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Description extends StatelessWidget {
  final String title, description;
  const Description({Key? key, required this.description, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Description'),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(10),
              child: Text(
                title,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontFamily: GoogleFonts.lato().fontFamily),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: Text(
                description,
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 20,
                    fontFamily: GoogleFonts.roboto().fontFamily),
              ),
            )
          ],
        ),
      ),
    );
  }
}
