import QtQuick
import QtQuick.Controls
import QtQuick.Layouts 1.15
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.networkmanagement as PlasmaNM
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.ksvg as KSvg
import org.kde.kirigami as Kirigami
import org.kde.networkmanager as NMQt
import "../lib" as Lib


Lib.Card {
    id: sectionNetworks

    anchors.fill: parent
    //z: 999
    visible: false

    function toggleNetworkSection() {
        if (!sectionNetworks.visible) {
            wrapper.visible = false;
            sectionNetworks.visible = true;
        } else {
            wrapper.visible = true;
            sectionNetworks.visible = false;
        }
    }

    PlasmaExtras.Representation {
        anchors.fill: parent
        anchors.margins: mainWindow.smallSpacing

        header: PlasmaExtras.PlasmoidHeading {
            width: parent.width
            spacing: mainWindow.smallSpacing

            contentItem: RowLayout {
                id: toolbar
                width: parent.width
                height: implicitHeight + mainWindow.smallSpacing

                readonly property var displayWifiMessage: !wifiSwitchButton.checked && wifiSwitchButton.visible
                readonly property var displayplaneModeMessage: planeModeSwitchButton.checked && planeModeSwitchButton.visible

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

        ColumnLayout {
            anchors.fill: parent

            Kirigami.InlineMessage {
                id: connectivityMessage
                Layout.fillWidth: true
                Layout.leftMargin: connectionView.leftMargin
                Layout.rightMargin: connectionView.rightMargin
                Layout.topMargin: mainWindow.smallSpacing
                Layout.preferredHeight: contentItem.implicitHeight + topPadding + bottomPadding
                type: Kirigami.MessageType.Information
                icon.name: "dialog-password"
                text: i18n("You need to log in to this network")
                visible: network.networkStatus.connectivity === NMQt.NetworkManager.Portal

                actions: Kirigami.Action {
                    text: i18nc("@action:button", "Log in")
                    onTriggered: {
                        Qt.openUrlExternally(network.networkStatus.networkCheckUrl);
                    }
                }
            }

            PlasmaComponents3.ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                contentWidth: availableWidth - contentItem.leftMargin - contentItem.rightMargin

                contentItem: ListView {
                    id: connectionView
                    property bool showSeparator: true

                    topMargin: connectivityMessage.visible ? 0 : mainWindow.smallSpacing
                    bottomMargin: mainWindow.smallSpacing
                    leftMargin: 0
                    rightMargin: 0
                    spacing: mainWindow.smallSpacing
                    boundsBehavior: Flickable.StopAtBounds
                    section.property: showSeparator ? "Section" : ""
                    section.delegate: ListItem {
                        separator: true
                    }

                    model: network.appletProxyModel
                    delegate: ConnectionItem {
                        width: connectionView.width - mainWindow.smallSpacing
                        height: mainWindow.buttonHeight
                    }

                    Loader {
                        anchors.centerIn: parent
                        width: parent.width - (mainWindow.largeSpacing*4)
                        active: connectionView.count === 0
                        asynchronous: true
                        visible: status === Loader.Ready
                        sourceComponent: PlasmaExtras.PlaceholderMessage {
                            iconName: {
                                if (toolbar.displayplaneModeMessage) {
                                    return "network-flightmode-on"
                                }
                                if (toolbar.displayWifiMessage) {
                                    return "network-wireless-off"
                                }
                                return "edit-none"
                            }
                            text: {
                                if (toolbar.displayplaneModeMessage) {
                                    return i18n("Airplane mode is enabled")
                                }
                                if (toolbar.displayWifiMessage) {
                                    return i18n("Wireless is deactivated")
                                }
                                return i18n("No available connections")
                            }
                        }
                    }
                }
            }
        }
    }
}
