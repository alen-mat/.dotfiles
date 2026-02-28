import QtQuick
import Quickshell.Services.SystemTray

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

        Repeater {
            id: items

            model: SystemTray.items

            TrayItem {
            }

        }

        add: Transition {
            NumberAnimation {
                //easing.bezierCurve: Appearance.anim.curves.standardDecel

                properties: "scale"
                from: 0
                to: 1
                duration: 1 //Appearance.anim.durations.normal
                easing.type: Easing.BezierSpline
            }

        }

        move: Transition {
            NumberAnimation {
                //easing.bezierCurve: Appearance.anim.curves.standardDecel

                properties: "scale"
                to: 1
                duration: 1 //Appearance.anim.durations.normal
                easing.type: Easing.BezierSpline
            }

            NumberAnimation {
                //easing.bezierCurve: Appearance.anim.curves.standard

                properties: "x,y"
                duration: 1 // Appearance.anim.durations.normal
                easing.type: Easing.BezierSpline
            }

        }

    }

    Behavior on implicitWidth {
        NumberAnimation {
            //easing.bezierCurve: Appearance.anim.curves.emphasized

            duration: 1 //Appearance.anim.durations.normal
            easing.type: Easing.BezierSpline
        }

    }

    Behavior on implicitHeight {
        NumberAnimation {
            //easing.bezierCurve: Appearance.anim.curves.emphasized

            duration: 1 //Appearance.anim.durations.normal
            easing.type: Easing.BezierSpline
        }

    }

}
