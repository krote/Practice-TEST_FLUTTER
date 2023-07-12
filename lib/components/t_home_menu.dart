import 'package:flutter/material.dart';

class THomeMenuTile extends StatelessWidget {
  const THomeMenuTile({
    Key? key,
    required this.menuID,
  }) : super(key: key);

  final String menuID;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Colors.amber,
      ),
      child: GridTile(
        footer: Center(
          child: Text('${menuID}'),
        ),
        child: Icon(Icons.map),
      ),
    );
  }
}
