import 'dart:convert';

import 'package:iot_internal/adapters/client/client_codec.dart';
import 'package:iot_internal/adapters/client/client_event_decoder.dart';
import 'package:iot_models/models/client.dart';
import 'package:iot_models/models/client_event.dart';

class ClientAdapter implements ClientCodec, ClientEventDecoder {
  const ClientAdapter();

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

  @override
  ClientEvent toEvent(final String decrypted) {
    try {
      final mapJson = jsonDecode(decrypted);
      final client = Client.fromJson(mapJson as Map<String, dynamic>);
      if (!client.nonValid) {
        return _handleStateByModel(client);
      } else {
        return const ClientEvent.empty();
      }
    } on Exception catch (e) {
      print(e.toString());
      return const ClientEvent.empty();
    }
  }

  ClientEvent _handleStateByModel(final Client client) {
    if (client.controlData != null) {
      return ClientEvent.controlIot(client.controlData!);
    } else if (client.id != null && client.name != null) {
      return ClientEvent.auth(client);
    } else if (client.name != null) {
      return ClientEvent.needRegister(client.name!);
    }
    return const ClientEvent.empty();
  }
/*  @override
  @override
  String encodeIotDevices(final List<IotDevice> devices) {
    final wrapper = IotDevicesDataWrapper(devices: devices);
    return jsonEncode(wrapper.toJson());
  }*/
}
