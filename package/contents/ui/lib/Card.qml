import QtQuick 2.0
import QtQml 2.0
import QtQuick.Layouts 1.15
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components as PlasmaComponents
import org.kde.ksvg as KSvg

Rectangle {
    color: "transparent"
    property alias prefix: rect.prefix
    property var margins: rect.margins
    default property alias content: dataContainer.data


    KSvg.FrameSvgItem {
        id: rect

        imagePath: mainWindow.enableTransparency ? "translucent/dialogs/background" : "opaque/dialogs/background"
        clip: true
        anchors.fill: parent
        anchors.topMargin: rect.margins.top * mainWindow.scale
        anchors.leftMargin: rect.margins.left * mainWindow.scale
        anchors.rightMargin: rect.margins.right * mainWindow.scale
        anchors.bottomMargin: rect.margins.bottom * mainWindow.scale

        Item {
            id: dataContainer
            anchors.fill: parent
        }
    }
}
