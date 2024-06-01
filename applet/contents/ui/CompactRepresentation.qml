import QtQml
import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.kirigami as Kirigami

PlasmaExtras.Representation {
    id: compactRep

    required property string iconName
    
    RowLayout {
        anchors.fill: parent
        
        Kirigami.Icon {
            Layout.fillWidth: true
            Layout.fillHeight: true
            source: compactRep.conName
            smooth: true
            
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
}