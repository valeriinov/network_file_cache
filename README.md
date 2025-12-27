# network_file_cache mono-repo

Transport-agnostic file caching infrastructure for Flutter.

## Packages

- network_file_cache — core CacheManager API
- network_file_cache_dio — Dio adapter
- network_file_cache_http — http adapter
- network_cached_image — ImageProvider built on core

## Git Dependencies (Tag 0.0.1)

```yaml
dependencies:
  network_file_cache:
    git:
      url: https://github.com/valeriinov/network_file_cache
      ref: 0.0.1
      path: packages/network_file_cache
  network_file_cache_dio:
    git:
      url: https://github.com/valeriinov/network_file_cache
      ref: 0.0.1
      path: packages/network_file_cache_dio
  network_file_cache_http:
    git:
      url: https://github.com/valeriinov/network_file_cache
      ref: 0.0.1
      path: packages/network_file_cache_http
  network_cached_image:
    git:
      url: https://github.com/valeriinov/network_file_cache
      ref: 0.0.1
      path: packages/network_cached_image
```

## Development

```bash
melos bootstrap
melos format
melos analyze
melos test
```
