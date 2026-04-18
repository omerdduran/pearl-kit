import QtQuick
import QtQuick as QQ
import QtQuick.Controls.Basic as QC
import QtQuick.Effects
import QtQuick.Templates as T
import PearlKit 1.0
import PearlKit.internal 1.0

T.Menu {
    id: control

    property int minimumWidth: 192

    modal: false
    cascade: true
    focus: true
    overlap: 4
    padding: Tokens.space.x1

    implicitWidth: Math.max(
        implicitBackgroundWidth + leftInset + rightInset,
        implicitContentWidth + leftPadding + rightPadding,
        control.minimumWidth
    )

    background: Rectangle {
        id: menuBg
        color: Tokens.popover
        radius: Tokens.radius.md
        border.color: Tokens.border
        border.width: 1
        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowBlur: 1.0
            shadowHorizontalOffset: 0
            shadowVerticalOffset: 4
            shadowColor: Qt.rgba(0, 0, 0, 0.15)
            shadowScale: 1.0
            paddingRect: Qt.rect(-16, -16, menuBg.width + 32, menuBg.height + 32)
        }
    }

    contentItem: QQ.ListView {
        implicitHeight: contentHeight
        model: control.contentModel
        interactive: control.contentHeight > control.height
        clip: true
        currentIndex: control.currentIndex
        QC.ScrollIndicator.vertical: QC.ScrollIndicator { }
    }

    enter: Transition {
        ParallelAnimation {
            NumberAnimation {
                property: "opacity"
                from: 0.0
                to: 1.0
                duration: Tokens.motion.fast
                easing.type: Easing.OutCubic
            }
            NumberAnimation {
                property: "scale"
                from: 0.95
                to: 1.0
                duration: Tokens.motion.fast
                easing.type: Easing.OutCubic
            }
        }
    }
    exit: Transition {
        NumberAnimation {
            property: "opacity"
            from: 1.0
            to: 0.0
            duration: Tokens.motion.fast
            easing.type: Easing.OutCubic
        }
    }
}
