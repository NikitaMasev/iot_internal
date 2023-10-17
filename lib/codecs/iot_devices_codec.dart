import 'package:iot_internal/iot_internal.dart';
import 'package:iot_models/iot_models.dart';

abstract interface class IotDevicesCodec
    implements CustomCodec<String, IotDevicesDataWrapper> {}
