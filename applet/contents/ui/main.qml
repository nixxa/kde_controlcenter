import QtQuick
import QtQuick.Controls
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami
import QtQuick.Layouts 1.1


PlasmoidItem {
    id: mainWindow
    
    //clip: true

    // PROPERTIES
    property bool enableTransparency: Plasmoid.configuration.transparency
    property var animationDuration: Kirigami.Units.veryShortDuration
    property bool playVolumeFeedback: Plasmoid.configuration.playVolumeFeedback

    property var scale: Plasmoid.configuration.scale * 0.01
    property int fullRepWidth: 360 * scale
    property int fullRepHeight: 360 * scale
    
    property int sectionWidth: Plasmoid.configuration.sectionWidth * scale
    property int sectionHeight: Plasmoid.configuration.sectionHeight * scale

    property int largeSpacing: 12 * scale
    property int mediumSpacing: 8 * scale
    property int smallSpacing: 6 * scale

    property int buttonMargin: 4 * scale
    property int buttonHeight: 48 * scale

    property int largeFontSize: 14 * scale
    property int mediumFontSize: 11 * scale
    property int smallFontSize: 7 * scale
    
    // Main Icon
    property string mainIconName: Plasmoid.configuration.mainIconName
    property string mainIconHeight: Plasmoid.configuration.mainIconHeight
    
    // Components
    property bool showKDEConnect: Plasmoid.configuration.showKDEConnect
    property bool showNightColor: Plasmoid.configuration.showNightColor
    property bool showColorSwitcher: Plasmoid.configuration.showColorSwitcher
    property bool showDnd: Plasmoid.configuration.showDnd
    property bool showVolume: Plasmoid.configuration.showVolume
    property bool showBrightness: Plasmoid.configuration.showBrightness
    property bool showMediaPlayer: Plasmoid.configuration.showMediaPlayer
    property bool showPercentage: Plasmoid.configuration.showPercentage
    
    readonly property bool inPanel: (Plasmoid.location === PlasmaCore.Types.TopEdge
        || Plasmoid.location === PlasmaCore.Types.RightEdge
        || Plasmoid.location === PlasmaCore.Types.BottomEdge
        || Plasmoid.location === PlasmaCore.Types.LeftEdge)

    Plasmoid.icon: mainWindow.mainIconName
    
    switchWidth: Kirigami.Units.gridUnit * 10
    switchHeight: Kirigami.Units.gridUnit * 10

    fullRepresentation: FullRepresentation {
        anchors.fill: parent
        Layout.minimumWidth: mainWindow.sectionWidth * 4
        Layout.minimumHeight: mainWindow.sectionHeight
        Layout.preferredWidth: mainWindow.sectionWidth * 4
        Layout.preferredHeight: (mainWindow.sectionHeight + mainWindow.smallSpacing) * 2
            + (mainWindow.showVolume ? mainWindow.sectionHeight + mainWindow.smallSpacing : 0)
            + (mainWindow.showBrightness ? mainWindow.sectionHeight + mainWindow.smallSpacing : 0)
            + (mainWindow.showMediaPlayer ? mainWindow.sectionHeight + mainWindow.smallSpacing : 0)
    }
    compactRepresentation: CompactRepresentation {
        iconName: Plasmoid.icon
    }
    preferredRepresentation: mainWindow.inPanel ? mainWindow.compactRepresentation : mainWindow.fullRepresentation
}
