import 'package:flutter/material.dart';

class mySearchBar extends StatefulWidget {
  final Function(String)? onSearch; // Callback for when the user types input
  final Function? onClose; // Callback for when the search bar is closed

  const mySearchBar({this.onSearch, this.onClose, Key? key}) : super(key: key);

  @override
  mySearchBarState createState() => mySearchBarState();
}

class mySearchBarState extends State<mySearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Row(
        children: [
          SizedBox(width: 10), // Add spacing around the edges
          Icon(Icons.search, color: Colors.grey),
          SizedBox(width: 10), // Add spacing between the icon and text
          Expanded(
            child: TextField(
              controller: _controller,
              autofocus: true,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
              onChanged: (value) {
                if (widget.onSearch != null) {
                  widget.onSearch!(value); // Trigger the callback on every change
                }
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: Colors.grey),
            onPressed: () {
              _controller.clear(); // Clear the input
              if (widget.onClose != null) {
                widget.onClose!(); // Trigger the close callback
              }
            },
          ),
        ],
      ),
    );
  }
}
