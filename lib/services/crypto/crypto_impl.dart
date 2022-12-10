import 'package:encrypt/encrypt.dart';
import 'package:iot_internal/services/crypto/crypto.dart';

class CryptoImpl implements Crypto {
  factory CryptoImpl({
    required final String key,
    required final String iv,
    final AESMode aesMode = AESMode.cbc,
  }) {
    final keyAes = Key.fromUtf8(key);
    final ivAes = IV.fromUtf8(iv);
    final encryptor = Encrypter(AES(keyAes, mode: aesMode));
    return CryptoImpl._(ivAes, encryptor);
  }

  const CryptoImpl._(this._iv, this._encryptor);

  final IV _iv;
  final Encrypter _encryptor;

  @override
  String decrypt(final String encryptedData) {
    var decrypted = '';
    try {
      final base64 = Encrypted.fromBase64(encryptedData);
      decrypted = _encryptor
          .decrypt(
            base64,
            iv: _iv,
          )
          .trim();
    } catch (e) {
      print(e.toString());
      return decrypted;
    }
    return decrypted;
  }

  @override
  String encrypt(final String rawData) =>
      _encryptor.encrypt(rawData, iv: _iv).base64;
}
