import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'base64_cache_config.dart';

class Base64FileCacheManager {
  static const String _cacheKey = 'base64_file_cache';

  final CacheManager _cacheManager;
  final Base64CacheConfig _config;

  Base64FileCacheManager({
    Base64CacheConfig config = const Base64CacheConfig(),
    CacheManager? cacheManager,
  })  : _config = config,
        _cacheManager = cacheManager ??
            CacheManager(
              Config(
                _cacheKey,
                fileService: _NoopFileService(),
              ),
            );

  Future<File?> tryGetOrPut(
    String source, {
    String? key,
    String? fileExtension,
  }) async {
    try {
      return await getOrPut(source, key: key, fileExtension: fileExtension);
    } catch (_) {
      return null;
    }
  }

  Future<File> getOrPut(
    String source, {
    String? key,
    String? fileExtension,
  }) async {
    final normalizedSource = _normalizeSource(source);
    final effectiveKey = _effectiveKey(
      key: key,
      payload: normalizedSource.payload,
    );

    final cachedFile = await _cacheManager.getFileFromCache(effectiveKey);

    if (cachedFile != null) {
      return cachedFile.file;
    }

    final bytes = base64Decode(normalizedSource.payload);
    final effectiveExtension = _resolveFileExtension(
      explicitFileExtension: fileExtension,
      mimeType: normalizedSource.mimeType,
    );

    return _cacheManager.putFile(
      effectiveKey,
      bytes,
      key: effectiveKey,
      maxAge: _config.maxAge,
      fileExtension: effectiveExtension,
    );
  }

  Future<void> remove(
    String source, {
    String? key,
  }) {
    final effectiveKey = resolveKey(source, key: key);

    return _cacheManager.removeFile(effectiveKey);
  }

  String? tryResolveKey(
    String source, {
    String? key,
  }) {
    try {
      return resolveKey(source, key: key);
    } catch (_) {
      return null;
    }
  }

  String resolveKey(
    String source, {
    String? key,
  }) {
    if (key != null && key.trim().isNotEmpty) {
      return key;
    }

    final normalizedSource = _normalizeSource(source);

    return _createHashedKey(normalizedSource.payload);
  }

  _NormalizedSource _normalizeSource(String source) {
    final trimmedSource = source.trim();

    if (trimmedSource.startsWith('data:')) {
      return _parseDataUri(trimmedSource);
    }

    return _NormalizedSource(
      payload: trimmedSource.replaceAll(RegExp(r'\s+'), ''),
    );
  }

  _NormalizedSource _parseDataUri(String source) {
    final commaIndex = source.indexOf(',');

    if (commaIndex < 0) {
      throw const FormatException('Invalid data URI format.');
    }

    final metadata = source.substring(5, commaIndex);

    if (!_hasBase64Marker(metadata)) {
      throw const FormatException(
        'Only base64 data URI format is supported.',
      );
    }

    final payload = source.substring(commaIndex + 1);
    final mimeType = _extractMimeType(metadata);

    return _NormalizedSource(
      payload: payload.replaceAll(RegExp(r'\s+'), ''),
      mimeType: mimeType,
    );
  }

  bool _hasBase64Marker(String metadata) {
    final parts = metadata
        .split(';')
        .map((part) => part.trim().toLowerCase())
        .where((part) => part.isNotEmpty)
        .toList();

    return parts.contains('base64');
  }

  String? _extractMimeType(String metadata) {
    final semicolonIndex = metadata.indexOf(';');

    if (semicolonIndex <= 0) {
      return null;
    }

    final mimeType = metadata.substring(0, semicolonIndex).trim().toLowerCase();

    return mimeType.isEmpty ? null : mimeType;
  }

  String _resolveFileExtension({
    required String? explicitFileExtension,
    required String? mimeType,
  }) {
    return _normalizeExtension(explicitFileExtension) ??
        _extensionFromMimeType(mimeType) ??
        _normalizeExtension(_config.defaultFileExtension) ??
        'bin';
  }

  String? _extensionFromMimeType(String? mimeType) {
    if (mimeType == null) {
      return null;
    }

    return switch (mimeType.split('/')) {
      [_, final subtype] when subtype.isNotEmpty =>
        _normalizeExtension(subtype.split('+').first),
      _ => null,
    };
  }

  String? _normalizeExtension(String? value) {
    if (value == null) {
      return null;
    }

    final normalized =
        value.trim().toLowerCase().replaceFirst(RegExp(r'^\.'), '');

    return normalized.isEmpty ? null : normalized;
  }

  String _effectiveKey({
    required String? key,
    required String payload,
  }) {
    if (key != null && key.trim().isNotEmpty) {
      return key;
    }

    return _createHashedKey(payload);
  }

  String _createHashedKey(String payload) {
    final payloadHash = sha256.convert(utf8.encode(payload)).toString();
    final prefix = _config.keyPrefix.trim();

    return '${prefix}_$payloadHash';
  }
}

class _NormalizedSource {
  final String payload;
  final String? mimeType;

  const _NormalizedSource({
    required this.payload,
    this.mimeType,
  });
}

class _NoopFileService extends FileService {
  @override
  Future<FileServiceResponse> get(
    String url, {
    Map<String, String>? headers,
  }) async {
    throw UnsupportedError('Network fetch is not supported for base64 cache.');
  }
}
