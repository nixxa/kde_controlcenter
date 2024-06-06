import QtQml
import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.kirigami as Kirigami
import "components" as Components

PlasmaExtras.Representation {
    id: compactRep

    required property string iconName
    
    RowLayout {
        anchors.fill: parent

        Components.AppletIcon {
            id: icon
            anchors.fill: parent
            source: 'control-center'
            active: mouseArea.containsMouse
        }
        
        MouseArea {
            anchors.fill: parent
            onPressed: mouse => {
                if (mouse.button != Qt.LeftButton)
                    return;

                mainWindow.expanded = !mainWindow.expanded
            }
        }
    }
}