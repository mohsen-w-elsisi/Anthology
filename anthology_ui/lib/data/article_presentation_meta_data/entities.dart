class ArticlePresentationMetaData {
  final String title;
  final String? image;

  ArticlePresentationMetaData({required this.title, this.image});

  Map<String, dynamic> toJson() => {
    'title': title,
    'image': image,
  };

  factory ArticlePresentationMetaData.fromJson(Map<String, dynamic> json) {
    return ArticlePresentationMetaData(
      title: json['title'] as String,
      image: json['image'] as String?,
    );
  }
}
