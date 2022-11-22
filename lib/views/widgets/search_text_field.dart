import 'package:flutter/material.dart';

class SearchTextField extends StatelessWidget {
  final dynamic Function(String?) onChanged;
  const SearchTextField({required this.onChanged, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            hintText: 'Search task',
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: const BorderSide(color: Colors.white)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: const BorderSide(color: Colors.white))),
      ),
    );
  }
}
