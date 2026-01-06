//@ pragma UseQApplication
import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Wayland

ShellRoot {
    id: root

    // Keeps the process running / IPC
    IpcHandler {
        target: "caelestia"
    }

    FileView {
        id: wal
        path: Quickshell.env("HOME") + "/.cache/wal/colors.json"

        JsonAdapter {
            id: walAdapter
            property var colors: ({})
        }
    }

    property var styles: ({
        radius: 20,
        color: (walAdapter.colors && walAdapter.colors.color0) ? walAdapter.colors.color0 : "#000000"
    })
    property var panels: ({ left: 15, right: 15, top: 15, bottom: 15 })

    PanelWindow {
        WlrLayershell.layer: WlrLayer.Overlay
        anchors { top: true; left: true; right: true; }
        implicitHeight: panels.top;
        color: styles.color;
    }

    PanelWindow {
        WlrLayershell.layer: WlrLayer.Overlay
        anchors { bottom: true; left: true; right: true; }
        implicitHeight: panels.bottom;
        color: styles.color;
    }

    PanelWindow {
        WlrLayershell.layer: WlrLayer.Overlay
        anchors { left: true; top: true; bottom: true; }
        implicitWidth: panels.left;
        color: styles.color;
    }

    PanelWindow {
        WlrLayershell.layer: WlrLayer.Overlay
        anchors { right: true; top: true; bottom: true; }
        implicitWidth: panels.right;
        color: styles.color;
    }

    PanelWindow {
        id: mainOverlay
        WlrLayershell.layer: WlrLayer.Overlay
        anchors { top: true; bottom: true; left: true; right: true }
        surfaceFormat.opaque: false
        color: "transparent"

        mask: Region {
            item: mask
            intersection: Intersection.Xor
        }

        Item {
            anchors.fill: parent

            Rectangle {
                anchors.fill: parent
                color: styles.color;

                layer.enabled: true
                layer.effect: MultiEffect {
                    maskSource: mask
                    maskEnabled: true
                    maskInverted: true
                    maskThresholdMin: 0.5
                    maskSpreadAtMin: 1
                }
            }

            Item {
                id: mask
                anchors.fill: parent
                layer.enabled: true
                visible: false

                Rectangle {
                    anchors.fill: parent
                    radius: styles.radius
                }
            }
        }
    }
}
