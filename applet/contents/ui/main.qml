import QtQuick
import QtQuick.Controls
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami


PlasmoidItem {
    id: mainWindow
    
    clip: true

    // PROPERTIES
    property bool enableTransparency: Plasmoid.configuration.transparency
    property var animationDuration: Kirigami.Units.veryShortDuration
    property bool playVolumeFeedback: Plasmoid.configuration.playVolumeFeedback

    property var scale: Plasmoid.configuration.scale * 0.01
    property int fullRepWidth: 360 * scale
    property int fullRepHeight: 360 * scale
    property int sectionHeight: 180 * scale

    property int largeSpacing: 12 * scale
    property int mediumSpacing: 8 * scale
    property int smallSpacing: 6 * scale

    property int buttonMargin: 4 * scale
    property int buttonHeight: 48 * scale

    property int largeFontSize: 15 * scale
    property int mediumFontSize: 12 * scale
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
    
    readonly property bool inPanel: (mainWindow.location === PlasmaCore.Types.TopEdge
        || mainWindow.location === PlasmaCore.Types.RightEdge
        || mainWindow.location === PlasmaCore.Types.BottomEdge
        || mainWindow.location === PlasmaCore.Types.LeftEdge)

    switchHeight: fullRepHeight
    switchWidth: fullRepWidth
    
    fullRepresentation: FullRepresentation {}
    compactRepresentation: CompactRepresentation {
        iconName: mainWindow.mainIconName
    }
    preferredRepresentation: mainWindow.inPanel ? mainWindow.compactRepresentation : mainWindow.fullRepresentation
}
