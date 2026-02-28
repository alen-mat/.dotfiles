StyledText {
    property real fill
    property int grade: -25 //Colours.light ? 0 : -25

    //font.family: Appearance.font.family.material
    font.pointSize: 13
    // Appearance.font.size.larger
    font.variableAxes: ({
        "FILL": fill.toFixed(1),
        "GRAD": grade,
        "opsz": fontInfo.pixelSize,
        "wght": fontInfo.weight
    })
}
