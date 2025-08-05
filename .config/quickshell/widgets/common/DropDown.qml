import QtQuick

MouseArea {
    function onClicked(): void {
    }

    anchors.fill: parent

    cursorShape: disabled ? undefined : Qt.PointingHandCursor
    hoverEnabled: true

    onPressed: event => {
        if (disabled)
            return;

        rippleAnim.x = event.x;
        rippleAnim.y = event.y;

        const dist = (ox, oy) => ox * ox + oy * oy;
        rippleAnim.radius = Math.sqrt(Math.max(dist(event.x, event.y), dist(event.x, height - event.y), dist(width - event.x, event.y), dist(width - event.x, height - event.y)));

        rippleAnim.restart();
    }

    onClicked: event => !disabled && onClicked(event)

    id: mouseAreaRoot
    property bool disabled
    property color color: "#ffffff"
    // anchors.margins: -Appearance.padding.small / 2
    // anchors.leftMargin: -Appearance.padding.smaller
    // anchors.rightMargin: -Appearance.padding.smaller

    radius: item.radius
    disabled: !item.modelData.enabled

    function onClicked(): void {
        const entry = item.modelData;
        if (entry.hasChildren)
            root.push(subMenuComp.createObject(null, {
                handle: entry,
                isSubMenu: true
            }));
        else {
            item.modelData.triggered();
            root.popouts.hasCurrent = false;
        }
    }

    Rectangle {
        id: hoverLayer

        anchors.fill: parent

        color: Qt.alpha(mouseAreaRoot.color, mouseAreaRoot.disabled ? 0 : mouseAreaRoot.pressed ? 0.1 : mouseAreaRoot.containsMouse ? 0.08 : 0)
        radius: mouseAreaRoot.radius
        Rectangle {
            id: ripple

            //radius: Appearance.rounding.full
            //color: root.color
            opacity: 0

            transform: Translate {
                x: -ripple.width / 2
                y: -ripple.height / 2
            }
        }
    }
}
