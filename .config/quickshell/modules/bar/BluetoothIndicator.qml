import QtQuick
import QtQuick.Controls
import Quickshell.Bluetooth
import qs.widgets.common

StyledText {
    id: bluep

    readonly property BluetoothAdapter adapter: Bluetooth.defaultAdapter
    readonly property bool connected: adapter.devices.values.some((device) => {
        return device.connected;
    })

    text: adapter.enabled ? (connected ? "con" : "on") : "B"
}
