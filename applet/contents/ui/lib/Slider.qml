import QtQuick 2.0
import QtQuick.Layouts 1.15
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.kirigami as Kirigami

Card {
    id: sliderComp
    signal moved
    signal clicked

    property alias title: title.text
    property alias secondaryTitle: secondaryTitle.text
    property alias value: slider.value
    property bool useIconButton: false
    property string source


    property int from: 0
    property int to: 100


    ColumnLayout {
        anchors.fill: parent
        anchors.margins: mainWindow.largeSpacing
        clip: true

        RowLayout {
            Layout.fillHeight: true
            Layout.fillWidth: true
            spacing: mainWindow.smallSpacing

            PlasmaComponents.Label {
                id: title
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignLeft
                font.pixelSize: mainWindow.largeFontSize
                font.weight: Font.Bold
                font.capitalization: Font.Capitalize
            }

            PlasmaComponents.Label {
                id: secondaryTitle
                visible: mainWindow.showPercentage
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignRight
                font.pixelSize: mainWindow.largeFontSize
                font.weight: Font.Bold
                font.capitalization: Font.Capitalize
                horizontalAlignment: Text.AlignRight
            }


        }
        RowLayout {
            Layout.fillHeight: true
            Layout.fillWidth: true
            spacing: mainWindow.smallSpacing

            Kirigami.Icon {
                id: icon
                source: sliderComp.source
                visible: !sliderComp.useIconButton
                Layout.preferredHeight: mainWindow.largeFontSize*2
                Layout.preferredWidth: Layout.preferredHeight
            }
            
            PlasmaComponents.ToolButton {
                id: iconButton
                visible: sliderComp.useIconButton
                icon.name: sliderComp.source
                Layout.preferredHeight: mainWindow.largeFontSize*2
                Layout.preferredWidth: Layout.preferredHeight
                onClicked: sliderComp.clicked()
            }
            
            PlasmaComponents.Slider {
                id: slider
                Layout.fillHeight: true
                Layout.fillWidth: true
                from: sliderComp.from
                to: sliderComp.to
                stepSize: 2
                snapMode: PlasmaComponents.Slider.SnapAlways
                
                onMoved: {
                    sliderComp.moved()
                }
            }
        }
    }
}
