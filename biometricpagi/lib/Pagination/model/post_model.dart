// ignore_for_file: non_constant_identifier_names

class Post {
  final String description;
  final String name;
  final String language;
  final int watchers_count;
  final int open_issues;

  Post(
    this.description,
    this.name,
    this.language,
    this.watchers_count,
    this.open_issues,
  );
}

// class Post {
//   final int userId;
//   final int id;
//   final String title;
//   final String body;
//   Post({
//     required this.userId,
//     required this.id,
//     required this.title,
//     required this.body,
//   });
// }
