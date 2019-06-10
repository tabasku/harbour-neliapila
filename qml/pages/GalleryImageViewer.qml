import QtQuick 2.0
import Sailfish.Silica 1.0
import QtGraphicalEffects 1.0

FullscreenContentPage {
    id: imageGalleryViewer
    objectName: "imageGalleryViewer"

    property var imagePosts

    SlideshowView {
        id: imageCarousel
        model: imagePosts

        anchors.fill: parent
        delegate: MouseArea {
            width: PathView.view.width
            height: PathView.view.height

            onClicked: imageCarouselOverlay.active = !imageCarouselOverlay.active

            Image {
                anchors.verticalCenter: parent.verticalCenter
                source: thumbUrl
                width: parent.width
                height: parent.height
                fillMode: Image.PreserveAspectFit
            }
        }

        onCurrentIndexChanged: {
            console.log(model.get(currentIndex))
        }
    }


    Item {
        id: imageCarouselOverlay

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
        }

        ColorOverlay {
            anchors.fill: closeIconButton
            source: closeIconButton
            color: "#FFFFFFFF"
        }

        Row {
            anchors  {
                bottom: parent.bottom
                bottomMargin: Theme.paddingLarge
                horizontalCenter: parent.horizontalCenter
            }
            spacing: Theme.paddingLarge

            IconButton {
                id: downloadIconButton
                icon.source: "image://theme/icon-m-device-download"
            }

            ColorOverlay {
                anchors.fill: downloadIconButton.icon
                source: downloadIconButton.icon
                color: "#FFFFFFFF"
            }
        }
    }
}
