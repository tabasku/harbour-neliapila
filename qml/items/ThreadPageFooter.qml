import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: pageNav
    height: Screen.height*0.1
    width: parent.width

    Rectangle {
        id: backButton
        color: "transparent"
        height: parent.height
        width: parent.width*0.40
        anchors.left: parent.left

        Image {
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            height: parent.height*0.5
            source:"image://theme/icon-cover-previous"
            fillMode: Image.PreserveAspectFit
            opacity: threadPage.pageNo === 1 ? 0.1 : 1
        }

        MouseArea {
            anchors.fill: parent
            enabled: threadPage.pageNo === 1 ? false : true
            onClicked: {
                pageNo--
                listView.scrollToTop()
                pyt.getThreads(boardId,pageNo)
            }
        }
    }

    Rectangle {
        id: pageNoRect
        color: "transparent"
        anchors.right:nextButton.left
        height: parent.height
        width: parent.width*0.20

        Button {
            text: "<b>"+threadPage.pageNo+"</b>"
            height: parent.height
            width:parent.width
            onClicked: {
                pageStack.push(Qt.resolvedUrl("PageDialog.qml"),
                               {
                                   "pages": threadPage.pages,
                                   "boardId": threadPage.boardId,
                               });
            }
        }
    }

    Rectangle {
        id: nextButton
        color: "transparent"
        height: parent.height
        width: parent.width*0.40
        anchors.right: parent.right

        Image {
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            height: parent.height*0.5
            source:"image://theme/icon-cover-next"
            fillMode: Image.PreserveAspectFit
            opacity: {
                if (threadPage.pageNo < threadPage.pages) {
                    1
                }
                else {
                    0.1
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            enabled: threadPage.pageNo < threadPage.pages ? true : false
            onClicked: {
                listView.scrollToTop()
                if (pageNo < threadPage.pages) {
                    pageNo++
                }
                pyt.getThreads(boardId,pageNo)
            }
        }
    }
}
