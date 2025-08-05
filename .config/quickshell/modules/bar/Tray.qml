import Quickshell.Services.SystemTray
import QtQuick

Item {
    id: root

    readonly property Repeater items: items

    clip: true
    visible: width > 0 && height > 0 // To avoid warnings about being visible with no size

    implicitWidth: layout.implicitWidth
    implicitHeight: layout.implicitHeight

    Row {
        id: layout

        spacing: 2 //Appearance.spacing.small

        add: Transition {
            NumberAnimation {
                properties: "scale"
                from: 0
                to: 1
                duration: 1//Appearance.anim.durations.normal
                easing.type: Easing.BezierSpline
                //easing.bezierCurve: Appearance.anim.curves.standardDecel
            }
        }

        move: Transition {
            NumberAnimation {
                properties: "scale"
                to: 1
                duration: 1 //Appearance.anim.durations.normal
                easing.type: Easing.BezierSpline
                //easing.bezierCurve: Appearance.anim.curves.standardDecel
            }
            NumberAnimation {
                properties: "x,y"
                duration: 1 // Appearance.anim.durations.normal
                easing.type: Easing.BezierSpline
                //easing.bezierCurve: Appearance.anim.curves.standard
            }
        }

        Repeater {
            id: items

            model: SystemTray.items

            TrayItem {}

        }
    }

    Behavior on implicitWidth {
        NumberAnimation {
            duration: 1 //Appearance.anim.durations.normal
            easing.type: Easing.BezierSpline
            //easing.bezierCurve: Appearance.anim.curves.emphasized
        }
    }

    Behavior on implicitHeight {
        NumberAnimation {
            duration: 1 //Appearance.anim.durations.normal
            easing.type: Easing.BezierSpline
            //easing.bezierCurve: Appearance.anim.curves.emphasized
        }
    }
}
