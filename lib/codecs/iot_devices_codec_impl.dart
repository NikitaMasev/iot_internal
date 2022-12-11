import 'dart:convert';

import 'package:iot_internal/iot_internal.dart';
import 'package:iot_models/iot_models.dart';

class IotDevicesCodecImpl implements IotDevicesCodec {
  const IotDevicesCodecImpl();

  @override
  IotDevicesDataWrapper decode(final String data) {
    final json = jsonDecode(data);
    return IotDevicesDataWrapper.fromJson(json as Map<String, dynamic>);
  }

  @override
  String encode(final IotDevicesDataWrapper data) => jsonEncode(data.toJson());
}
