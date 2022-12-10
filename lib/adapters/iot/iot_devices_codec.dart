import 'package:iot_internal/base/custom_codec.dart';
import 'package:iot_models/iot_models.dart';

abstract class IotDevicesCodec
    implements CustomCodec<String, IotDevicesDataWrapper> {}
