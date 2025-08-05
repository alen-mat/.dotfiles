pragma Singleton

import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    id: root

    readonly property PwNode defaultAudioSink: Pipewire.defaultAudioSink
    readonly property PwNode defaultAudioSource: Pipewire.defaultAudioSource

    readonly property bool muted: defaultAudioSink?.audio?.muted ?? false
    readonly property real volume: defaultAudioSink?.audio?.volume ?? 0

    function setVolume(volume: real): void {
        if (defaultAudioSink?.ready && defaultAudioSink?.audio) {
            defaultAudioSink.audio.muted = false;
            defaultAudioSink.audio.volume = volume;
        }
    }

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource]
    }
}
