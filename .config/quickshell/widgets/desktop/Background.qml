import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Qt.labs.platform

Scope {
    id: root

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bgRoot

            required property var modelData
            property string wallpaperPath: "/home/alen/Pictures/dark/artwork-digital-art-neon-astronaut-wallpaper.jpg"

            screen: modelData
            WlrLayershell.layer: WlrLayer.Bottom
            WlrLayershell.namespace: "quickshell:background"
            color: "transparent"

            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }

            Image {
                z: 0
                anchors.fill: parent
                source: bgRoot.wallpaperPath
                fillMode: Image.PreserveAspectCrop

                Behavior on x {
                    NumberAnimation {
                        duration: 600
                        easing.type: Easing.OutCubic
                    }
                }
                sourceSize {
                    width: bgRoot.screen.width
                    height: bgRoot.screen.height
                }

            }

            ClockDWidget {
            }
        }

    }

}
