class ContentItem {
  final String id;
  final String title;
  final String url;
  final String type; // "video" or "pdf"

  ContentItem({required this.id, required this.title, required this.url, required this.type});

  factory ContentItem.fromMap(Map<String, dynamic> map, String id) {
    return ContentItem(
      id: id,
      title: map['title'],
      url: map['url'],
      type: map['type'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'url': url,
      'type': type,
    };
  }
}