import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.kirigami as Kirigami
import org.kde.networkmanager as NMQt
import "../lib" as Lib


Lib.Card {
    id: sectionNetworks

    anchors.fill: parent
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
        id: networkPage
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
                QQC2.ScrollBar.horizontal.policy: QQC2.ScrollBar.AlwaysOff
                contentWidth: availableWidth - contentItem.leftMargin - contentItem.rightMargin

                contentItem: ListView {
                    id: connectionView
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
                                if (networkPage.header.displayplaneModeMessage) {
                                    return "network-flightmode-on"
                                }
                                if (networkPage.header.displayWifiMessage) {
                                    return "network-wireless-off"
                                }
                                return "edit-none"
                            }
                            text: {
                                if (networkPage.header.displayplaneModeMessage) {
                                    return i18n("Airplane mode is enabled")
                                }
                                if (networkPage.header.displayWifiMessage) {
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
