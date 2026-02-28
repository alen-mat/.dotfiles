pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Wayland
import QtQuick.Layouts
import qs.modules.bar
import qs.modules.bar.systray

Scope {
    id: bar
    Variants {
        // For each monitor
        model: {
            const screens = Quickshell.screens;
            const list = [];
            if (!list || list.length === 0)
                return screens;
            return screens.filter(screen => list.includes(screen.name));
        }
        Loader {
            id: barLoader
            //active: GlobalStates.barOpen
            required property ShellScreen modelData
            sourceComponent: PanelWindow { // Bar window
                id: barRoot
                screen: barLoader.modelData
                color: "transparent"
                implicitHeight: 26
                mask: Region {
                    item: barContent
                }

                WlrLayershell.namespace: "quickshell:bar"

                anchors {
                    top: true
                    bottom: false
                    left: true
                    right: true
                }
                Item {
                    id: barContent
                    implicitHeight: 26
                    anchors {
                        right: parent.right
                        left: parent.left
                        top: parent.top
                        bottom: undefined
                    }
                    Rectangle {
                        //background
                        id: barBackground
                        anchors {
                            fill: parent
                            margins: 0 //Config.options.bar.cornerStyle === 1 ? (Appearance.sizes.hyprlandGapsOut) : 0 // idk why but +1 is needed
                        }
                        color: "#66663600"//showBarBackground ? Appearance.colors.colLayer0 : "transparent"
                        radius: 1// Config.options.bar.cornerStyle === 1 ? Appearance.rounding.windowRounding : 0
                        border.width: 1 //Config.options.bar.cornerStyle === 1 ? 1 : 0
                        border.color: "#ffff9090" //Appearance.m3colors.m3outlineVariant
                    }

                    Item {
                        // Left section
                        anchors.fill: parent
                        anchors.right: undefined
                        implicitHeight: leftSectionRowLayout.implicitHeight
                        implicitWidth: leftSectionRowLayout.implicitWidth
                        RowLayout { // Content
                            id: leftSectionRowLayout
                            anchors.fill: parent
                            spacing: 10
                            width: (barRoot.width) / 2
                            Workspace {
                                bar: barRoot
                                size: 18
                                spacing: 5
                            }
                        }
                    }

                    RowLayout { // Middle section
                        id: middleSection
                        anchors.centerIn: parent
                        spacing: 4//Config.options?.bar.borderless ? 4 : 8
                    }
                    Item {
                        anchors.fill: parent
                        anchors.left: undefined
                        implicitHeight: rightSectionRowLayout.implicitHeight
                        implicitWidth: 15

                        RowLayout {
                            id: rightSectionRowLayout
                            anchors.centerIn: parent
                            anchors.fill: parent
                            layoutDirection: Qt.RightToLeft

                            RowLayout {
                                spacing: 2
                                Tray {}
				VolumeIndicator{}
                                TimeWidget {}
                                BatteryIndicator {}
                            }
                        }
                    }
                }
            }
        }
    }
}
