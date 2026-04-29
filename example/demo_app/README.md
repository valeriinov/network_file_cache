# demo_app

Example app for the network_file_cache mono-repo.

## Dependencies (Tag 0.1.1)

This example uses git dependencies from the monorepo:

```yaml
dependencies:
  network_file_cache:
    git:
      url: https://github.com/valeriinov/network_file_cache
      ref: 0.1.1
      path: packages/network_file_cache
  network_file_cache_dio:
    git:
      url: https://github.com/valeriinov/network_file_cache
      ref: 0.1.1
      path: packages/network_file_cache_dio
  network_cached_image:
    git:
      url: https://github.com/valeriinov/network_file_cache
      ref: 0.1.1
      path: packages/network_cached_image
```

## Run

```bash
flutter pub get
flutter run
```
