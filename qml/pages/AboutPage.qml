import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: aboutPage
    property string title: "About"

    Flickable {
        id: flickable
        anchors.fill: parent

        PageHeader {
            id: header;
            title: aboutPage.title
        }

        Rectangle {
            anchors {
                left: parent.left;
                right: parent.right;
                top: header.bottom
            }
            height: parent.height
            color: "transparent"

            Image {
                id: appIcon
                fillMode: Image.PreserveAspectFit
                smooth: true
                source: "../img/neliapila.png"
                anchors.horizontalCenter: parent.horizontalCenter

            }

            Label {
                id: appName
                anchors.top: appIcon.bottom
                text: "Neliapila 0.8"
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeLarge
            }

            Text {
                id: diipadaapa
                anchors {
                    top: appName.bottom;
                    left: parent.left;
                    right: parent.right;
                    margins: Theme.paddingLarge
                }
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: Theme.fontSizeExtraSmall
                color: Theme.primaryColor
                wrapMode: Text.Wrap
                text: "4chan image board browser for Sailfish OS\n" +
                      "Licensed under GNU GPLv3+\n";
            }

            Text {
                id: diipaa
                anchors {
                    top: diipadaapa.bottom;
                    left: parent.left;
                    right: parent.right;
                    margins: Theme.paddingLarge
                }
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: Theme.fontSizeExtraSmall
                color: Theme.primaryColor
                wrapMode: Text.Wrap
                text: "Please report issues on Github";
            }

            Button {
                id:github_button
                anchors {
                    top: diipaa.bottom;
                    horizontalCenter: parent.horizontalCenter;
                    margins: Theme.paddingLarge
                }
                text: "Github"
                onClicked: Qt.openUrlExternally("https://github.com/tabasku/harbour-neliapila");
            }

            Button {
                id: lisence
                anchors {
                    top: github_button.bottom;
                    horizontalCenter: parent.horizontalCenter;
                    margins: Theme.paddingLarge
                }
                text: "License"
                onClicked: Qt.openUrlExternally("http://www.gnu.org/licenses/gpl-3.0.html");
            }

            Rectangle {
                id: separator

                anchors {
                    top: lisence.bottom;
                    horizontalCenter: parent.horizontalCenter;
                    margins: Theme.paddingLarge
                }
                height: 5;
                width: parent.width;

                gradient: Gradient {
                    GradientStop { position: 0.0; color: Theme.rgba(Theme.highlightDimmerColor, 1) }
                    GradientStop { position: 5.0; color: Theme.rgba(Theme.highlightDimmerColor, 0.5) }
                }
            }

            Text {
                id: contributors
                anchors {
                    top: separator.bottom;
                    left: parent.left;
                    right: parent.right;
                    margins: Theme.paddingLarge
                }
                font.pixelSize: Theme.fontSizeExtraSmall
                color: Theme.primaryColor
                wrapMode: Text.Wrap
                text: "Contributors:\n★ szopin https://github.com/szopin\n★ JacquesCedric https://github.com/jacquesCedric";
            }
        }
    }
}
