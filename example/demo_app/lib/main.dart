import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:network_cached_image/network_cached_image.dart';
import 'package:network_file_cache/network_file_cache.dart';
import 'package:network_file_cache_dio/network_file_cache_dio.dart';

void main() {
  runApp(const DemoApp());
}

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DemoHome(),
    );
  }
}

class DemoHome extends StatelessWidget {
  static const String _imageUrl = 'https://picsum.photos/600';

  final NetworkCacheManager _cacheManager = NetworkCacheManager(
    fileService: DioFileService(Dio()),
  );

  DemoHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Network Cached Image'),
      ),
      body: Center(
        child: Image(
          image: NetworkCachedImageProvider(
            _imageUrl,
            cacheManager: _cacheManager,
          ),
        ),
      ),
    );
  }
}
