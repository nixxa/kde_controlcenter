import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.networkmanagement as PlasmaNM
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.ksvg as KSvg
import org.kde.kirigami as Kirigami
import org.kde.networkmanager as NMQt
import org.kde.coreaddons 1.0 as KCoreAddons
import org.kde.kcmutils as KCMUtils
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

        header: ConnectionListHeader {}

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
                visible: network.activeConnectionIcon.connectivity === NMQt.NetworkManager.Portal

                actions: Kirigami.Action {
                    text: i18nc("@action:button", "Log in")
                    onTriggered: {
                        Qt.openUrlExternally(network.networkStatus.networkCheckUrl);
                    }
                }
            }

            PlasmaComponents3.ScrollView {
                id: scrollView
                Layout.fillWidth: true
                Layout.fillHeight: true
                contentWidth: availableWidth - contentItem.leftMargin - contentItem.rightMargin

                contentItem: ListView {
                    id: connectionView
                    //anchors.fill: parent
                    focus: true
                    currentIndex: -1
                    clip: true
                    model: network.appletProxyModel
                    highlight: PlasmaExtras.Highlight {
                        width: scrollView.contentWidth
                    }
                    highlightMoveDuration: Kirigami.Units.shortDuration
                    highlightResizeDuration: Kirigami.Units.shortDuration

                    topMargin: connectivityMessage.visible ? 0 : Kirigami.Units.smallSpacing * 2
                    bottomMargin: Kirigami.Units.smallSpacing * 2
                    leftMargin: Kirigami.Units.smallSpacing
                    rightMargin: Kirigami.Units.smallSpacing

                    property bool showSeparator: true
                    section.property: showSeparator ? "Section" : ""
                    section.delegate: ListItem {
                        width: parent.width
                        separator: true
                    }

                    delegate: ConnectionItem {
                    }

                    Loader {
                        anchors.centerIn: parent
                        width: parent.width - (Kirigami.Units.largeSpacing * 4)
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
