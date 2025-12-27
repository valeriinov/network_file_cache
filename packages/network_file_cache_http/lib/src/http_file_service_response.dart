import 'dart:io';

import 'package:http/http.dart';
import 'package:network_file_cache/network_file_cache.dart';

class HttpFileServiceResponse implements FileServiceResponse {
  final Response _response;

  HttpFileServiceResponse(this._response);

  @override
  Stream<List<int>> get content {
    return Stream<List<int>>.value(_response.bodyBytes);
  }

  @override
  int? get contentLength {
    return _response.bodyBytes.length;
  }

  @override
  int get statusCode {
    return _response.statusCode;
  }

  @override
  DateTime get validTill {
    return DateTime.now().add(const Duration(days: 7));
  }

  @override
  String? get eTag {
    return _response.headers[HttpHeaders.etagHeader];
  }

  @override
  String get fileExtension {
    final contentType = _response.headers[HttpHeaders.contentTypeHeader];
    if (contentType == null) {
      return '';
    }

    final parsedType = ContentType.parse(contentType);

    return '.${parsedType.subType}';
  }
}
