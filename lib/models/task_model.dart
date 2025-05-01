class Task {
  final String title;
  final String content;

  Task({required this.title, required this.content});
  Map<String, dynamic> toJson() => {
    'title': title,
    'content': content,
  };
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'] ?? '',
      content: json['content'] ?? '',
    );
  }
}
