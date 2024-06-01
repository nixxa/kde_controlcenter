import QtQml
import QtQuick
import QtQuick.Layouts
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.plasma5support as Plasma5Support


import "../lib" as Lib
import "../js/brightness.js" as BrightnessJS


Lib.Slider {
    id: brightnessControl
    
    // Should be visible ONLY if the monitor supports it
    visible: isBrightnessAvailable && mainWindow.showBrightness
    
    // Dimensions
    Layout.fillWidth: true
    Layout.preferredHeight: mainWindow.sectionHeight
    
    // Slider properties
    title: "Display Brightness"
    source: "brightness-high"
    secondaryTitle: Math.round((screenBrightness / maximumScreenBrightness)*100) + "%"
    
    from: 0
    to: maximumScreenBrightness
    value: screenBrightness
    
    // Other properties
    property int screenBrightness
    property QtObject updateScreenBrightnessJob
    property bool disableBrightnessUpdate: true

    // Power Management Data Source
    property QtObject pmSource: Plasma5Support.DataSource {
        id: pmSource
        engine: "powermanagement"
        connectedSources: sources
 
        onSourceAdded: source => {
            disconnectSource(source);
            connectSource(source);
        }
        onSourceRemoved: source => {
            disconnectSource(source);
        }
        onDataChanged: {
            BrightnessJS.updateBrightness(brightnessControl, pmSource);
        }
    }

    readonly property bool isBrightnessAvailable: pmSource.data["PowerDevil"] && pmSource.data["PowerDevil"]["Screen Brightness Available"] ? true : false
    readonly property int maximumScreenBrightness: pmSource.data["PowerDevil"] ? pmSource.data["PowerDevil"]["Maximum Screen Brightness"] || 0 : 0


    onScreenBrightnessChanged: {
        if (disableBrightnessUpdate) {
            return;
        }
        const service = pmSource.serviceForSource("PowerDevil");
        const operation = service.operationDescription("setBrightness");
        operation.brightness = screenBrightness;
        updateScreenBrightnessJob = service.startOperationCall(operation);
        updateScreenBrightnessJob.finished.connect(job => {
            BrightnessJS.updateBrightness(brightnessControl, pmSource);
        });
    }
    
    onMoved: {
        screenBrightness = value
    }
}
