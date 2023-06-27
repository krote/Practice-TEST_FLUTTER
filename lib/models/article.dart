import 'package:test_flutter/models/user.dart';


class  Article {
    Article({
        required this.title,
        required this.user,
        required this.url,
        required this.createdAt,
        this.likesCount = 0,
        this.tags = const [],
    });
    final String title;
    final User user;
    final String url;
    final DateTime createdAt;
    final int likesCount;
    final List<String> tags;

    factory Article.fromJson(Map<String, dynamic> json){
        return Article(
            title: json['title'],
            user: User.fromJson(json['user']),
            url: json['url'],
            createdAt: DateTime.parse(json['created_at'].toString()),
            likesCount: json['likes_count'],
            tags: List<String>.from(json['tags'].map((tag) => tag['name'])),
        );
    }
}