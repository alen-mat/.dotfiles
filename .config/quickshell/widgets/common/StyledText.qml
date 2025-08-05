pragma ComponentBehavior: Bound

import QtQuick

Text {
    id: root

    property bool animate: false
    property string animateProp: "scale"
    property real animateFrom: 0
    property real animateTo: 1
    property int animateDuration:1// Appearance.anim.durations.normal

    renderType: Text.NativeRendering
    textFormat: Text.PlainText
    color: "#E5E1E9" // Colours.palette.m3onSurface
    font.family:"IBM Plex Sans"// Appearance.font.family.sans
    font.pointSize: 11 //Appearance.font.size.smaller

    Behavior on color {
        ColorAnimation {
            duration: 1 //Appearance.anim.durations.normal
            easing.type: Easing.BezierSpline
            easing.bezierCurve: [0.2, 0, 0, 1, 1, 1] //Appearance.anim.curves.standard
        }
    }

    Behavior on text {
        enabled: root.animate

        SequentialAnimation {
            Anim {
                to: root.animateFrom
                easing.bezierCurve:  [0.3, 0, 1, 1, 1, 1] //Appearance.anim.curves.standardAccel
            }
            PropertyAction {}
            Anim {
                to: root.animateTo
                easing.bezierCurve:  [0, 0, 0, 1, 1, 1]// Appearance.anim.curves.standardDecel
            }
        }
    }

    component Anim: NumberAnimation {
        target: root
        property: root.animateProp
        duration: root.animateDuration / 2
        easing.type: Easing.BezierSpline
    }
}
