import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:test_flutter/models/article.dart';
import 'package:test_flutter/components/article_container.dart';

class SearchScreen extends StatefulWidget {
    const SearchScreen({super.key});

    @override
    State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
    List<Article> articles = [];
    @override
    Widget build(BuildContext context){
        return Scaffold(
            appBar: AppBar(
                title: const Text('Qiita Search'),
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
                                setState(()=>articles = results);
                            },
                        ),
                    ),
                    // 検索結果一覧
                    Expanded(
                        child: ListView(
                            children: articles
                                .map((article)=> ArticleContainer(article:article))
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

        if(res.statusCode == 200){
            // モデルクラスへ変換
            final List<dynamic> body = jsonDecode(res.body);
            return body.map( (dynamic json) => Article.fromJson(json)).toList();
        }else{
            debugPrint('api call error : $res.statusCode');
            return [];
        }
    }
}

