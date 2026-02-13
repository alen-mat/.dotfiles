import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.services
import qs.widgets.common

ShellRoot {
	Variants {
		// Create the panel once on each monitor.
		model: Quickshell.screens

		PanelWindow {
			id: w

			property var modelData
			screen: modelData

			anchors {
				right: true
				bottom: true
			}

			margins {
				right: 50
				bottom: 50
			}

			implicitWidth: content.width
			implicitHeight: content.height

			color: "transparent"

			mask: Region {}
			WlrLayershell.layer: WlrLayer.Bottom

			ColumnLayout {
				id: content

				Text {
					text: Time.time
					color: "#50ffffff"
					font.pointSize: 23
				}
			}
		}
	}
}
