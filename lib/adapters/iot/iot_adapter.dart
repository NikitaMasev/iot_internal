import 'dart:convert';

import 'package:iot_internal/adapters/iot/iot_commander_encoder.dart';
import 'package:iot_internal/adapters/iot/iot_devices_codec.dart';
import 'package:iot_internal/adapters/iot/iot_event_decoder.dart';
import 'package:iot_models/iot_models.dart';
import 'package:iot_models/models/iot_event.dart';

///Example pushing data from IOT
/// #128/30.6/12;
/// '#' - start package symbol
/// ';' - end package symbol
/// '/' - delimiter data
/// 128, 30.6 and 12 - data
/// order matter

///Example register process
/// ^ups^
/// '^' - sign config iot device
/// 'ups' - type device
/// order matter

///Example auth process
/// ^23:ups^
/// '^' - sign config iot device
/// '23' - id device
/// ':' - delimiter
/// 'ups' - type device
/// order matter
class IotAdapter
    implements IotCommanderEncoder, IotDevicesCodec, IotEventDecoder {
  const IotAdapter({
    required final this.startPkgDataSymbol,
    required final this.endPkgDataSymbol,
    required final this.pkgCmdDelimiterSymbol,
    required final this.pkgCmdSymbol,
  });

  final String startPkgDataSymbol;
  final String endPkgDataSymbol;
  final String pkgCmdDelimiterSymbol;
  final String pkgCmdSymbol;

  @override
  IotDevicesDataWrapper decode(final String data) {
    final json = jsonDecode(data);
    return IotDevicesDataWrapper.fromJson(json as Map<String, dynamic>);
  }

  @override
  String encode(final IotDevicesDataWrapper data) => jsonEncode(data.toJson());

  ///Example data command for iot when [controlData.typeControl]==
  ///==[TypeControl.powerOn] || [TypeControl.powerOff]
  /// '^powerOn^'
  ///Example data command for iot when [controlData.typeControl]==
  ///==[TypeControl.rgba]
  /// '^125:25:96:230^'
  /// this is rgba data come from client
  ///Example data command for iot when [controlData.typeControl]==
  ///==[TypeControl.rgbaEffects]
  /// '^125:25:96:230:3^'
  /// first 4 digits - rgba data, and last - number of effect
  @override
  String toCommand(final ControlData controlData) {
    switch (controlData.typeControl) {
      case TypeControl.powerOn:
      case TypeControl.powerOff:
        return '$pkgCmdSymbol${typeControlFromString[controlData.typeControl]}'
            '$pkgCmdSymbol';
      case TypeControl.rgba:
      case TypeControl.rgbaEffects:
        return '$pkgCmdSymbol${controlData.configControl}$pkgCmdSymbol';
      case TypeControl.changeName:
        break;
      case TypeControl.register:
        return '$pkgCmdSymbol${controlData.iotIdControl}$pkgCmdSymbol';
    }
    return '';
  }

  @override
  IotEvent toEvent(final String decrypted) {
    if (decrypted.startsWith(pkgCmdSymbol)) {
      final rawCmd = decrypted.replaceAll(pkgCmdSymbol, '');
      return _handleCommand(rawCmd);
    } else if (decrypted.startsWith(startPkgDataSymbol) &&
        decrypted.endsWith(endPkgDataSymbol)) {
      return _handleData(decrypted);
    } else {
      return const IotEvent.empty();
    }
  }

  IotEvent _handleData(final String decrypted) {
    final rawData = decrypted
        .replaceAll(startPkgDataSymbol, '')
        .replaceAll(endPkgDataSymbol, '');
    return IotEvent.data(rawData);
  }

  IotEvent _handleCommand(final String rawCmd) {
    if (rawCmd.contains(pkgCmdDelimiterSymbol)) {
      final idAndTypeDevice = rawCmd.split(pkgCmdDelimiterSymbol);
      final id = int.parse(idAndTypeDevice[0]);
      final type = idAndTypeDevice[1];
      final typeEnum = typeDeviceFromString[type] ?? TypeDevice.unknown;
      return IotEvent.auth(id, typeEnum);
    } else if (rawCmd.isNotEmpty) {
      final typeDevice = typeDeviceFromString[rawCmd] ?? TypeDevice.unknown;
      return IotEvent.needRegister(typeDevice);
    } else {
      return const IotEvent.empty();
    }
  }
}
