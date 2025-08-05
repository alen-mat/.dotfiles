import qs.modules
import qs.widgets.common
import qs.services
import QtQuick
import QtQuick.Layouts

Item {
    id: batteryIndicatorRoot
    property bool borderless: false // Config.options.bar.borderless
    readonly property var chargeState: SystemBattery.chargeState
    readonly property bool isCharging: SystemBattery.isCharging
    readonly property bool isPluggedIn: SystemBattery.isPluggedIn
    readonly property real percentage: SystemBattery.percentage
    readonly property bool isLow: percentage <=  15/100 //Config.options.battery.low / 100
    readonly property color batteryLowBackground: "#ff0000"//Appearance.m3colors.darkmode ? Appearance.m3colors.m3error : Appearance.m3colors.m3errorContainer
    readonly property color batteryLowOnBackground: "#00ff00"//Appearance.m3colors.darkmode ? Appearance.m3colors.m3errorContainer : Appearance.m3colors.m3error

    implicitWidth: rowLayout.implicitWidth + rowLayout.spacing * 2
    implicitHeight: 3

    RowLayout {
        id: rowLayout

        spacing: 4
        anchors{
            centerIn: parent
        }
        

        CircularProgress {
            Layout.alignment: Qt.AlignVCenter
            value: batteryIndicatorRoot.percentage
            size: 18
            secondaryColor: (batteryIndicatorRoot.isLow && !batteryIndicatorRoot.isCharging) ? batteryIndicatorRoot.batteryLowBackground : Beautiful.Colors.colSecondaryContainer
            primaryColor: (batteryIndicatorRoot.isLow && !batteryIndicatorRoot.isCharging) ? batteryIndicatorRoot.batteryLowOnBackground : Beautiful.M3Colors.m3onSecondaryContainer
            fill: (batteryIndicatorRoot.isLow && !batteryIndicatorRoot.isCharging)
        }

    }

}
