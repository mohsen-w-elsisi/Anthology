import 'package:test/test.dart';
import 'package:anthology_common/server_request_interface.dart';

import 'server_tests_setup.dart';
import 'test_requests.dart';

void main() {
  final serverTestsSetup = ServerTestsSetup();

  setUp(serverTestsSetup.setupServer);
  tearDown(serverTestsSetup.tearDown);

  final testRequests = TestRequests(
    ServerRequestInterface(serverTestsSetup.serverUri),
  );

  group("feed CRUD functionallity", () {});
}
