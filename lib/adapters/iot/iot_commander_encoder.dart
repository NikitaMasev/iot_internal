import 'package:iot_models/iot_models.dart';

abstract class IotCommanderEncoder {
  String toCommand(final ControlData controlData);
}
