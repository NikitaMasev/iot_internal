import 'package:iot_models/models/iot_event.dart';

abstract class IotEventDecoder {
  IotEvent toEvent(final String decrypted);
}
