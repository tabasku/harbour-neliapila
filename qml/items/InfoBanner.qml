import QtQuick 2.0
import Sailfish.Silica 1.0

MouseArea {
    id: infoBanner

    function alert(text) {
        messageText.text = text;
        infoBanner.opacity = 1.0;
        hideTimer.start();
    }

    anchors.top :parent.top
    width: Screen.width
    height: messageText.height + Theme.paddingLarge * 2
    visible: opacity > 0.0
    opacity: 0.0

    Behavior on opacity { FadeAnimation {} }

    Rectangle {
        anchors.fill: parent
        color: Theme.secondaryHighlightColor
    }

    Text {
        id: messageText
        anchors {
            left: parent.left; right: parent.right; margins: Theme.paddingMedium
            verticalCenter: parent.verticalCenter
        }
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.primaryColor
        wrapMode: Text.Wrap
        elide: Text.ElideRight
        maximumLineCount: 3
    }

    Timer {
        id: hideTimer
        interval: 3000
        onTriggered: infoBanner.opacity = 0.0;
    }

    onClicked: {
        opacity = 0.0;
        hideTimer.stop();
    }
}
