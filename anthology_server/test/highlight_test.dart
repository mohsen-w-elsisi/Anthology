import 'dart:convert';

import 'package:anthology_common/errors.dart';
import 'package:anthology_common/highlight/data_gateway.dart';
import 'package:anthology_common/highlight/entities.dart';
import 'package:anthology_common/shared_impls/local_highlight_data_gateway.dart';
import 'package:anthology_common/server_request_interface.dart';
import 'package:get_it/get_it.dart';
import 'package:test/test.dart';

import 'server_tests_setup.dart';
import 'test_requests.dart';

void main() {
  final serverTestsSetup = ServerTestsSetup(
    highlightDataGaetway: LocalHighlightDataGateway(
      "./test-db/highlights.json",
    ),
  );

  setUp(serverTestsSetup.setupServer);
  tearDown(serverTestsSetup.tearDown);

  final testRequests = TestRequests(
    ServerRequestInterface(serverTestsSetup.serverUri),
  );

  group("highlights CRUD functionallity", () {
    test('saving highlights', () async {
      final res = await testRequests.saveHighlight1();
      expect(res.statusCode, 200);
      await GetIt.I<HighlightDataGateway>().get(ExampleData.highlight1.id);
    });

    test('getting accurate highlights', () async {
      await testRequests.saveHighlight1();
      final res = await testRequests.getHighlight1();
      expect(res.statusCode, 200);
      final highlight = Highlight.fromJson(jsonDecode(res.body));
      expect(
        jsonEncode(highlight.toJson()),
        jsonEncode(ExampleData.highlight1.toJson()),
      );
    });

    test('deleting highlights', () async {
      await testRequests.saveHighlight1();
      await testRequests.saveHighlight2();
      final res = await testRequests.deleteHighlight1();
      expect(res.statusCode, 200);
      expect(
        GetIt.I<HighlightDataGateway>().get(ExampleData.highlight1.id),
        throwsA(isA<HighlightNotFoundError>()),
      );
      expect(
        GetIt.I<HighlightDataGateway>().get(ExampleData.highlight2.id),
        completes,
      );
    });

    test('getting highlights for an article', () async {
      await testRequests.saveHighlight1();
      await testRequests.saveHighlight2();
      await testRequests.saveHighlight3();
      final res = await testRequests.getHighlightsForArticle1();
      expect(res.statusCode, 200);
      final highlights = jsonDecode(res.body);
      expect(highlights.length, 2);
      final highlight = Highlight.fromJson(highlights[0]);
      expect(highlight.id, ExampleData.highlight1.id);
    });

    test("getting higlights for all articles", () async {
      await testRequests.saveHighlight1();
      await testRequests.saveHighlight3();
      final res = await testRequests.serverRequestInterface.getAllHighlights();
      expect(res.statusCode, 200);
      final json = jsonDecode(res.body);
      expect(json.length, 2);
    });

    test("getting all highlights sorts them correctly", () async {
      await testRequests.saveHighlight1();
      await testRequests.saveHighlight3();
      final res = await testRequests.serverRequestInterface.getAllHighlights();
      final json = (jsonDecode(res.body) as Map).cast<String, List>();
      final parsedList = {
        for (MapEntry<String, List> entry in json.entries)
          entry.key: [
            for (final highlightJson in entry.value)
              Highlight.fromJson(highlightJson),
          ],
      };
      expect(
        parsedList[ExampleData.article1.id]?.first.id,
        ExampleData.highlight1.id,
      );
      expect(
        parsedList[ExampleData.article2.id]?.first.id,
        ExampleData.highlight3.id,
      );
    });
  });
}
