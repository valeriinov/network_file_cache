import 'package:flutter_test/flutter_test.dart';
import 'package:network_file_cache/network_file_cache.dart';

void main() {
  group('NetworkCacheConfig Tests', () {
    _networkCacheConfig_should_use_default_values();
    _networkCacheConfig_should_use_custom_values();
  });
}

void _networkCacheConfig_should_use_default_values() {
  test('NetworkCacheConfig should use default values', () {
    // Arrange
    const config = NetworkCacheConfig();

    // Act

    // Assert
    expect(config.key, 'network_file_cache');
    expect(config.stalePeriod, const Duration(days: 30));
    expect(config.maxNrOfCacheObjects, 100);
  });
}

void _networkCacheConfig_should_use_custom_values() {
  test('NetworkCacheConfig should use custom values', () {
    // Arrange
    const config = NetworkCacheConfig(
      key: 'custom',
      stalePeriod: Duration(days: 7),
      maxNrOfCacheObjects: 200,
    );

    // Act

    // Assert
    expect(config.key, 'custom');
    expect(config.stalePeriod, const Duration(days: 7));
    expect(config.maxNrOfCacheObjects, 200);
  });
}
