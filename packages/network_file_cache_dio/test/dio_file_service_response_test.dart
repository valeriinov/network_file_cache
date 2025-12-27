import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_file_cache_dio/src/dio_file_service_response.dart';

void main() {
  group('DioFileServiceResponse Tests', () {
    _dioFileServiceResponse_should_map_response();
  });
}

void _dioFileServiceResponse_should_map_response() {
  test('DioFileServiceResponse should map response data', () async {
    // Arrange
    final response = Response<List<int>>(
      data: [1, 2, 3],
      statusCode: 201,
      requestOptions: RequestOptions(path: '/'),
      headers: Headers.fromMap({
        'content-type': ['image/png'],
        'etag': ['test-etag'],
      }),
    );

    final fileResponse = DioFileServiceResponse(response);

    // Act
    final chunks = await fileResponse.content.toList();

    // Assert
    expect(fileResponse.statusCode, 201);
    expect(fileResponse.contentLength, 3);
    expect(fileResponse.eTag, 'test-etag');
    expect(fileResponse.fileExtension, '.png');
    expect(chunks.single, equals([1, 2, 3]));
  });
}
