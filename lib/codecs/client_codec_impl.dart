import 'dart:convert';

import 'package:iot_internal/iot_internal.dart';
import 'package:iot_models/iot_models.dart';

class ClientEventCodecImpl implements ClientCodec {
  const ClientEventCodecImpl();

  @override
  Client decode(final String data) {
    final json = jsonDecode(data);
    return Client.fromJson(json as Map<String, dynamic>);
  }

  @override
  String encode(final Client data) {
    final mapJson = data.toJson();
    return jsonEncode(mapJson);
  }
}
