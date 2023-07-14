import 'package:flutter/material.dart';

class THomeMenuTile extends StatelessWidget {
  const THomeMenuTile({
    Key? key,
    required this.menuID,
  }) : super(key: key);

  final String menuID;

  final Map<String, Map<String, String>> homeMenu = const {
    '01': {'title': 'メニュー1', 'message': 'hello'},
    '02': {'title': 'メニュー2', 'message': 'hi'},
    '03': {'title': 'メニュー3', 'message': 'goood'},
    '04': {'title': 'メニュー4', 'message': 'morning'},
    '05': {'title': 'メニュー5', 'message': 'evening'}
  };

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
            child: Text(getMenuTitle(menuID)),
          ),
          child: GestureDetector(
            onTap: () {
              //
            },
            child: Icon(Icons.map),
          )),
    );
  }

  String getMenuTitle(String menuId) {
    final Map<String, String> menuDetail =
        homeMenu[menuId] ?? {'title': 'nothing'};
    final String title = menuDetail['title'] ?? '';
    return title;
  }
}
