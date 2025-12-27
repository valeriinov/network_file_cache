import 'dart:io';

import 'package:dio/dio.dart';
import 'package:network_file_cache/network_file_cache.dart';

class DioFileServiceResponse implements FileServiceResponse {
  final Response<List<int>> _response;

  DioFileServiceResponse(this._response);

  @override
  Stream<List<int>> get content {
    return Stream<List<int>>.value(_response.data ?? const <int>[]);
  }

  @override
  int? get contentLength {
    final data = _response.data;
    if (data == null) {
      return null;
    }

    return data.length;
  }

  @override
  int get statusCode {
    return _response.statusCode ?? 500;
  }

  @override
  DateTime get validTill {
    return DateTime.now().add(const Duration(days: 7));
  }

  @override
  String? get eTag {
    return _response.headers.value(HttpHeaders.etagHeader);
  }

  @override
  String get fileExtension {
    final contentType = _response.headers.value(HttpHeaders.contentTypeHeader);
    if (contentType == null) {
      return '';
    }

    final parsedType = ContentType.parse(contentType);

    return '.${parsedType.subType}';
  }
}
