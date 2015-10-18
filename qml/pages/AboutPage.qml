import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: aboutPage
    property string title: "About"

    Flickable {
        id: flickable
        anchors.fill: parent
        //contentHeight: header.height + columnWrapper.height

        PageHeader { id: header; title: aboutPage.title }

        Rectangle{
            anchors { left: parent.left; right: parent.right; top: header.bottom }
            height: parent.height
            color: "transparent"
            Image {
                id: appIcon
                fillMode: Image.PreserveAspectFit
                smooth: true
                source: "../img/neliapila.png"
                anchors.horizontalCenter: parent.horizontalCenter

            }
            Label{
                id: appName
                anchors { top: appIcon.bottom }
                text: "Neliapila"
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeLarge

            }
            Text {
                id: diipadaapa
                anchors { top: appName.bottom; left: parent.left; right: parent.right; margins: Theme.paddingLarge }
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: Theme.fontSizeExtraSmall
                color: Theme.primaryColor
                wrapMode: Text.Wrap
                text: "4chan image board browser for Sailfish OS\n" +
                      "Copyright (c) Joni Kurunsaari\nLicensed under GNU GPLv3+\n"
            }
            Button {
                id:github_button
                anchors { top: diipadaapa.bottom; horizontalCenter: parent.horizontalCenter; margins: Theme.paddingLarge }
                text: "Github"
                onClicked: Qt.openUrlExternally("google.com");
            }
            Button {
                anchors { top: github_button.bottom; horizontalCenter: parent.horizontalCenter; margins: Theme.paddingLarge }
                text: "License"
                onClicked: Qt.openUrlExternally("http://www.gnu.org/licenses/gpl-3.0.html");
            }

        }
    }
}
