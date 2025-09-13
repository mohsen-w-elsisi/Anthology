class ReaderViewTextOptions {
  final double textScaleFactor;

  const ReaderViewTextOptions({this.textScaleFactor = 1.0});

  Map<String, dynamic> toJson() => {
    'textScaleFactor': textScaleFactor,
  };

  factory ReaderViewTextOptions.fromJson(Map<String, dynamic> json) =>
      ReaderViewTextOptions(
        textScaleFactor: json['textScaleFactor']?.toDouble() ?? 1.0,
      );
}
