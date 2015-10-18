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
                //imageViewMenu.busy=false
                imagePage.busy=false
                thumbnail_streched.visible = false
                //infoBanner.alert("Image loading complete");
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
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        leftMargin: Theme.paddingSmall
                    }
                }
                Text {
                    text: qsTr("Loading image "+Math.round(imageItem.progress * 100) + "%")
                    //                    anchors {
                    //                        left: imageLoaderIndicator.right
                    //                        verticalCenter: parent.verticalCenter
                    //                        leftMargin: Theme.paddingSmall
                    //                    }
                    anchors {
                        left: imageLoaderIndicator.right; right: parent.right; margins: Theme.paddingMedium
                        verticalCenter: parent.verticalCenter
                    }
                    elide: Text.ElideRight
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.primaryColor
                }
            }



        }
        Component { id: failedLoading; Label { text: qsTr("Error") } }
    }

    title : filename+ext

    SilicaFlickable {
        id: picFlick
        contentWidth: width
        contentHeight: height
        anchors.fill: parent
        pressDelay: 0
        function _fit() {
            contentX = 0
            contentY = 0
            contentWidth = width
            contentHeight = height
        }

        PullDownMenu {
            id: imageViewMenu
            MenuItem {
                text: qsTr("Open in browser")
                onClicked: {
                    infoBanner.alert("Launching web browser...");
                    Qt.openUrlExternally(imgUrl)
                }
            }

            MenuItem {
                text: qsTr("Save as")
                onClicked: pageStack.push(Qt.resolvedUrl("SaveFilePage.qml"), {uri: imgUrl})
            }
            Label{
                text: title
                //wrapMode: Text.WordWrap
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
            Image{
                smooth: false
                id:thumbnail_streched
                source: thumbUrl
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
                asynchronous : true
                //visible:false
            }
        }
    }
}
