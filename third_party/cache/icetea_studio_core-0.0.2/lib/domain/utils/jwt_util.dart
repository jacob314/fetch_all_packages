import 'dart:convert';

import 'package:crypto/crypto.dart';

class JWTUtil {

    static Map<String, dynamic> decode(String token, String secret) {
        final parts = token.split('.');
        final header = parts[0];
        final payload = parts[1];
        final signature = parts[2];

        if (_verify(header, payload, signature, secret)){
            return new JsonDecoder().convert(String.fromCharCodes(base64Decode(_normalizeBase64(payload))));
        }else {
            throw new ArgumentError("Invalid signatur");
        }
    }

    static String _signMessage(String msg, String secret) {
        final hmac = new Hmac(sha256 , secret.codeUnits);
        final hash = hmac.convert(msg.codeUnits);

        return base64Encode(hash.bytes);
    }

    static bool _verify(String header, String payload, String signature, String secret) {
        var signed = _signMessage('$header.$payload', secret);
        signature = base64Encode(base64Decode(_normalizeBase64(signature)));

        return signature == signed;
    }

    static String _normalizeBase64(String message) {
        var reminder = message.length % 4;
        var normalizedLength = message.length + (reminder == 0 ? 0 : 4 - reminder);

        return message.padRight(normalizedLength, '=');
    }
}