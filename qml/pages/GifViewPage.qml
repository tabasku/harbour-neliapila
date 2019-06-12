/*
    Neliapila - 4chan.org client for SailfishOS
    Copyright (C) 2015  Joni Kurunsaari
    Copyright (C) 2019  Jacob Gold
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see [http://www.gnu.org/licenses/].
*/

import QtQuick 2.1
import Sailfish.Silica 1.0
import "../items"

AbstractPage {
    id: imagePage
    allowedOrientations : Orientation.All
    property alias imgUrl: imageItem.source
    property string thumbUrl
    property string ext
    property string filename

    busy : false

    Loader {
        id: busyIndicatorLoader
        anchors.top: parent.top

        sourceComponent: {
            switch (imageItem.status) {
            case Image.Ready : {
                imagePage.busy=false
                thumbnail_stretched.visible = false
                return undefined
            }

            case Image.Loading: {
                imagePage.busy=true
                return busyIndicatorComponent
            }
            case Image.Error:{
                infoBanner.alert("Image loading failed");
                return failedLoading
            }
            default: return undefined
            }
        }

        Component {
            id: busyIndicatorComponent

            Rectangle {
                color: Theme.highlightBackgroundColor
                width: imagePage.width
                height: Theme.paddingLarge * 2
                visible: imagePage.busy

                BusyIndicator {
                    id: imageLoaderIndicator
                    size: BusyIndicatorSize.Small
                    running: true
                    anchors {
                        verticalCenter: parent.verticalCenter
                        right : imageLoaderText.left
                        rightMargin: Theme.paddingSmall
                    }
                }

                Text {
                    id: imageLoaderText

                    text: "Loading image "+Math.round(imageItem.progress * 100) + "%"
                    anchors {
                        verticalCenter: parent.verticalCenter
                        horizontalCenter: parent.horizontalCenter
                    }
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.primaryColor
                }
            }

        }
        Component {
            id: failedLoading;
            Label {
                text: qsTr("Error")
            }
        }
    }

    title : filename

    SilicaFlickable {
        id: picFlick
        contentWidth: width
        contentHeight: height
        anchors.fill: parent
        pressDelay: 0
        function _fit() {
            fitAnimation.start()
        }

        // Animation for zooming out
        ParallelAnimation {
            id: fitAnimation
            running: false

            NumberAnimation { target: picFlick; property: "contentWidth"; to: width; duration: 100 }
            NumberAnimation { target: picFlick; property: "contentHeight"; to: height; duration: 100 }
            NumberAnimation { target: picFlick; property: "contentX"; to: 0; duration: 100 }
            NumberAnimation { target: picFlick; property: "contentY"; to: 0; duration: 100 }
        }

        PullDownMenu {
            id: imageViewMenu
            MenuItem {
                text: qsTr("Open in browser")
                onClicked: {
                    infoBanner.alert("Launching external web browser...");
                    Qt.openUrlExternally(imgUrl)
                }
            }

            MenuItem {
                text: qsTr("Save as")
                onClicked: pageStack.push(Qt.resolvedUrl("SaveFilePage.qml"), {uri: imgUrl})
            }

            Label{
                text: title
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeExtraSmall
                color: Theme.secondaryHighlightColor
                clip: true
                smooth: true
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        PinchArea {
            width: Math.max(picFlick.contentWidth, picFlick.width)
            height: Math.max(picFlick.contentHeight, picFlick.height)
            property real initialWidth
            property real initialHeight

            onPinchStarted: {
                initialWidth = picFlick.contentWidth
                initialHeight = picFlick.contentHeight
            }
            onPinchUpdated: {
                picFlick.contentX += pinch.previousCenter.x - pinch.center.x
                picFlick.contentY += pinch.previousCenter.y - pinch.center.y

                var newWidth = Math.max(initialWidth * pinch.scale, picFlick.width)
                var newHeight = Math.max(initialHeight * pinch.scale, picFlick.height)

                newWidth = Math.min(newWidth, picFlick.width * 3)
                newHeight = Math.min(newHeight, picFlick.height * 3)

                picFlick.resizeContent(newWidth, newHeight, pinch.center)
            }
            onPinchFinished: {
                picFlick.returnToBounds()
            }

            // Doubletap to zoom and doubletap to return to images
            MouseArea {
                id: doubleTapArea
                width: Math.max(picFlick.contentWidth, picFlick.width)
                height: Math.max(picFlick.contentHeight, picFlick.height)

                onDoubleClicked: function() {
                    if (picFlick.contentWidth <= picFlick.width) {
                        picFlick.resizeContent(picFlick.width * 2.0, picFlick.height * 2.0, Qt.point(doubleTapArea.mouseX, doubleTapArea.mouseY))
                        picFlick.returnToBounds()
                    }
                    else {
                        picFlick._fit()
                    }
                }
            }
        }

        Item {
            id:imageArea
            width: picFlick.contentWidth
            height: picFlick.contentHeight
            smooth: !(picFlick.movingVertically || picFlick.movingHorizontally)
            anchors.centerIn: parent

            AnimatedImage {
                id: imageItem
                fillMode: Image.PreserveAspectFit
                smooth: false
                anchors.fill: parent
            }

            Image {
                smooth: false
                id:thumbnail_stretched
                source: thumbUrl
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
                asynchronous : true
                opacity: busy ? 0.5 : 1
            }
        }
    }
}
