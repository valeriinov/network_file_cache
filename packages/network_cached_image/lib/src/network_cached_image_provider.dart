import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:network_file_cache/network_file_cache.dart';

class NetworkCachedImageProvider
    extends ImageProvider<NetworkCachedImageProvider> {
  final String url;
  final CacheManager cacheManager;
  final double scale;

  const NetworkCachedImageProvider(
    this.url, {
    required this.cacheManager,
    this.scale = 1.0,
  });

  @override
  Future<NetworkCachedImageProvider> obtainKey(
    ImageConfiguration configuration,
  ) {
    return SynchronousFuture(this);
  }

  @override
  ImageStreamCompleter loadImage(
    NetworkCachedImageProvider key,
    ImageDecoderCallback decode,
  ) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(decode),
      scale: scale,
      informationCollector: () sync* {
        yield ErrorDescription('URL: $url');
      },
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is NetworkCachedImageProvider &&
        other.url == url &&
        other.scale == scale &&
        other.cacheManager == cacheManager;
  }

  @override
  int get hashCode {
    return Object.hash(url, scale, cacheManager);
  }

  Future<Codec> _loadAsync(
    ImageDecoderCallback decode,
  ) async {
    final file = await cacheManager.getSingleFile(url);
    final bytes = await file.readAsBytes();
    final buffer = await ImmutableBuffer.fromUint8List(bytes);

    return decode(buffer);
  }
}
