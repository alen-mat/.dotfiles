import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Bluetooth
import qs.widgets.common

Image{
    id: root

    readonly property BluetoothAdapter adapter: Bluetooth.defaultAdapter
    readonly property bool connected: adapter.devices.values.some((device) => {
        return device.connected;
    })

    property string image: adapter.enabled
		? (connected ? "root:/icons/bluetooth-connected.svg" : "root:/icons/bluetooth.svg")
		: "root:/icons/bluetooth-slash.svg"

//	id: imageComponent
	cache: false
	source: image
    width: 20
    height:20
    sourceSize: Qt.size(width, height) 
    mipmap: true

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true   // <-- REQUIRED for ToolTip

        onClicked: {
	     adapter.enabled = !adapter.enabled
        }

    }
}
