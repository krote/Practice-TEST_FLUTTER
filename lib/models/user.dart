

class User {
    User({
        required this.id,
        required this.name,
        required this.profileImageUrl,
    });
    final String name;
    final String id;
    final String profileImageUrl;

    factory User.fromJson(Map<String, dynamic> json){
        return User(
            id: json['id'],
            profileImageUrl: json['profile_image_url'],
            name: json['name'],
        );
    }
}