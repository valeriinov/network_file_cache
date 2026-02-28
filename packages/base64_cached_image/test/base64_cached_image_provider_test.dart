import 'package:base64_cached_image/base64_cached_image.dart';
import 'package:base64_file_cache/base64_file_cache.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  group('Base64CachedImageProvider Tests', () {
    _base64CachedImageProvider_should_return_self_from_obtainKey();
    _base64CachedImageProvider_should_compare_equal_for_same_params();
  });
}

void _base64CachedImageProvider_should_return_self_from_obtainKey() {
  test('Base64CachedImageProvider should return self from obtainKey', () async {
    // Arrange
    final base64CacheManager = _MockBase64FileCacheManager();

    when(() => base64CacheManager.tryResolveKey(any(), key: any(named: 'key')))
        .thenReturn('resolved-key');

    final provider = Base64CachedImageProvider(
      'dGVzdA==',
      base64CacheManager: base64CacheManager,
    );

    // Act
    final key = await provider.obtainKey(const ImageConfiguration());

    // Assert
    expect(identical(key, provider), isTrue);
  });
}

void _base64CachedImageProvider_should_compare_equal_for_same_params() {
  test('Base64CachedImageProvider should compare equal for same params', () {
    // Arrange
    final base64CacheManager = _MockBase64FileCacheManager();

    when(() => base64CacheManager.tryResolveKey(any(), key: any(named: 'key')))
        .thenReturn('resolved-key');

    final first = Base64CachedImageProvider(
      'dGVzdA==',
      base64CacheManager: base64CacheManager,
    );
    final second = Base64CachedImageProvider(
      'dGVzdA==',
      base64CacheManager: base64CacheManager,
    );

    // Act

    // Assert
    expect(first, equals(second));
    expect(first.hashCode, second.hashCode);
  });
}

class _MockBase64FileCacheManager extends Mock
    implements Base64FileCacheManager {}
