import 'package:iot_models/iot_models.dart';

abstract class ClientEventDecoder {
  ClientEvent toEvent(final String decrypted);
}
