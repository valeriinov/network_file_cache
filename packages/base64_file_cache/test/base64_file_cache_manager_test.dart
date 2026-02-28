import 'dart:convert';
import 'dart:typed_data';

import 'package:base64_file_cache/base64_file_cache.dart';
import 'package:file/memory.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  _setup();

  group('Base64FileCacheManager Tests', () {
    _base64FileCacheManager_should_cache_raw_base64_data();
    _base64FileCacheManager_should_return_cached_file_when_exists();
    _base64FileCacheManager_should_infer_extension_from_data_uri();
    _base64FileCacheManager_should_use_explicit_extension_over_mime();
    _base64FileCacheManager_should_throw_format_exception_for_invalid_base64();
    _base64FileCacheManager_should_remove_cached_file_by_computed_key();
    _base64FileCacheManager_should_return_null_for_invalid_base64_via_try();
  });
}

void _setup() {
  setUpAll(() {
    registerFallbackValue(Uint8List(0));
    registerFallbackValue(Duration.zero);
  });
}

void _base64FileCacheManager_should_cache_raw_base64_data() {
  test('Base64FileCacheManager should cache raw base64 data', () async {
    // Arrange
    final cacheManager = _MockCacheManager();
    final fileSystem = MemoryFileSystem();
    final manager = Base64FileCacheManager(
      cacheManager: cacheManager,
      config: const Base64CacheConfig(
        maxAge: Duration(days: 10),
      ),
    );
    final bytes = <int>[1, 2, 3, 4];
    final source = base64Encode(bytes);

    when(
      () => cacheManager.getFileFromCache(
        any(),
        ignoreMemCache: any(named: 'ignoreMemCache'),
      ),
    ).thenAnswer((_) async => null);

    when(
      () => cacheManager.putFile(
        any(),
        any(),
        key: any(named: 'key'),
        maxAge: any(named: 'maxAge'),
        fileExtension: any(named: 'fileExtension'),
      ),
    ).thenAnswer((invocation) async {
      final fileBytes = invocation.positionalArguments[1] as Uint8List;
      final file = fileSystem.file('/cache/miss.bin');
      await file.create(recursive: true);
      await file.writeAsBytes(fileBytes);
      return file;
    });

    // Act
    final file = await manager.getOrPut(source);

    // Assert
    expect(await file.readAsBytes(), equals(bytes));

    final captured = verify(
      () => cacheManager.putFile(
        any(),
        captureAny(),
        key: captureAny(named: 'key'),
        maxAge: const Duration(days: 10),
        fileExtension: 'bin',
      ),
    ).captured;
    final cachedBytes = captured[0] as Uint8List;
    final cachedKey = captured[1] as String;

    expect(cachedBytes, equals(Uint8List.fromList(bytes)));
    expect(cachedKey.startsWith('b64_'), isTrue);
  });
}

void _base64FileCacheManager_should_return_cached_file_when_exists() {
  test('Base64FileCacheManager should return cached file when exists',
      () async {
    // Arrange
    final cacheManager = _MockCacheManager();
    final manager = Base64FileCacheManager(cacheManager: cacheManager);
    final fileSystem = MemoryFileSystem();
    final file = fileSystem.file('/cache/hit.bin');
    await file.create(recursive: true);
    await file.writeAsBytes(const <int>[9, 8, 7]);
    final cachedFile = FileInfo(
      file,
      FileSource.Cache,
      DateTime.now().add(const Duration(days: 1)),
      'cached-key',
    );

    when(
      () => cacheManager.getFileFromCache(
        any(),
        ignoreMemCache: any(named: 'ignoreMemCache'),
      ),
    ).thenAnswer((_) async => cachedFile);

    // Act
    final result = await manager.getOrPut(base64Encode(<int>[1, 2, 3]));

    // Assert
    expect(result.path, file.path);

    verifyNever(
      () => cacheManager.putFile(
        any(),
        any(),
        key: any(named: 'key'),
        maxAge: any(named: 'maxAge'),
        fileExtension: any(named: 'fileExtension'),
      ),
    );
  });
}

void _base64FileCacheManager_should_infer_extension_from_data_uri() {
  test('Base64FileCacheManager should infer extension from data URI', () async {
    // Arrange
    final cacheManager = _MockCacheManager();
    final manager = Base64FileCacheManager(cacheManager: cacheManager);
    final fileSystem = MemoryFileSystem();
    final source = 'data:image/png;base64,${base64Encode(<int>[5, 6, 7])}';

    when(
      () => cacheManager.getFileFromCache(
        any(),
        ignoreMemCache: any(named: 'ignoreMemCache'),
      ),
    ).thenAnswer((_) async => null);

    when(
      () => cacheManager.putFile(
        any(),
        any(),
        key: any(named: 'key'),
        maxAge: any(named: 'maxAge'),
        fileExtension: any(named: 'fileExtension'),
      ),
    ).thenAnswer((_) async {
      final file = fileSystem.file('/cache/image.png');
      await file.create(recursive: true);
      return file;
    });

    // Act
    await manager.getOrPut(source);

    // Assert
    final captured = verify(
      () => cacheManager.putFile(
        any(),
        any(),
        key: any(named: 'key'),
        maxAge: any(named: 'maxAge'),
        fileExtension: captureAny(named: 'fileExtension'),
      ),
    ).captured;
    final fileExtension = captured.single as String;

    expect(fileExtension, 'png');
  });
}

void _base64FileCacheManager_should_use_explicit_extension_over_mime() {
  test('Base64FileCacheManager should use explicit extension over MIME',
      () async {
    // Arrange
    final cacheManager = _MockCacheManager();
    final manager = Base64FileCacheManager(cacheManager: cacheManager);
    final fileSystem = MemoryFileSystem();
    final source = 'data:image/png;base64,${base64Encode(<int>[7, 8, 9])}';

    when(
      () => cacheManager.getFileFromCache(
        any(),
        ignoreMemCache: any(named: 'ignoreMemCache'),
      ),
    ).thenAnswer((_) async => null);

    when(
      () => cacheManager.putFile(
        any(),
        any(),
        key: any(named: 'key'),
        maxAge: any(named: 'maxAge'),
        fileExtension: any(named: 'fileExtension'),
      ),
    ).thenAnswer((_) async {
      final file = fileSystem.file('/cache/override.jpg');
      await file.create(recursive: true);
      return file;
    });

    // Act
    await manager.getOrPut(source, fileExtension: '.jpg');

    // Assert
    final captured = verify(
      () => cacheManager.putFile(
        any(),
        any(),
        key: any(named: 'key'),
        maxAge: any(named: 'maxAge'),
        fileExtension: captureAny(named: 'fileExtension'),
      ),
    ).captured;
    final fileExtension = captured.single as String;

    expect(fileExtension, 'jpg');
  });
}

void
    _base64FileCacheManager_should_throw_format_exception_for_invalid_base64() {
  test('Base64FileCacheManager should throw FormatException for invalid base64',
      () async {
    // Arrange
    final cacheManager = _MockCacheManager();
    final manager = Base64FileCacheManager(cacheManager: cacheManager);

    when(
      () => cacheManager.getFileFromCache(
        any(),
        ignoreMemCache: any(named: 'ignoreMemCache'),
      ),
    ).thenAnswer((_) async => null);

    // Act
    final action = manager.getOrPut('invalid-%%%');

    // Assert
    await expectLater(action, throwsA(isA<FormatException>()));

    verifyNever(
      () => cacheManager.putFile(
        any(),
        any(),
        key: any(named: 'key'),
        maxAge: any(named: 'maxAge'),
        fileExtension: any(named: 'fileExtension'),
      ),
    );
  });
}

void _base64FileCacheManager_should_remove_cached_file_by_computed_key() {
  test('Base64FileCacheManager should remove cached file by computed key',
      () async {
    // Arrange
    final cacheManager = _MockCacheManager();
    final manager = Base64FileCacheManager(cacheManager: cacheManager);
    final source = base64Encode(<int>[2, 4, 6, 8]);
    final expectedKey = manager.resolveKey(source);

    when(() => cacheManager.removeFile(any())).thenAnswer((_) async {});

    // Act
    await manager.remove(source);

    // Assert
    verify(() => cacheManager.removeFile(expectedKey)).called(1);
  });
}

void _base64FileCacheManager_should_return_null_for_invalid_base64_via_try() {
  test(
      'Base64FileCacheManager should return null for invalid base64 via tryGetOrPut',
      () async {
    // Arrange
    final cacheManager = _MockCacheManager();
    final manager = Base64FileCacheManager(cacheManager: cacheManager);

    when(
      () => cacheManager.getFileFromCache(
        any(),
        ignoreMemCache: any(named: 'ignoreMemCache'),
      ),
    ).thenAnswer((_) async => null);

    // Act
    final result = await manager.tryGetOrPut('invalid-%%%');

    // Assert
    expect(result, isNull);

    verifyNever(
      () => cacheManager.putFile(
        any(),
        any(),
        key: any(named: 'key'),
        maxAge: any(named: 'maxAge'),
        fileExtension: any(named: 'fileExtension'),
      ),
    );
  });
}

class _MockCacheManager extends Mock implements CacheManager {}
