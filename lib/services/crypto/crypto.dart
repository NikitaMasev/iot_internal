abstract interface class Crypto {
  String decrypt(final String encryptedData);

  String encrypt(final String rawData);
}
