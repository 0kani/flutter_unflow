class Opener {
  final int id;
  final String title;
  final int priority;
  final String subtitle;
  final String imageURL;

  Opener({
    required this.id,
    required this.title,
    required this.priority,
    required this.subtitle,
    required this.imageURL,
  });

  Opener.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        title = data['title'],
        priority = data['priority'],
        subtitle = data['subtitle'],
        imageURL = data['imageURL'];
}
