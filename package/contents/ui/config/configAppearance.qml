import QtQml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.kde.kirigami as Kirigami
import org.kde.kquickcontrolsaddons as KQuickAddons
import org.kde.iconthemes as KIconThemes
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.extras as PlasmaExtras

ColumnLayout {
    property alias cfg_scale: scale.value
    property alias cfg_transparency: transparency.checked
    property alias cfg_showKDEConnect: showKDEConnect.checked
    property alias cfg_showNightColor: showNightColor.checked
    property alias cfg_showColorSwitcher: showColorSwitcher.checked
    property alias cfg_showVolume: showVolume.checked
    property alias cfg_showBrightness: showBrightness.checked
    property alias cfg_showMediaPlayer: showMediaPlayer.checked
    property alias cfg_showCmd1: showCmd1.checked
    property alias cfg_showCmd2: showCmd2.checked
    property alias cfg_showPercentage: showPercentage.checked
    property alias cfg_mainIconName: mainIconName.icon.name

    property int numChecked: showKDEConnect.checked + showColorSwitcher.checked + showNightColor.checked
    property int maxNum: 2

    // Used to select icons
    KIconThemes.IconDialog {
        id: iconDialog
        property var iconObj
        onIconNameChanged: iconObj.name = iconName
    }

    Kirigami.FormLayout {
        Button {
            id: mainIconName
            Kirigami.FormData.label: i18n("Icon:")
            icon.width: Kirigami.Units.iconSizes.medium
            icon.height: icon.width
            onClicked: {
                iconDialog.open()
                iconDialog.iconObj = mainIconName.icon
            }
        }

        SpinBox {
            id: scale
            Kirigami.FormData.label: i18n("Scale:")
            from: 0; to: 1000
        }

        Item {
            Kirigami.FormData.isSection: true
        }

        CheckBox {
            id: showPercentage
            Kirigami.FormData.label: i18n("General:")
            text: i18n("Show volume/brightness percentage")
        }
        CheckBox {
            id: transparency
            text: i18n("Enable transparency")
        }

        Item {
            Kirigami.FormData.isSection: true
        }

        CheckBox {
            id: showKDEConnect
            Kirigami.FormData.label: i18n("Show quick toggle buttons:")
            text: i18n('KDE Connect')
            enabled: !checked && numChecked < maxNum || checked
        }
        CheckBox {
            id: showNightColor
            text: i18n('Night Color')
            enabled: !checked && numChecked < maxNum || checked
        }
        CheckBox {
            id: showColorSwitcher
            text: i18n('Color Scheme Switcher')
            enabled: !checked && numChecked < maxNum || checked
        }
        Label {
            text: i18n("You can enable only 2 toggle buttons at a time.")
            font: Kirigami.Theme.smallFont
            color: Kirigami.Theme.neutralTextColor
            Layout.fillWidth: true
            wrapMode: Text.Wrap
        }

        Item {
            Kirigami.FormData.isSection: true
        }

        CheckBox {
            id: showVolume
            Kirigami.FormData.label: i18n("Show other components:")
            text: i18n('Volume Control')
        }
        CheckBox {
            id: showBrightness
            text: i18n('Brightness Control')
        }
        CheckBox {
            id: showMediaPlayer
            text: i18n('Media Player')
        }
    }

    Item {
        Layout.fillHeight: true
    }
}
