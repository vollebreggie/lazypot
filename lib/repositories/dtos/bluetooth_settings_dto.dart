class BluetoothSettingsDTO {
  final bool foundDeviceWaitingToConnect;
  final bool scanStarted;
  final bool connected;

  BluetoothSettingsDTO({required this.foundDeviceWaitingToConnect, required this.scanStarted, required this.connected});
}
