import QtQuick
import QtQuick.Layouts 
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.plasma.networkmanagement as PlasmaNM
import org.kde.kirigami as Kirigami

PlasmaExtras.PlasmoidHeading {
    width: parent.width
    spacing: mainWindow.smallSpacing

    contentItem: RowLayout {
        id: toolbar
        width: parent.width
        height: implicitHeight + mainWindow.smallSpacing

        readonly property var displayWifiMessage: !wifiSwitchButton.checked && wifiSwitchButton.visible
        readonly property var displayplaneModeMessage: airPlaneModeSwitchButton.checked && airPlaneModeSwitchButton.visible

        PlasmaComponents3.ToolButton {
            Layout.preferredHeight: mainWindow.largeFontSize * 2.5
            icon.name: "arrow-left"
            onClicked: {
                sectionNetworks.toggleNetworkSection();
            }
        }

        PlasmaComponents3.Label {
            text: i18n("Networks")
            font.pixelSize: mainWindow.largeFontSize * 1.2
            Layout.fillWidth: true
        }

        PlasmaComponents3.Switch {
            id: wifiSwitchButton

            readonly property bool administrativelyEnabled: network.availableDevices.wirelessDeviceAvailable && network.enabledConnections.wirelessHwEnabled

            Layout.rightMargin: mainWindow.smallSpacing
            checked: administrativelyEnabled && network.enabledConnections.wirelessEnabled
            enabled: administrativelyEnabled
            icon.name: administrativelyEnabled && network.enabledConnections.wirelessEnabled ? "network-wireless-on" : "network-wireless-off"
            visible: network.availableDevices.wirelessDeviceAvailable
            onToggled: network.handler.enableWireless(checked)

            PlasmaComponents3.ToolTip {
                text: wifiSwitchButton.checked ? i18n("Disable Wi-Fi") : i18n("Enable Wi-Fi")
            }

            PlasmaComponents3.BusyIndicator {
                parent: wifiSwitchButton
                running: network.handler.scanning || timer.running

                anchors {
                    fill: wifiSwitchButton.contentItem
                    leftMargin: wifiSwitchButton.indicator.width + wifiSwitchButton.spacing
                }

                Timer {
                    id: timer

                    interval: Kirigami.Units.humanMoment
                }

                Connections {
                    function onScanningChanged() {
                        if (network.handler.scanning)
                            timer.restart();
                    }

                    target: network.handler
                }
            }
        }

        // Airplane mode section
        PlasmaComponents3.Switch {
            id: airPlaneModeSwitchButton

            property bool initialized: false

            checked: PlasmaNM.Configuration.airplaneModeEnabled
            icon.name: PlasmaNM.Configuration.airplaneModeEnabled ? "network-flightmode-on" : "network-flightmode-off"
            visible: network.availableDevices.modemDeviceAvailable || network.availableDevices.wirelessDeviceAvailable
            onToggled: {
                network.handler.enableAirplaneMode(checked);
                PlasmaNM.Configuration.airplaneModeEnabled = checked;
            }

            PlasmaComponents3.ToolTip {
                text: airPlaneModeSwitchButton.checked ? i18n("Disable airplane mode") : i18n("Enable airplane mode")
            }
        }
    }
}