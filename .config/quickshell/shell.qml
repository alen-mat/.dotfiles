//@ pragma UseQApplication

import Quickshell
import qs.modules.bar
import qs.services
import qs.widgets.desktop

ShellRoot {
	id: root
	property bool enableBar: true
	LazyLoader { active: root.enableBar; component: Bar {} }
	LazyLoader { active: root.enableBar; component: ClockDWidget {} }
}
