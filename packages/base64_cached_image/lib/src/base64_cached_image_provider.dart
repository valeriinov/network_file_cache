import 'dart:ui';

import 'package:base64_file_cache/base64_file_cache.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

class Base64CachedImageProvider
    extends ImageProvider<Base64CachedImageProvider> {
  final Base64FileCacheManager base64CacheManager;
  final double scale;
  final String _source;
  final String? _key;
  final String? _fileExtension;
  final String _resolvedKey;

  Base64CachedImageProvider(
    String source, {
    required this.base64CacheManager,
    String? key,
    String? fileExtension,
    this.scale = 1.0,
  })  : _source = source,
        _key = key,
        _fileExtension = fileExtension,
        _resolvedKey =
            base64CacheManager.tryResolveKey(source, key: key) ?? source;

  @override
  Future<Base64CachedImageProvider> obtainKey(
    ImageConfiguration configuration,
  ) {
    return SynchronousFuture(this);
  }

  @override
  ImageStreamCompleter loadImage(
    Base64CachedImageProvider key,
    ImageDecoderCallback decode,
  ) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(decode),
      scale: scale,
      informationCollector: () sync* {
        yield ErrorDescription('Base64 source key: $_resolvedKey');
      },
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is Base64CachedImageProvider &&
        other._resolvedKey == _resolvedKey &&
        other.scale == scale;
  }

  @override
  int get hashCode {
    return Object.hash(_resolvedKey, scale);
  }

  Future<Codec> _loadAsync(ImageDecoderCallback decode) async {
    final file = await base64CacheManager.getOrPut(
      _source,
      key: _key,
      fileExtension: _fileExtension,
    );
    final bytes = await file.readAsBytes();
    final buffer = await ImmutableBuffer.fromUint8List(bytes);

    return decode(buffer);
  }
}
