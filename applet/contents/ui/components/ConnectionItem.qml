/*
    SPDX-FileCopyrightText: 2013-2017 Jan Grulich <jgrulich@redhat.com>
    SPDX-FileCopyrightText: 2020 Nate Graham <nate@kde.org>

    SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
*/

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2

import org.kde.coreaddons 1.0 as KCoreAddons
import org.kde.kcmutils as KCMUtils

import org.kde.kirigami as Kirigami
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.plasma.networkmanagement as PlasmaNM

PlasmaExtras.ExpandableListItem {
    id: connectionItem

    readonly property bool isDeactivated: ConnectionState === PlasmaNM.Enums.Deactivated
    property bool activating: ConnectionState === PlasmaNM.Enums.Activating
    property bool deactivated: ConnectionState === PlasmaNM.Enums.Deactivated
    property bool passwordIsStatic: (SecurityType === PlasmaNM.Enums.StaticWep || SecurityType == PlasmaNM.Enums.WpaPsk ||
                            SecurityType === PlasmaNM.Enums.Wpa2Psk || SecurityType == PlasmaNM.Enums.SAE)
    property bool predictableWirelessPassword: !Uuid && Type === PlasmaNM.Enums.Wireless && passwordIsStatic
    property real rxSpeed: 0
    property real txSpeed: 0
    property bool showSpeed: true

    icon: ConnectionIcon
    title: ItemUniqueName
    subtitle: itemText()
    isBusy: mainWindow.expanded && ConnectionState === PlasmaNM.Enums.Activating
    isDefault: ConnectionState === PlasmaNM.Enums.Activated

    defaultActionButtonAction: QQC2.Action {
        id: stateChangeButton
        enabled: {
            if (!connectionItem.expanded) {
                return true;
            }
            if (connectionItem.customExpandedViewContent === passwordDialogComponent) {
                return connectionItem.customExpandedViewContentItem.passwordField.acceptableInput ?? false;
            }
            return true;
        }
        icon.name: isDeactivated ? "network-connect" : "network-disconnect"
        text: ""
        onTriggered: changeState()
    }
    contextualActions: [
        QQC2.Action {
            enabled: Uuid && Type === PlasmaNM.Enums.Wireless && passwordIsStatic
            text: i18n("Show Network's QR Code")
            icon.name: "view-barcode-qr"
            onTriggered: handler.requestWifiCode(ConnectionPath, Ssid, SecurityType);
        },
        QQC2.Action {
            text: i18n("Configure…")
            icon.name: "configure"
            onTriggered: KCMUtils.KCMLauncher.openSystemSettings(mainWindow.kcm, ["--args", "Uuid=" + Uuid])
        }
    ]

    Component {
        id: passwordDialogComponent

        ColumnLayout {
            property alias password: passwordField.text
            property alias passwordField: passwordField

            PasswordField {
                id: passwordField

                Layout.fillWidth: true
                Layout.leftMargin: Kirigami.Units.gridUnit
                Layout.rightMargin: Kirigami.Units.gridUnit

                securityType: SecurityType

                onAccepted: {
                    stateChangeButton.trigger()
                    connectionItem.customExpandedViewContent = detailsComponent
                }

                Component.onCompleted: {
                    passwordField.forceActiveFocus()
                    setDelayModelUpdates(true)
                }
            }
        }
    }

    Timer {
        id: timer
        repeat: true
        interval: 2000
        running: showSpeed
        triggeredOnStart: true
        // property int can overflow with the amount of bytes.
        property double prevRxBytes: 0
        property double prevTxBytes: 0
        onTriggered: {
            rxSpeed = prevRxBytes === 0 ? 0 : (RxBytes - prevRxBytes) * 1000 / interval
            txSpeed = prevTxBytes === 0 ? 0 : (TxBytes - prevTxBytes) * 1000 / interval
            prevRxBytes = RxBytes
            prevTxBytes = TxBytes
        }
    }

    function itemText() {
        if (ConnectionState === PlasmaNM.Enums.Activating) {
            if (Type === PlasmaNM.Enums.Vpn) {
                return VpnState
            } else {
                return DeviceState
            }
        } else if (ConnectionState === PlasmaNM.Enums.Deactivating) {
            if (Type === PlasmaNM.Enums.Vpn) {
                return VpnState
            } else {
                return DeviceState
            }
        } else if (Uuid && ConnectionState === PlasmaNM.Enums.Deactivated) {
            return LastUsed
        } else if (ConnectionState === PlasmaNM.Enums.Activated) {
            if (showSpeed) {
                return i18n("Connected, ⬇ %1/s, ⬆ %2/s",
                    KCoreAddons.Format.formatByteSize(rxSpeed),
                    KCoreAddons.Format.formatByteSize(txSpeed))
            } else {
                return i18n("Connected")
            }
        }
        return ""
    }

    function changeState() {
        if (Uuid || !predictableWirelessPassword || connectionItem.customExpandedViewContent == passwordDialogComponent) {
            if (ConnectionState == PlasmaNM.Enums.Deactivated) {
                if (!predictableWirelessPassword && !Uuid) {
                    network.handler.addAndActivateConnection(DevicePath, SpecificPath)
                } else if (connectionItem.customExpandedViewContent == passwordDialogComponent) {
                    const item = connectionItem.customExpandedViewContentItem;
                    if (item && item.password !== "") {
                        network.handler.addAndActivateConnection(DevicePath, SpecificPath, item.password)
                        connectionItem.customExpandedViewContent = detailsComponent
                        connectionItem.collapse()
                    } else {
                        connectionItem.expand()
                    }
                } else {
                    network.handler.activateConnection(ConnectionPath, DevicePath, SpecificPath)
                }
            } else {
                network.handler.deactivateConnection(ConnectionPath, DevicePath)
            }
        } else if (predictableWirelessPassword) {
            setDelayModelUpdates(true)
            connectionItem.customExpandedViewContent = passwordDialogComponent
            connectionItem.expand()
        }
    }

    function setDelayModelUpdates(delay: bool) {
        network.appletProxyModel.setData(network.appletProxyModel.index(index, 0), delay, PlasmaNM.NetworkModel.DelayModelUpdatesRole);
    }
}