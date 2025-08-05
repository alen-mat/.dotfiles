//@ pragma Internal
import QtQuick
import qs

Rectangle {
	property var checkState: Qt.Unchecked;
        id : root
	implicitHeight: 18
	implicitWidth: 18
	radius: width / 2
	color: '#ff001d'//ShellGlobals.colors.widget

	Rectangle {
		x: parent.width * 0.25
		y: parent.height * 0.25
		visible: root.checkState == Qt.Checked
		width: parent.width * 0.5
		height: width
		radius: width / 2
	}
}
