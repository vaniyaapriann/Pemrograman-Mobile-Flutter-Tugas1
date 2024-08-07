import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchThing extends StatefulWidget {
  final Function(String) onSearch;

  const SearchThing({Key? key, required this.onSearch}) : super(key: key);

  @override
  _SearchThingState createState() => _SearchThingState();
}

class _SearchThingState extends State<SearchThing> {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: widget.onSearch,
      decoration: InputDecoration(
        hintText: 'Search Here',
        hintStyle: GoogleFonts.urbanist(
          fontSize: 13,
          color: Colors.grey.shade600
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: Colors.grey.shade300)
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
           borderSide: BorderSide(color: Color.fromARGB(255, 28, 95, 30))
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(width: 1.0, color: Colors.grey.shade400),
        ),
        suffixIcon: Container(
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(50),
              bottomRight: Radius.circular(50)
            ),
            color: Color.fromARGB(255, 28, 95, 30),),
          child: Icon(Icons.search, color: Colors.white,),
        ),
      ),
    );
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}