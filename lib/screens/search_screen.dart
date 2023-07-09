import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:test_flutter/models/article.dart';
import 'package:test_flutter/components/article_container.dart';

import 'package:test_flutter/screens/booking_1on1.dart';
import 'package:test_flutter/screens/start1on1_screen.dart';
import 'package:test_flutter/screens/analysis_page.dart';
import 'package:test_flutter/screens/carousel_page.dart';
import 'package:test_flutter/components/dialog_utils.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Article> articles = [];
  String dateValue = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Qiita Search'),
      ),
      // サイドバーを表示する
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.lightBlue),
              child: Text('TestApp'),
            ),
            ListTile(
              title: Text('Booking 1on1'),
              textColor: Colors.black,
              onTap: () {
                // 1on1予約画面へ移動
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: ((context) => Booking1on1Screen()),
                  ),
                );
              },
            ),
            ListTile(
                title: Text('Start 1on1'),
                textColor: Colors.red,
                onTap: () {
                  // 1on1予約画面へ移動
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: ((context) => Start1on1Screen()),
                    ),
                  );
                }),
            ListTile(
                title: Text('Wave Painter'),
                textColor: Colors.red,
                onTap: () {
                  // 1on1予約画面へ移動
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: ((context) => AnalysisPage()),
                    ),
                  );
                }),
            ListTile(
                title: Text('Carousel'),
                textColor: Colors.blue,
                onTap: () {
                  // 1on1予約画面へ移動
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: ((context) => CarouselPage(
                              indicatorColor: Colors.amber,
                              indicatorAlignment: const Alignment(0, 7),
                              pages: [
                                Container(
                                  margin: const EdgeInsets.all(32),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(16),
                                    ),
                                    border: Border.all(),
                                    color: Colors.blue.withOpacity(.2),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'ページ0',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(32),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(16),
                                    ),
                                    border: Border.all(),
                                    color: Colors.pink.withOpacity(.2),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'ページ1',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ])),
                    ),
                  );
                }),
          ],
        ),
      ),
      body: Column(
        children: [
          //
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 36,
            ),
            child: TextField(
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                hintText: '検索ワードを入力してください',
              ),
              onSubmitted: (String value) async {
                debugPrint('qiita search start');
                final results = await searchQiita(value);
                debugPrint('qiita search end : $results');
                setState(() => articles = results);
              },
            ),
          ),
          // カレンダーを表示しっぱなし
          CalendarDatePicker(
            initialDate: DateTime.now(),
            firstDate: DateTime.parse('2023-01-01 00:00:00Z'),
            lastDate: DateTime.parse('2025-01-01 00:00:00Z'),
            onDateChanged: (DateTime value) {
              dateValue = value.toString();
            },
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () async {
                  DialogUtils.showOnlyTitleDialog(context, 'show only');
                },
                child: const Text('タイトルのみ'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final result =
                      await DialogUtils.showEditingDialog(context, dateValue);
                  setState(() {
                    dateValue = result ?? dateValue;
                  });
                },
                child: Text('$dateValue これを編集する'),
              ),
            ],
          ),
          // 検索結果一覧
          Expanded(
            child: ListView(
              children: articles
                  .map((article) => ArticleContainer(article: article))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Article>> searchQiita(String keyword) async {
    // 処理を実装
    final uri = Uri.https('qiita.com', '/api/v2/items', {
      'query': 'title:$keyword',
      'per_page': '10',
    });

    // アクセストークンを取得
    final String token = dotenv.env['QIITA_ACCESS_TOKEN'] ?? '';
    debugPrint('access token is :$token');

    // アクセストークンを含めてリクエストを送信
    final http.Response res = await http.get(uri, headers: {
      'Authorization': 'Bearer $token',
    });

    if (res.statusCode == 200) {
      // モデルクラスへ変換
      final List<dynamic> body = jsonDecode(res.body);
      return body.map((dynamic json) => Article.fromJson(json)).toList();
    } else {
      debugPrint('api call error : $res.statusCode');
      return [];
    }
  }
}
