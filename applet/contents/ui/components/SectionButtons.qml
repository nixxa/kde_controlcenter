import QtQuick
import QtQuick.Layouts 1.15

import org.kde.plasma.core as PlasmaCore
import org.kde.bluezqt 1.0 as BluezQt
import org.kde.kquickcontrolsaddons 2.0
import org.kde.config // KAuthorized
import org.kde.kcmutils // KCMLauncher
import org.kde.kirigami as Kirigami

import "../lib" as Lib
import "../js/funcs.js" as Funcs

Lib.Card {
    id: sectionButtons
   
    // BLUETOOTH
    property QtObject btManager : BluezQt.Manager
    
    // All Buttons
    ColumnLayout {
        id: buttonsColumn
        anchors.fill: parent
        anchors.bottomMargin: mainWindow.smallSpacing
        anchors.topMargin: mainWindow.smallSpacing
        spacing: 0
        
        Lib.LongButton {
            title: i18n("Network")
            subtitle: network?.networkStatus ?? "unknown"
            source: network.activeConnectionIcon
            sourceColor: network.networkStatus === "Connected" ? Kirigami.Theme.highlightColor : Kirigami.Theme.disabledTextColor
            onClicked: {
                sectionNetworks.toggleNetworkSection()
            }
        }
        
        Lib.LongButton {
            title: i18n("Bluetooth")
            subtitle: Funcs.getBtDevice()
            source: "network-bluetooth"
            onClicked: {
                Funcs.toggleBluetooth()
            }
        }
        
        Lib.LongButton {
            title: i18n("Settings")
            subtitle: i18n("System Settings")
            source: "settings-configure"
            onClicked: {
                KCMLauncher.openSystemSettings("")
            }
        }
    }
}