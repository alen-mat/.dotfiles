//import "root:/modules/common"
import Quickshell
import Quickshell.Services.UPower
pragma Singleton

Singleton {
    property bool available: UPower.displayDevice.isLaptopBattery
    property var chargeState: UPower.displayDevice.state
    property bool isCharging: chargeState == UPowerDeviceState.Charging
    property bool isPluggedIn: isCharging || chargeState == UPowerDeviceState.PendingCharge
    property real percentage: UPower.displayDevice.percentage
    readonly property bool allowAutomaticSuspend: true //Config.options.battery.automaticSuspend
    property bool isLow: percentage <= 25 //Config.options.battery.low / 100
    property bool isCritical: percentage <= 15 //Config.options.battery.critical / 100
    property bool isSuspending: percentage <= 2 //Config.options.battery.suspend / 100
    property bool isLowAndNotCharging: isLow && !isCharging
    property bool isCriticalAndNotCharging: isCritical && !isCharging
    property bool isSuspendingAndNotCharging: false //allowAutomaticSuspend && isSuspending && !isCharging

    onIsLowAndNotChargingChanged: {
        if (available && isLowAndNotCharging)
            Quickshell.execDetached(["bash", "-c", `notify-send "Low battery" "Consider plugging in your device" -u critical -a "Shell"`]);

    }
    onIsCriticalAndNotChargingChanged: {
        if (available && isCriticalAndNotCharging)
            Quickshell.execDetached(["bash", "-c", `notify-send "Critically low battery" "" -u critical -a "Shell"`]);

    }
    onIsSuspendingAndNotChargingChanged: {
        if (available && isSuspendingAndNotCharging)
            Quickshell.execDetached(["bash", "-c", `systemctl suspend || loginctl suspend`]);

    }
}
