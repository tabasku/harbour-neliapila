import QtQuick 2.0
import Sailfish.Silica 1.0

Rectangle{
    id: pageRefresh
    color: "transparent"
    height: Screen.height*0.1
    width: parent.width
    visible : postsModel.count === 0 || busy ? false : true

    Button{
        id : footerRefreshButton
        height: parent.height
        width:parent.width*0.20
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        Image{
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            height: parent.height*0.5
            source:"image://theme/icon-cover-refresh"
            fillMode: Image.PreserveAspectFit
            visible: !busy

            BusyIndicator {
                id: busyIndicator;
                anchors.centerIn: parent;
                size: BusyIndicatorSize.Small;
                running: busy
                visible: busy
            }

        }
        onClicked: {
            console.log(listView.currentIndex + " / " + listView.count)

            listView.scrollToBottom()
            pyp.getPosts(boardId,postNo)
        }

    }

}
