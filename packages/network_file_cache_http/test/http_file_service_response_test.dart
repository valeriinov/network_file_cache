import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:network_file_cache_http/src/http_file_service_response.dart';

void main() {
  group('HttpFileServiceResponse Tests', () {
    _httpFileServiceResponse_should_map_response();
  });
}

void _httpFileServiceResponse_should_map_response() {
  test('HttpFileServiceResponse should map response data', () async {
    // Arrange
    final response = Response.bytes(
      [4, 5, 6],
      202,
      headers: {
        'content-type': 'image/jpeg',
        'etag': 'test-etag',
      },
    );

    final fileResponse = HttpFileServiceResponse(response);

    // Act
    final chunks = await fileResponse.content.toList();

    // Assert
    expect(fileResponse.statusCode, 202);
    expect(fileResponse.contentLength, 3);
    expect(fileResponse.eTag, 'test-etag');
    expect(fileResponse.fileExtension, '.jpeg');
    expect(chunks.single, equals([4, 5, 6]));
  });
}
