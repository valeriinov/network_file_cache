import 'package:dio/dio.dart';
import 'package:network_file_cache/network_file_cache.dart';

import 'dio_file_service_response.dart';

class DioFileService extends FileService {
  final Dio _dio;

  DioFileService(this._dio);

  @override
  Future<FileServiceResponse> get(
    String url, {
    Map<String, String>? headers,
  }) async {
    final response = await _dio.get<List<int>>(
      url,
      options: Options(
        responseType: ResponseType.bytes,
        headers: headers,
      ),
    );

    return DioFileServiceResponse(response);
  }
}
