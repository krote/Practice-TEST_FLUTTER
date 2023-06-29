import 'package:flutter/material.dart';

class Booking1on1Screen extends StatefulWidget{
    const Booking1on1Screen({super.key});

    @override
    State<Booking1on1Screen> createState() => _Booking1on1Screen();
}

class _Booking1on1Screen extends State<Booking1on1Screen> {
    @override
    Widget build(BuildContext context){
        return Scaffold(
            appBar: AppBar(
                title: const Text('Qiita Search'),
            ),
            body: Column(
                children: [
                    Row(
                        children:[
                            Text(
                                "名前:",
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                ),
                            ),
                            SizedBox(
                                width: 200,
                                // Rowの直下にTextFieldを置くと、Widthの指定がなくエラーとなる
                                // An InputDecorator, which is typically created by a TextField, cannot have an unbounded width.
                                // SizedBoxなどの配下でwidthを指定する
                                child: TextField(
                                    decoration: InputDecoration(
                                        hintText: '面談者を入力してください',
                                    ),
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                    ),
                                ),
                            ),
                        ]
                    ),
                    Row(
                        children:[
                            Text(
                                "面談日時:",
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                ),
                            ),
                            SizedBox(
                                width:200,
                                child: TextField(
                                    decoration: InputDecoration(
                                        hintText: '面談者を入力してください',
                                    ),
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                    ),
                                ),
                            ),
                        ]
                    ),
                    Row(
                        children: [
                            SizedBox(
                                width: 100,
                                child: Text(
                                    "面談内容",
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                    ),
                                ),
                            ),
                        ]
                    ),
                    Row(
                        children: [
                            SizedBox(
                                width:300,
                                child: TextField(
                                    maxLines: 5,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                    ),
                                ),
                            ),
                        ]
                    ),
                    BackButton(),
                ],
            ),
        );
    }

}