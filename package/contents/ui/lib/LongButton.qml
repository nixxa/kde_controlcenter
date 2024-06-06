import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents
import org.kde.ksvg as KSvg
import org.kde.kirigami as Kirigami

KSvg.FrameSvgItem {
    id: button

    imagePath: "widgets/viewitem"
    prefix: mouseArea.containsMouse ? (mouseArea.pressed ? "selected+hover" : "hover") : "normal"
    signal clicked;

    property alias title: title.text
    property alias subtitle: subtitle.text
    property alias source: icon.source
    property alias sourceColor: icon.color

    property int margin: mainWindow.buttonMargin

    GridLayout {
        rows: 2
        columns: 2
        anchors.fill: parent
        anchors.margins: button.margin
        //rowSpacing: -mainWindow.smallSpacing
        rowSpacing: 0
        columnSpacing: mainWindow.mediumSpacing
        //clip: true

        Kirigami.Icon {
            id: icon
            Layout.rowSpan: 2
            Layout.preferredHeight: parent.height - mainWindow.smallSpacing
            Layout.preferredWidth: Layout.preferredHeight
        }

        PlasmaComponents.Label {
            id: title
            Layout.fillWidth: true
            font.pixelSize: mainWindow.largeFontSize
            font.weight: Font.Bold
            elide: Text.ElideRight
        }
        PlasmaComponents.Label {
            id: subtitle
            Layout.fillWidth: true
            font.pixelSize: mainWindow.mediumFontSize
            elide: Text.ElideRight
        }
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            button.clicked()
        }
    }
}
