import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    id: openLinkDialog

    property string title: "Open URL"
    property string imgUrl
    property string thumbUrl

    property bool __buttonClickAccept: false

    onAccepted: {
        // user accept the dialog by swiping to left instead of clicking on the button
        if (!__buttonClickAccept) {
            Qt.openUrlExternally(imgUrl);
            infoBanner.alert("Launching web browser...");
        }
    }

    Column {
        anchors {
            top: parent.top;
            left: parent.left;
            right: parent.right
        }
        spacing: Theme.paddingLarge

        DialogHeader { title: openLinkDialog.title }

        Label {
            anchors {
                left: parent.left;
                right: parent.right;
                margins: Theme.paddingLarge
            }
            horizontalAlignment: Text.AlignHCenter
            color: Theme.highlightColor
            wrapMode: Text.WrapAnywhere
            maximumLineCount: 4
            elide: Text.ElideRight
            text: imgUrl
        }
    }

    Column {
        anchors { left: parent.left; right: parent.right; bottom: parent.bottom; margins: Theme.paddingLarge }
        Rectangle {
            color: "blue"
            anchors.fill: parent
        }
    }
}
