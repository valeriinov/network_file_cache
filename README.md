# network_file_cache mono-repo

Transport-agnostic file caching infrastructure for Flutter.

## Packages

- base64_cached_image — ImageProvider built on base64_file_cache
- base64_file_cache — Base64 file cache module
- network_file_cache — core CacheManager API
- network_file_cache_dio — Dio adapter (re-exports core + image provider)
- network_file_cache_http — http adapter (re-exports core + image provider)
- network_cached_image — ImageProvider built on core

## Usage

### base64_cached_image

Single import provides `Base64FileCacheManager`, `Base64CacheConfig`, and `Base64CachedImageProvider`.

```dart
import 'package:base64_cached_image/base64_cached_image.dart';
import 'package:flutter/material.dart';

class Base64Image extends StatelessWidget {
  final String base64Source;
  final base64CacheManager = Base64FileCacheManager();

  Base64Image(this.base64Source, {super.key});

  @override
  Widget build(BuildContext context) {
    return Image(
      image: Base64CachedImageProvider(
        base64Source,
        base64CacheManager: base64CacheManager,
      ),
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.broken_image);
      },
    );
  }
}
```

### network_file_cache_dio

Single import provides `NetworkCacheManager`, `NetworkCacheConfig`, `DioFileService`, and `NetworkCachedImageProvider`.

```dart
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:network_file_cache_dio/network_file_cache_dio.dart';

class DioCachedImage extends StatelessWidget {
  final cacheManager = NetworkCacheManager(
    fileService: DioFileService(Dio()),
  );

  DioCachedImage({super.key});

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

### network_file_cache_http

Single import provides `NetworkCacheManager`, `NetworkCacheConfig`, `HttpFileService`, and `NetworkCachedImageProvider`.

```dart
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:network_file_cache_http/network_file_cache_http.dart';

class HttpCachedImage extends StatelessWidget {
  final cacheManager = NetworkCacheManager(
    fileService: HttpFileService(Client()),
  );

  HttpCachedImage({super.key});

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

## Git Dependencies (Tag 0.1.0)

```yaml
dependencies:
  base64_cached_image:
    git:
      url: https://github.com/valeriinov/network_file_cache
      ref: 0.1.0
      path: packages/base64_cached_image
  network_file_cache_dio:
    git:
      url: https://github.com/valeriinov/network_file_cache
      ref: 0.1.0
      path: packages/network_file_cache_dio
  network_file_cache_http:
    git:
      url: https://github.com/valeriinov/network_file_cache
      ref: 0.1.0
      path: packages/network_file_cache_http
```

## Development

```bash
melos bootstrap
melos format
melos analyze
melos test
```