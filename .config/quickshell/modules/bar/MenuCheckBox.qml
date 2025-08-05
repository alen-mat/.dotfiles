//@ pragma Internal
import QtQuick
import QtQuick.Shapes
import qs

Rectangle {
	property var checkState: Qt.Unchecked;
        id : root
	implicitHeight: 18
	implicitWidth: 18
	radius: 3
	color: '#ff11d2'//ShellGlobals.colors.widget

	Shape {
		visible: root.checkState == Qt.Checked
		anchors.fill: parent
		layer.enabled: true
		layer.samples: 10

		ShapePath {
			strokeWidth: 2
			capStyle: ShapePath.RoundCap
			joinStyle: ShapePath.RoundJoin
			fillColor: "transparent"

			startX: start.x
			startY: start.y

			PathLine {
				id: start
				x: root.width * 0.8
				y: root.height * 0.2
			}

			PathLine {
				x: root.width * 0.35
				y: root.height * 0.8
			}

			PathLine {
				x: root.width * 0.2
				y: root.height * 0.6
			}
		}
	}
}
