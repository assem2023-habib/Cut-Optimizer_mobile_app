import 'dart:typed_data';

class FileStoreService {
  static final FileStoreService _instance = FileStoreService._internal();

  factory FileStoreService() {
    return _instance;
  }

  FileStoreService._internal();

  Uint8List? _inputBytes;

  void setInputBytes(Uint8List bytes) {
    _inputBytes = bytes;
  }

  Uint8List? get inputBytes => _inputBytes;

  void clear() {
    _inputBytes = null;
  }
}
