import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents

import "lib" as Lib
import "components" as Components
import "js/funcs.js" as Funcs 


Item {
    id: fullRep
    
    // PROPERTIES
    Layout.preferredWidth: mainWindow.fullRepWidth
    Layout.preferredHeight: wrapper.implicitHeight
    Layout.minimumWidth: Layout.preferredWidth
    Layout.maximumWidth: Layout.preferredWidth
    Layout.minimumHeight: Layout.preferredHeight
    Layout.maximumHeight: Layout.preferredHeight
    clip: true
    
    // Lists all available network connections
    Components.SectionNetworks{
        id: sectionNetworks
    }

    // Main wrapper
    ColumnLayout {
        id: wrapper

        anchors.fill: parent
        spacing: 0

        RowLayout {
            id: sectionA

            spacing: 0
            Layout.fillWidth: true
            Layout.preferredHeight: mainWindow.sectionHeight
            Layout.maximumHeight: mainWindow.sectionHeight
            
            // Network, Bluetooth and Settings Button
            Components.SectionButtons{}
            
            // Quick Toggle Buttons
            ColumnLayout {
                spacing: 0
                
                Components.DndButton{}
                RowLayout {
                    spacing: 0
                    
                    // Other blocks
                    Components.KDEConnect{}
                    Components.RedShift{}
                    Components.ColorSchemeSwitcher{}
                }
            }
        }
        Item {
            Layout.fillHeight: true
        }
        ColumnLayout {
            id: sectionB

            spacing: 0
            Layout.fillWidth: true

            Components.Volume{}
            Components.BrightnessSlider{}
            Components.MediaPlayer{}
        }
    }
}
