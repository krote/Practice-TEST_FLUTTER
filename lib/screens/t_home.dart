import 'package:flutter/material.dart';

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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
