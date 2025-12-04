import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "blocks" as Blocks
import "root:/"

Scope {
  IpcHandler {
    target: "bar"

    function toggleVis(): void {
      for (let i = 0; i < Quickshell.screens.length; i++) {
        barInstances[i].visible = !barInstances[i].visible;
      }
    }
  }

  property var barInstances: []

  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: bar
      property var modelData
      screen: modelData

      Component.onCompleted: {
        barInstances.push(bar);
      }

      color: "transparent"

      implicitHeight: 30  // use implicitHeight, not height

      visible: true

      anchors {
        top: Theme.get.onTop
        bottom: !Theme.get.onTop
        left: true
        right: true
      }

      RowLayout {
        id: allBlocks
        anchors.fill: parent
        spacing: 0

        // Left side
        RowLayout {
          id: leftBlocks
          spacing: 10
          Layout.alignment: Qt.AlignLeft
          // no fillWidth, so only as wide as needed
          Blocks.Workspaces {}
        }

        // Spacer to push activeWorkspace to center
        Item {
          Layout.fillWidth: true
        }

        // Active workspace text
        Blocks.ActiveWorkspace {
          id: activeWorkspace
          Layout.alignment: Qt.AlignHCenter

          chopLength: {
            var space = Math.floor(bar.width - (rightBlocks.implicitWidth + leftBlocks.implicitWidth))
            return space * 0.08;
          }

          text: {
            var str = activeWindowTitle
            return str.length > chopLength ? str.slice(0, chopLength) + '...' : str;
          }

          color: {
            return Hyprland.focusedMonitor == Hyprland.monitorFor(screen)
              ? "#FFFFFF" : "#CCCCCC"
          }
        }

        // Spacer to push rightBlocks right
        Item {
          Layout.fillWidth: true
        }

        // Right side
        RowLayout {
          id: rightBlocks
          spacing: 0
          Layout.alignment: Qt.AlignRight
          // no fillWidth here either
          Blocks.SystemTray {}
          Blocks.Memory {}
          Blocks.Sound {}
          Blocks.Date {}
          Blocks.Time {}
        }
      }
    }
  }
}
