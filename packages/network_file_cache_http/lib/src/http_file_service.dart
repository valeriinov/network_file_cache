import 'package:http/http.dart';
import 'package:network_file_cache/network_file_cache.dart';

import 'http_file_service_response.dart';

class HttpFileService extends FileService {
  final Client _client;

  HttpFileService(this._client);

  @override
  Future<FileServiceResponse> get(
    String url, {
    Map<String, String>? headers,
  }) async {
    final response = await _client.get(
      Uri.parse(url),
      headers: headers,
    );

    return HttpFileServiceResponse(response);
  }
}
