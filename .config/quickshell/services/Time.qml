pragma Singleton

import Quickshell

Singleton {
  id: root
  readonly property string time: {
    Qt.formatDateTime(clock.date, "ddd MMM d hh:mm")
  }

  readonly property string times: {
    Qt.formatDateTime(clock.date, "d hh:mm")
  }
  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }
}
