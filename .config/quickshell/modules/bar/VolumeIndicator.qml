import QtQuick
import QtQuick.Controls
import qs.services
import qs.widgets.common

StyledText {
    id: bleep

    text: SystemAudio.muted ? "M" : Math.floor(SystemAudio.volume * 100)

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true   // <-- REQUIRED for ToolTip

        onClicked: {
            SystemAudio.toggleMute()
        }

        onWheel: {
            if (wheel.angleDelta.y > 0) {
                SystemAudio.setVolume(Math.min(1, SystemAudio.volume + 0.03))
            } else {
                SystemAudio.setVolume(Math.max(0, SystemAudio.volume - 0.02))
            }
        }
    }
}
