// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  final String searchBarName;
  const CustomSearchBar({Key? key, required this.searchBarName})
      : super(key: key);

  @override
  _CustomSearchBarState createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    return Row(
      children: [
        Expanded(
          child: Card(
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(16),
                hintText: 'Search ${widget.searchBarName}',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search_outlined,
                      color: Colors.black.withOpacity(0.74)),
                  onPressed: () {},
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
