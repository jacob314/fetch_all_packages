import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fake_http/okhttp3/cache.dart';
import 'package:fake_http/okhttp3/internal/io/file_system.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';

class DiskCache implements RawCache {
  final FileSystem _fileSystem;
  final AsyncValueGetter<Directory> _directory;
  final int _valueCount;

  DiskCache._(FileSystem fileSystem, AsyncValueGetter<Directory> directory, int valueCount)
      : _fileSystem = fileSystem,
        _directory = directory,
        _valueCount = valueCount;

  @override
  Future<Editor> edit(String key,
      {int expectedSequenceNumber: RawCache.ANY_SEQUENCE_NUMBER}) async {
    _Entry entry = new _Entry(await _directory(), _valueCount, key);
    return entry.editor(_fileSystem);
  }

  @override
  Future<Snapshot> get(String key) async {
    _Entry entry = new _Entry(await _directory(), _valueCount, key);
    return entry.snapshot(_fileSystem);
  }

  @override
  Future<bool> remove(String key) async {
    _Entry entry = new _Entry(await _directory(), _valueCount, key);
    return await entry.remove(_fileSystem);
  }

  static DiskCache create(AsyncValueGetter<Directory> directory,
      {FileSystem fileSystem: FileSystem.SYSTEM}) {
    assert(directory != null);
    assert(fileSystem != null);
    return new DiskCache._(fileSystem, directory, Cache.ENTRY_COUNT);
  }
}

class _Entry {
  final String _key;
  final List<File> _cacheFiles;

  _Entry(Directory directory, int valueCount, String key)
      : _key = key,
        _cacheFiles = new List.generate(valueCount, (int index) {
          return new File(join(directory.path, '$key.$index'));
        });

  String key() {
    return _key;
  }

  List<File> cacheFiles() {
    return _cacheFiles;
  }

  Editor editor(FileSystem fileSystem) {
    return new _EditorImpl(fileSystem, this);
  }

  Snapshot snapshot(FileSystem fileSystem) {
    List<Stream<List<int>>> sources = _cacheFiles.map((File cacheFile) {
      return fileSystem.source(cacheFile);
    }).toList();
    List<int> lengths = _cacheFiles.map((File cacheFile) {
      return fileSystem.size(cacheFile);
    }).toList();
    return new Snapshot(_key, RawCache.ANY_SEQUENCE_NUMBER, sources, lengths);
  }

  Future<bool> remove(FileSystem fileSystem) async {
    for (File cacheFile in _cacheFiles) {
      if (fileSystem.exists(cacheFile)) {
        fileSystem.delete(cacheFile);
      }
    }
    return true;
  }
}

class _EditorImpl implements Editor {
  final FileSystem _fileSystem;
  final List<File> _cleanFiles;
  final List<File> _dirtyFiles;

  bool _done = false;

  _EditorImpl(FileSystem fileSystem, _Entry entry)
      : _fileSystem = fileSystem,
        _cleanFiles = entry.cacheFiles(),
        _dirtyFiles = entry.cacheFiles().map((File cacheFile) {
          return new File('${cacheFile.path}.${new DateTime.now().millisecondsSinceEpoch}');
        }).toList();

  @override
  StreamSink<List<int>> newSink(int index, Encoding encoding) {
    if (_done) {
      throw new AssertionError();
    }
    File dirtyFile = _dirtyFiles[index];
    if (_fileSystem.exists(dirtyFile)) {
      _fileSystem.delete(dirtyFile);
    }
    _fileSystem.createFile(dirtyFile);
    return _fileSystem.sink(dirtyFile, encoding: encoding);
  }

  @override
  Stream<List<int>> newSource(int index, Encoding encoding) {
    if (!_done) {
      throw new AssertionError();
    }
    File cleanFile = _cleanFiles[index];
    if (!_fileSystem.exists(cleanFile)) {
      throw new AssertionError('cleanFile is not exists.');
    }
    return _fileSystem.source(cleanFile);
  }

  @override
  void commit() {
    if (_done) {
      throw new AssertionError();
    }
    _complete(true);
    _done = true;
  }

  @override
  void abort() {
    if (_done) {
      throw new AssertionError();
    }
    _complete(false);
    _done = true;
  }

  @override
  void detach() {
    for (File dirtyFile in _dirtyFiles) {
      if (_fileSystem.exists(dirtyFile)) {
        _fileSystem.delete(dirtyFile);
      }
    }
  }

  void _complete(bool success) {
    if (success) {
      for (int i = 0; i < _dirtyFiles.length; i ++) {
        File dirtyFile = _dirtyFiles[i];
        if (_fileSystem.exists(dirtyFile)) {
          File cleanFile = _cleanFiles[i];
//          print('${dirtyFile.path} - ${cleanFile.path}');
          _fileSystem.rename(dirtyFile, cleanFile);
        }
      }
    } else {
      detach();
    }
  }
}
