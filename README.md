# network_file_cache mono-repo

Transport-agnostic file caching infrastructure for Flutter.

## Packages

- network_file_cache — core CacheManager API
- network_file_cache_dio — Dio adapter
- network_file_cache_http — http adapter
- network_cached_image — ImageProvider built on core

## Usage

### network_file_cache

```dart
import 'package:network_file_cache/network_file_cache.dart';

Future<void> preloadFile(FileService fileService) async {
  final cacheManager = NetworkCacheManager(
    fileService: fileService,
    config: const NetworkCacheConfig(
      stalePeriod: Duration(days: 7),
      maxNrOfCacheObjects: 200,
    ),
  );

  await cacheManager.getSingleFile('https://example.com/image.jpg');
}
```

### network_file_cache_dio

```dart
import 'package:dio/dio.dart';
import 'package:network_file_cache/network_file_cache.dart';
import 'package:network_file_cache_dio/network_file_cache_dio.dart';

Future<void> preloadWithDio() async {
  final cacheManager = NetworkCacheManager(
    fileService: DioFileService(Dio()),
  );

  await cacheManager.getSingleFile('https://example.com/image.jpg');
}
```

### network_file_cache_http

```dart
import 'package:http/http.dart';
import 'package:network_file_cache/network_file_cache.dart';
import 'package:network_file_cache_http/network_file_cache_http.dart';

Future<void> preloadWithHttp() async {
  final cacheManager = NetworkCacheManager(
    fileService: HttpFileService(Client()),
  );

  await cacheManager.getSingleFile('https://example.com/image.jpg');
}
```

### network_cached_image

```dart
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:network_cached_image/network_cached_image.dart';
import 'package:network_file_cache/network_file_cache.dart';
import 'package:network_file_cache_http/network_file_cache_http.dart';

class CachedImage extends StatelessWidget {
  final cacheManager = NetworkCacheManager(
    fileService: HttpFileService(Client()),
  );

  CachedImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Image(
      image: NetworkCachedImageProvider(
        'https://picsum.photos/600',
        cacheManager: cacheManager,
      ),
    );
  }
}
```

### cached_network_image with Dio

```dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:network_file_cache/network_file_cache.dart';
import 'package:network_file_cache_dio/network_file_cache_dio.dart';

class DioCachedImage extends StatelessWidget {
  final cacheManager = NetworkCacheManager(
    fileService: DioFileService(Dio()),
  );

  DioCachedImage({super.key});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: 'https://picsum.photos/600',
      cacheManager: cacheManager,
    );
  }
}
```

### cached_network_image with http

```dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:network_file_cache/network_file_cache.dart';
import 'package:network_file_cache_http/network_file_cache_http.dart';

class HttpCachedImage extends StatelessWidget {
  final cacheManager = NetworkCacheManager(
    fileService: HttpFileService(Client()),
  );

  HttpCachedImage({super.key});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: 'https://picsum.photos/600',
      cacheManager: cacheManager,
    );
  }
}
```

## Git Dependencies (Tag 0.0.2)

```yaml
dependencies:
  network_file_cache:
    git:
      url: https://github.com/valeriinov/network_file_cache
      ref: 0.0.2
      path: packages/network_file_cache
  network_file_cache_dio:
    git:
      url: https://github.com/valeriinov/network_file_cache
      ref: 0.0.2
      path: packages/network_file_cache_dio
  network_file_cache_http:
    git:
      url: https://github.com/valeriinov/network_file_cache
      ref: 0.0.2
      path: packages/network_file_cache_http
  network_cached_image:
    git:
      url: https://github.com/valeriinov/network_file_cache
      ref: 0.0.2
      path: packages/network_cached_image
```

## Development

```bash
melos bootstrap
melos format
melos analyze
melos test
```
