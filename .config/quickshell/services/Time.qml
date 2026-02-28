import Quickshell
pragma Singleton

Singleton {
    id: root

    readonly property string time: {
        Qt.formatDateTime(clock.date, "ddd MMM d hh:mm");
    }
    readonly property string times: {
        Qt.formatDateTime(clock.date, "d hh:mm");
    }

    function getColorByDay() {
        var day = Qt.formatDateTime(clock.date, "ddd");
        switch (day[0]) {
        case "M":
            return "blue"; // Mon
        case "T":
            return day[1] === "u" ? "green" : "purple"; // Tue : Thu
        case "W":
            return "yellow"; // Wed
        case "F":
            return "orange"; // Fri
        case "S":
            return day[1] === "u" ? "red" : "pink"; // Sun : Sat
        default:
            return "";
        }
    }

    SystemClock {
        id: clock

        precision: SystemClock.Seconds
    }

}
