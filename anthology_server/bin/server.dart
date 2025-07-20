import 'dart:io';

import 'package:alfred/alfred.dart';

void main(List<String> arguments) {
  final alfred = Alfred();

  alfred.get("/api", (req, res) => "hello world");
  alfred.get("/app", (req, res) => File("./public/index.html"));

  alfred.listen();
}
