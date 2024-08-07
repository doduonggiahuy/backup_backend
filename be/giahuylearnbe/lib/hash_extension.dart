import 'dart:convert';

import 'package:crypto/crypto.dart';

extension HashStringExtension on String {
  String get hashValue {
    return sha256.convert(utf8.encode(this)).toString();
  }

  String get hashBase64 {
    final bytes = utf8.encode(this);
    final digest = sha256.convert(bytes);
    return base64Encode(digest.bytes);
  }
}
