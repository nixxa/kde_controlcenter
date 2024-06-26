import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.plasma.components as PlasmaComponents

import "lib" as Lib
import "components" as Components
import "js/funcs.js" as Funcs 


PlasmaExtras.Representation {
    id: fullRep
    
    Components.Network {
        id: network
    }

    Components.SectionNetworks {
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
            
            // Network, Bluetooth and Settings Button
            Components.SectionButtons {
                Layout.minimumWidth: mainWindow.sectionHeight * 2 
                Layout.minimumHeight: mainWindow.sectionHeight * 2
            }
            
            // Quick Toggle Buttons
            ColumnLayout {
                spacing: 0
                
                Components.DndButton {
                    Layout.minimumHeight: mainWindow.sectionHeight
                    Layout.maximumHeight: mainWindow.sectionHeight
                }

                RowLayout {
                    spacing: 0
                    
                    // Other blocks
                    Components.KDEConnect {
                        Layout.minimumHeight: mainWindow.sectionHeight
                        Layout.maximumHeight: mainWindow.sectionHeight
                    }
                    Components.RedShift {
                        Layout.minimumHeight: mainWindow.sectionHeight
                        Layout.maximumHeight: mainWindow.sectionHeight
                    }
                    Components.ColorSchemeSwitcher {
                        Layout.minimumHeight: mainWindow.sectionHeight
                        Layout.maximumHeight: mainWindow.sectionHeight
                    }
                }
            }
        }

        ColumnLayout {
            id: sectionB

            spacing: 0
            Layout.fillWidth: true

            Components.Volume {
                Layout.maximumHeight: mainWindow.sectionHeight
            }
            Components.BrightnessSlider {
                Layout.maximumHeight: mainWindow.sectionHeight
            }
            Components.MediaPlayer {
                Layout.maximumHeight: mainWindow.sectionHeight
            }
        }
    }
}
