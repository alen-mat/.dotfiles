import qs.services
import qs.widgets.common

StyledText {
    id: textroot

    text: Time.times
    font.family: "JetBrainsMono NF"
    color: Time.getColorByDay()
}
