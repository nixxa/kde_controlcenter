// Version: 4
import QtQuick
import org.kde.kirigami as Kirigami
import org.kde.ksvg as KSvg

Item {
	id: appletIcon
	property string source: ''
	property bool active: false
	readonly property bool usingPackageSvg: filename // plasmoid.file() returns "" if file doesn't exist.
	readonly property string filename: source ? plasmoid.file('', 'assets/' + mainWindow.config.isDarkTheme ? 'dark/' : 'light/' + source + '.svg') : ''
	readonly property int minSize: Math.min(width, height)
	property bool smooth: true

	Kirigami.Icon {
		anchors.fill: parent
		visible: !appletIcon.usingPackageSvg
		source: appletIcon.usingPackageSvg ? '' : appletIcon.source
		active: appletIcon.active
		smooth: appletIcon.smooth
	}

	KSvg.SvgItem {
		id: svgItem
		anchors.centerIn: parent
		readonly property real minSize: Math.min(naturalSize.width, naturalSize.height)
		readonly property real widthRatio: naturalSize.width / svgItem.minSize
		readonly property real heightRatio: naturalSize.height / svgItem.minSize
		width: appletIcon.minSize * widthRatio
		height: appletIcon.minSize * heightRatio

		smooth: appletIcon.smooth

		visible: appletIcon.usingPackageSvg
		svg: KSvg.Svg {
			id: svg
			imagePath: appletIcon.filename
		}
	}
}
