import 'package:base64_file_cache/base64_file_cache.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Base64CacheConfig Tests', () {
    _base64CacheConfig_should_use_default_values();
    _base64CacheConfig_should_use_custom_values();
  });
}

void _base64CacheConfig_should_use_default_values() {
  test('Base64CacheConfig should use default values', () {
    // Arrange
    const config = Base64CacheConfig();

    // Act

    // Assert
    expect(config.maxAge, const Duration(days: 30));
    expect(config.keyPrefix, 'b64');
    expect(config.defaultFileExtension, 'bin');
  });
}

void _base64CacheConfig_should_use_custom_values() {
  test('Base64CacheConfig should use custom values', () {
    // Arrange
    const config = Base64CacheConfig(
      maxAge: Duration(days: 7),
      keyPrefix: 'custom',
      defaultFileExtension: 'jpg',
    );

    // Act

    // Assert
    expect(config.maxAge, const Duration(days: 7));
    expect(config.keyPrefix, 'custom');
    expect(config.defaultFileExtension, 'jpg');
  });
}
