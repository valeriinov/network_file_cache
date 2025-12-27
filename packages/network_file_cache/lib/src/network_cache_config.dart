class NetworkCacheConfig {
  final String key;
  final Duration stalePeriod;
  final int maxNrOfCacheObjects;

  const NetworkCacheConfig({
    this.key = 'network_file_cache',
    this.stalePeriod = const Duration(days: 30),
    this.maxNrOfCacheObjects = 100,
  });
}
