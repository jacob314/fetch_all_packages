import 'dart:async';
import 'dart:convert';
import 'dart:io';

abstract class FileSystem {
  static const FileSystem SYSTEM = _FileSystemImpl();

  void createFile(File file);

  bool exists(FileSystemEntity entity);

  int size(File file);

  Stream<List<int>> source(File file);

  StreamSink<List<int>> sink(File file, {Encoding encoding: utf8});

  StreamSink<List<int>> appendingSink(File file, {Encoding encoding: utf8});

  void delete(FileSystemEntity entity);

  File rename(File from, File to);

  void deleteContents(Directory directory);
}

class _FileSystemImpl implements FileSystem {
  const _FileSystemImpl();

  @override
  void createFile(File file) {
    file.createSync(recursive: true);
  }

  @override
  bool exists(FileSystemEntity entity) {
    return entity.existsSync();
  }

  @override
  int size(File file) {
    return file.lengthSync();
  }

  @override
  Stream<List<int>> source(File file) {
    return file.openRead();
  }

  @override
  StreamSink<List<int>> sink(File file, {Encoding encoding = utf8}) {
    return file.openWrite(mode: FileMode.write, encoding: utf8);
  }

  @override
  StreamSink<List<int>> appendingSink(File file, {Encoding encoding: utf8}) {
    return file.openWrite(mode: FileMode.append, encoding: encoding);
  }

  @override
  void delete(FileSystemEntity entity) {
    entity.deleteSync();
  }

  @override
  File rename(File from, File to) {
    if (exists(to)) {
      delete(to);
    }
    return from.renameSync(to.path);
  }

  @override
  void deleteContents(Directory directory) {
    List<FileSystemEntity> entities = directory.listSync();
    if (entities != null) {
      entities.forEach((FileSystemEntity entity) {
        if (exists(entity)) {
          delete(entity);
        }
      });
    }
  }
}
