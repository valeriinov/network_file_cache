import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'network_cache_config.dart';

class NetworkCacheManager extends CacheManager {
  NetworkCacheManager({
    required FileService fileService,
    NetworkCacheConfig config = const NetworkCacheConfig(),
  }) : super(
          Config(
            config.key,
            stalePeriod: config.stalePeriod,
            maxNrOfCacheObjects: config.maxNrOfCacheObjects,
            fileService: fileService,
          ),
        );
}
