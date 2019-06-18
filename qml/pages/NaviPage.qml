import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.4
import "../items"
import "../js/utils.js" as Utils
import "../js/settingsStorage.js" as SettingsStore

AbstractPage {
    id: naviPage
    property variant show_model: SettingsStore.getSetting("ModelToDisplayOnNavipage", 0) == 0 ? boardModel : favoriteModel
    property bool show_pinned_model: true
    property variant pinModel: ListModel {id: pinModel }

    title: "Boards"

    SilicaListView {
        id: boardListView
        model: show_model
        anchors.fill: parent

        PullDownMenu {
            id: postsPullDownMenu
            busy : busy

            MenuItem {
                id:favorite_menu
                text: "Refresh"
                onClicked: {
                    py.refresh()
                }
            }
        }

        header: PageHeader {
            width: parent.width

            Label {
                id: boardsHeaderLabel
                text: "Boards"
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeLarge

                anchors {
                    margins: Theme.paddingMedium
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }
                color: Theme.highlightColor
            }

            Image {
                source: {
                    if (show_model === boardModel)
                        "image://theme/icon-m-favorite"
                    else
                        "image://theme/icon-m-favorite-selected"
                }

                width: parent.height * 0.6
                height: width
                anchors {
                    verticalCenter: parent.verticalCenter
                    right: boardsHeaderLabel.left
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if(show_model === boardModel)
                            show_model = favoriteModel
                        else
                            show_model = boardModel
                    }
                }
            }
        }

        Button {
            id: moreInfoButton
            visible: false
            text: "More info"
            anchors.centerIn: parent
            anchors.verticalCenterOffset: parent.height*0.1
            property string fullError
            property string errorTitle

            onClicked: {
                pageStack.push(Qt.resolvedUrl("TextPage.qml"),
                               {
                                   "title" : errorTitle,
                                   "fullError": fullError
                               });
            }
        }

        ViewPlaceholder {
            id: boardHolder
            text: "Please stand by..."
            enabled: false
        }

        ListModel {
            id: boardModel
        }

        ListModel {
            id: favoriteModel
        }

        Timer {
            id: smoother
            property int index
            property string board
            interval: 400; running: false; repeat: false
            onTriggered: py.favorite(index,board)

            function run(i,b) {
                index = i
                board = b
                smoother.start()
            }
        }

        delegate: Item {
            id: boardItem
            property Item contextMenu
            property bool menuOpen: contextMenu != null && contextMenu.parent === boardItem
            property bool moving

            height: menuOpen ? contextMenu.height + contentItem.height : contentItem.height
            width: boardListView.width

            BackgroundItem {
                id: contentItem
                anchors {
                    left:parent.left
                    right:parent.right
                    leftMargin: pageMargin
                    rightMargin: pageMargin
                }

                highlighted: {
                    if (board === boardId) {
                        true
                    }
                    else if (moving) {
                        true
                    }

                    else {
                        false
                    }
                }

                GlassItem {
                    id: decorator
                    dimmed: !default_board

                    anchors {
                        right: parent.right
                        rightMargin: Theme.paddingMedium
                        verticalCenter: parent.verticalCenter
                    }
                }

                Label {
                    anchors {
                        left: parent.left
                        leftMargin: Theme.paddingMedium
                        right: decorator.left
                        rightMargin: Theme.paddingMedium
                        verticalCenter: parent.verticalCenter
                    }

                    text: "<b>/"+board+"/</b> - "+title
                }

                Image {
                    anchors {
                        right: decorator.left
                        rightMargin: Theme.paddingSmall
                        verticalCenter: parent.verticalCenter
                    }
                    id: fav_board_icon

                    source: "image://theme/icon-s-favorite"
                    opacity: 0

                    NumberAnimation on opacity {
                        id: fav_opacity_in
                        from: 0
                        to: 1.0
                        running: favorite
                        duration: 500
                    }

                    NumberAnimation on opacity {
                        id: fav_opacity_out
                        from: 1.0
                        to: 0
                        running: !favorite
                        duration: 100
                    }
                }

                onClicked: {
                    var threadPage = pageStack.find(function(page) { return page.objectName === "threadPage"; });

                    threadPage.busy = true
                    threadPage.mode = "thread"
                    threadPage.title = "<b>/"+board+"/</b>"
                    threadPage.change_board(board);
                    naviPage.backNavigation = true
                    pageStack.navigateBack();
                }

                onPressAndHold: {
                    contextMenu = boardContextMenuComponent.createObject(boardListView, {board: board, title: title,favorite: favorite,default_board:!default_board,index:index})
                    contextMenu.open(parent)
                }
            }
        }

        Component {
            id: boardContextMenuComponent

            ContextMenu {
                property var board
                property var title
                property var favorite
                property bool default_board
                property int index

                MenuItem {
                    text: qsTr("Set as default")
                    visible: default_board ? true : false

                    onClicked: {
                        //Storage.set("default_board", board)
                        //updateBoardStatus()
                        py.set_default(index,board)

                    }
                }

                MenuItem {
                    text: {
                        if (favorite) {
                            return "Unfavorite"
                        }
                        else {
                            return "Favorite"
                        }
                    }

                    onClicked: {
                        smoother.run(index,board)
                    }
                }
            }
        }

        add: Transition {
            NumberAnimation { property: "opacity";easing.type: Easing.InQuad; from: 0; to: 1.0; duration: 300 }
        }

        move: Transition {
            id: moveTrans
            SequentialAnimation {
                PropertyAction { property: "moving"; value: "true" }
                NumberAnimation { properties: "x,y"; duration: 800}
                PropertyAction { property: "moving"; value: "false" }
            }
        }

        displaced: Transition {
            NumberAnimation { property: "opacity"; from: 1.0; to: 0.2; duration: 500 }
            NumberAnimation { properties: "x,y"; duration: 500 }
            NumberAnimation { property: "opacity"; from: 0.2; to: 1.0; duration: 500 }
        }

        remove: Transition {
            NumberAnimation { property: "opacity"; from: 1.0; to: 0; duration: 400 }
        }

        VerticalScrollDecorator {}
    }

    onStatusChanged: {
        if (status === PageStatus.Active) {
            py.getBoards()
        }
    }


    Python {
        id: py

        Component.onCompleted: {
            // Add the Python library directory to the import path
            var pythonpath = Qt.resolvedUrl('../../py/').substr('file://'.length);

            addImportPath(pythonpath);

            setHandler('threads', function(result) {
                //To silence onReceived from threads
            });

            setHandler('posts', function(result) {
                //To silence onReceived from posts
            });

            setHandler('pinned_postno', function(result) {
                //To silence onReceived from posts
            });

            setHandler('pinned_board', function(result) {
                //To silence onReceived from posts
            });

            setHandler('pinned_all', function(result) {
                //To silence onReceived from posts
            });

            setHandler('pinned_all_update', function(result) {
                //To silence onReceived from posts
            });

            setHandler('set_challenge', function(result) {
                //To silence onReceived from boards
            });

            setHandler('set_response', function(result) {
                //To silence onReceived from boards
            });

            setHandler('failed_challenge', function(result) {
                //To silence onReceived from boards
            });

            setHandler('post_successfull', function(result) {
                //To silence onReceived from boards
            });

            setHandler('reply_successfull', function(result) {
                //To silence onReceived from boards
            });

            setHandler('post_failed', function(result) {
                //To silence onReceived from boards
            });

            setHandler('reply_failed', function(result) {
                //To silence onReceived from boards
            });

            setHandler('post_set_response', function(result) {
                //To silence onReceived from boards
            });

            setHandler('reply_set_response', function(result) {
                //To silence onReceived from boards
            });

            setHandler('boards', function(result) {
                if (boardHolder.enabled) {
                    boardHolder.enabled = false
                }

                for (var i=0; i<result.length; i++) {
                    if (result[i].favorite) {
                        favoriteModel.append(result[i]);
                    }

                    boardModel.append(result[i]);
                }

                busy = false
            });

            setHandler('DBERR', function(result) {
                console.log("DB commit error "+result)
                busy = false
                boardHolder.text= "Database error :("
                boardHolder.enabled = true
            });

            importModule('boards', function() {});
            importModule('pinned', function() {});
        }

        function getPinned() {
            call('pinned.data.thread_this', ['get_all',{}],function() {});
        }

        function getBoards() {
            busy = true
            call('boards.data.thread_this', ['get'],function() {});
        }

        function refresh() {
            busy = true
            boardModel.clear()
            call('boards.data.thread_this', ['refresh'],function() {});
        }

        function favorite(index,board) {
            var updateItem = boardModel.get(index)
            var favItemIndex

            for (var x=0; x < favoriteModel.count; x++) {
                if (favoriteModel.get(x).board === board) {
                    favItemIndex = x
                }
            }

            if (boardModel.get(index).favorite) {
                updateItem.favorite = 0
                favoriteModel.remove(favItemIndex)
            }
            else {
                updateItem.favorite = 1
                favoriteModel.append(updateItem)
            }

            py.call('boards.toggle_favorite', [board],function(location) {
                boardModel.move(index,location,1)
            });
        }

        function set_default(index,board) {
            var updateItem

            for (var x=0; x < boardModel.count; x++) {
                updateItem = boardModel.get(x)
                if (boardModel.get(x).board !== board) {
                    updateItem.default_board = 0
                }
                else {
                    updateItem.default_board = 1
                }
            }

            py.call('boards.set_default', [board],function() {});
        }

        onError: {
            // when an exception is raised, this error handler will be called
            busy=false
            Utils.tracebackCatcher(traceback,boardHolder)
        }
        onReceived: {
            // asychronous messages from Python arrive here
            // in Python, this can be accomplished via pyotherside.send()
            //console.log('boards got message from python: ' + data);
        }
    }

}





