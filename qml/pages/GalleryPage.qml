import QtQuick 2.0
import Sailfish.Silica 1.0

AbstractPage {
    id: galleryPage
    objectName: "gallleryPage"

    property string boardId;
    property string leadPost;
    property var posts;

    title: "Gallery"

    ListModel {
        id: imagePosts
//        dynamicRoles: true
    }

    SilicaGridView {
        id: imageGrid
        model: imagePosts
        anchors.fill: parent
        focus: true
        cellWidth: parent.width / 5
        cellHeight: cellWidth

        header: PageHeader {
            title: {
                qsTr("<b>/" + boardId + "/</b>" + leadPost + " Gallery")
            }
        }

        delegate: Image {
            id: postImage
            source: thumbUrl
            width: imageGrid.cellWidth
            height: imageGrid.cellHeight
            fillMode: Image.PreserveAspectCrop

            MouseArea {
                enabled:true
                anchors.fill: parent

                onClicked: {
                    pageStack.push(Qt.resolvedUrl("GalleryImageViewer.qml"), {
                                       imagePosts: imagePosts,
                                       selectedImageIndex: index
                                   })
                }
            }
        }

        ViewPlaceholder {
            id: postViewPlaceholder
            text: "Something crashed..."
            enabled: false
        }

        add: Transition {
            NumberAnimation { property: "opacity"; easing.type: Easing.InQuad; from: 0; to: 1.0; duration: 300 }
        }

        populate: Transition {
            NumberAnimation { property: "opacity"; easing.type: Easing.OutBounce; from: 0; to: 1.0; duration: 500 }
        }
    }

    onStatusChanged: {
        if (status == PageStatus.Activating) {
            for (var i = 0; i < posts.count; i++) {
                if (posts.get(i)['thumbUrl']) {
                    imagePosts.append({
                                          "thumbUrl": posts.get(i)['thumbUrl'],
                                          "imgUrl": posts.get(i)['imgUrl'],
                                          "filename": posts.get(i)['filename'],
                                          "ext": posts.get(i)['ext']
                                      })
                }
            }
        }
    }
}
