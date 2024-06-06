import QtQuick 2.0
import QtQuick.Layouts 1.15

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components as PlasmaComponents

Card {
    id: cardButton
    signal clicked
    default property alias content: icon.data
    property alias title: title.text

    GridLayout {
        anchors.fill: parent
        property bool small: width < mainWindow.sectionWidth
        anchors.margins: small ? mainWindow.smallSpacing : mainWindow.largeSpacing
        rows: small ? 2 : 1
        columns: small ? 1 : 2
        columnSpacing: small ? 0 : 10*mainWindow.scale
        rowSpacing: small ? 0 : 10*mainWindow.scale

        Item {
            id: icon
            Layout.preferredHeight: parent.small ? parent.height/1.6-mainWindow.smallSpacing: parent.height - mainWindow.largeSpacing
            Layout.preferredWidth: Layout.preferredHeight
            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
        }
        PlasmaComponents.Label {
            id: title
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.margins: mainWindow.smallSpacing
            font.pixelSize: parent.small ? mainWindow.mediumFontSize : mainWindow.largeFontSize
            font.weight: parent.small ? Font.Normal : Font.Bold
            horizontalAlignment: parent.small ? Qt.AlignHCenter : Qt.AlignLeft
            verticalAlignment: Qt.AlignVCenter
            wrapMode: Text.WordWrap
        }
    }
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true

        onClicked: {
            cardButton.clicked()
        }
    }
}
