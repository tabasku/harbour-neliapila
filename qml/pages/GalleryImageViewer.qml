import QtQuick 2.0
import Sailfish.Silica 1.0
import QtGraphicalEffects 1.0

// This document details a popup gallery view for a particular thread
// It should handle videos and images
// It should be able to toggle loading a thumbnail or the full image
FullscreenContentPage {
    id: imageGalleryViewer
    objectName: "imageGalleryViewer"

    property var imagePosts
    property int selectedImageIndex: 0

    // This shouldn't load just an image
    // It should dynamically load either videoplayer or an image
    SlideshowView {
        id: imageCarousel
        model: imagePosts

        anchors.fill: parent
        delegate: MouseArea {
            width: PathView.view.width
            height: PathView.view.height

            onClicked: {
                // Display carousel overlay
                imageCarouselOverlay.active = !imageCarouselOverlay.active
            }

            Image {
                property bool hiRes: false

                id: galleryImage
                anchors.verticalCenter: parent.verticalCenter
                source: {
                    if (imageCarousel.currentIndex == index || hiRes) {
                        hiRes = true
                        return imgUrl
                    }
                    return thumbUrl
                }
                width: parent.width
                height: parent.height
                fillMode: Image.PreserveAspectFit

                Component.onCompleted: {
                    // Set filename string in carousel overlay
                    filenameLabelOverlay.imageFilename = filename
                    downloadIconButton.downloadUrl = imgUrl
                }
            }
        }

        // Make sure clicked thumbnail is displayed
        Component.onCompleted: {
            currentIndex = selectedImageIndex
        }
    }

    // Overlay that show a way to quit (if the user is too dumb to swipe out)
    // And also provides a means to download the image (not yet implemented)
    // This should probably display the filename too
    Item {
        id: imageCarouselOverlay

        // Determines if visible or not
        property bool active: true

        enabled: active
        anchors.fill: parent
        opacity: active ? 1.0 : 0.0

        Behavior on opacity { FadeAnimator {}}

        IconButton {
            id: closeIconButton
            y: Theme.paddingLarge
            anchors {
                right: parent.right
                rightMargin: Theme.horizontalPageMargin
            }
            icon.source: "image://theme/icon-m-dismiss"
            onClicked: pageStack.pop()

            // There's a couple of ColorOverlays in this component
            // They're here because of a bug with SailfishOS light ambiences
            ColorOverlay {
                anchors.fill: closeIconButton
                source: closeIconButton
                color: "#FFFFFFFF"
            }
        }

        Row {
            anchors  {
                bottom: parent.bottom
                bottomMargin: Theme.paddingLarge
                horizontalCenter: parent.horizontalCenter
            }
            spacing: Theme.paddingLarge

            IconButton {
                property string downloadUrl: ""

                id: downloadIconButton
                icon.source: "image://theme/icon-m-device-download"
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("SaveFilePage.qml"), {uri: downloadUrl})
                }

                ColorOverlay {
                    anchors.fill: downloadIconButton.icon
                    source: downloadIconButton.icon
                    color: "#FFFFFFFF"
                }
            }

            Label {
                property string imageFilename: "none"

                id: filenameLabelOverlay
                text: imageFilename
                color: "#FFFFFFFF"
                font.family: Theme.fontSizeMedium
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}
