import 'package:flutter/material.dart';

import 'package:test_flutter/components/t_home_menu.dart';

class THomePage extends StatefulWidget {
  const THomePage({Key? key}) : super(key: key);

  @override
  State<THomePage> createState() => _THomePageState();
}

class _THomePageState extends State<THomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HOME'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // 仮置き
            },
          ),
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => {
              //
            },
          ),
        ],
      ),
      body: Column(
        children: [
          TextFormField(),
          Container(
            child: Column(
              children: [
                const Text("パーソナル"),
                Row(
                  children: [
                    Icon(Icons.wind_power),
                    Icon(Icons.light),
                  ],
                ),
                const Text("共通"),
                GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                  shrinkWrap: true,
                  children: [
                    THomeMenuTile(menuID: 'Menu1'),
                    THomeMenuTile(menuID: 'Menu2'),
                    THomeMenuTile(menuID: 'Menu3'),
                    THomeMenuTile(menuID: 'Menu4'),
                    THomeMenuTile(menuID: 'Menu5'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
