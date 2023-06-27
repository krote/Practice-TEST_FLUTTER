import 'package:flutter/material.dart';
import 'package:test_flutter/models/article.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleScreen extends StatelessWidget{
    const ArticleScreen({
        required this.article,
        super.key,
    });

    final Article article;

    @override
    Widget build(BuildContext context){
        return Scaffold(
            appBar: AppBar(
                title: const Text('Article Page'),
            ),
            body: WebView(
                initialUrl: article.url,
            ),
        );
    }
}