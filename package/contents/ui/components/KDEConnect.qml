import QtQml 2.0
import QtQuick 2.0
import QtQuick.Layouts 1.15

import org.kde.kdeconnect 1.0 as KdeConnect
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.kirigami as Kirigami

import "../lib" as Lib
import "../js/funcs.js" as Funcs

Lib.CardButton {
    visible: mainWindow.showKDEConnect
    Layout.fillWidth: true
    Layout.fillHeight: true
    title: i18n("KDE Connect")
    Kirigami.Icon {
        anchors.fill: parent
        source: "kdeconnect-tray"
    }
    onClicked: KdeConnect.OpenConfig.openConfiguration();
}