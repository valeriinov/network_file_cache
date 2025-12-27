import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_cached_image/network_cached_image.dart';
import 'package:network_file_cache/network_file_cache.dart';

void main() {
  group('NetworkCachedImageProvider Tests', () {
    _networkCachedImageProvider_should_return_self_from_obtainKey();
    _networkCachedImageProvider_should_compare_equal_for_same_key();
  });
}

void _networkCachedImageProvider_should_return_self_from_obtainKey() {
  test('NetworkCachedImageProvider should return self from obtainKey',
      () async {
    // Arrange
    final cacheManager = _MockCacheManager();
    final provider = NetworkCachedImageProvider(
      'https://example.com/image.png',
      cacheManager: cacheManager,
    );

    // Act
    final key = await provider.obtainKey(const ImageConfiguration());

    // Assert
    expect(identical(key, provider), isTrue);
  });
}

void _networkCachedImageProvider_should_compare_equal_for_same_key() {
  test('NetworkCachedImageProvider should compare equal for same key', () {
    // Arrange
    final cacheManager = _MockCacheManager();
    final first = NetworkCachedImageProvider(
      'https://example.com/image.png',
      cacheManager: cacheManager,
    );
    final second = NetworkCachedImageProvider(
      'https://example.com/image.png',
      cacheManager: cacheManager,
    );

    // Act

    // Assert
    expect(first, equals(second));
    expect(first.hashCode, second.hashCode);
  });
}

class _MockCacheManager extends Mock implements CacheManager {}
