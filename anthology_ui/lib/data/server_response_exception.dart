import 'package:http/http.dart';

abstract class ServerResponseException implements Exception {
  final Response response;
  final String action;
  final String? id;

  ServerResponseException(this.response, this.action, [this.id]);

  String get entityName;

  @override
  String toString() {
    if (id == null) {
      return 'failed to $action all $entityName. $_serverResponseMessage';
    } else {
      return 'Failed to $action $entityName with id $id. $_serverResponseMessage';
    }
  }

  String get _serverResponseMessage =>
      "Server returned ${response.statusCode}:\n${response.body}";
}
