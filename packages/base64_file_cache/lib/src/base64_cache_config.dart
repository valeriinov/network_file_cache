class Base64CacheConfig {
  final Duration maxAge;
  final String keyPrefix;
  final String defaultFileExtension;

  const Base64CacheConfig({
    this.maxAge = const Duration(days: 30),
    this.keyPrefix = 'b64',
    this.defaultFileExtension = 'bin',
  });
}
