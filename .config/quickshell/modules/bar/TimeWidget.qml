import qs.services
import qs.widgets.common

StyledText {
    id: textroot
    text: Time.times
    font.family: "JetBrainsMono NF"

    color: {
        var day = new Date().getDay();
        if (day === 1) return "blue";      // Monday
        else if (day === 5) return "red";  // Friday
        else return "green";               // Other days
    }
}
