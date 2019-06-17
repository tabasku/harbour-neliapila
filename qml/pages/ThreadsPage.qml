/*
    Neliapila - 4chan.org client for SailfishOS
    Copyright (C) 2015-2019  Joni Kurunsaari
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

import QtQuick 2.0
import Sailfish.Silica 1.0
import "../items"
import io.thp.pyotherside 1.4
import "../js/utils.js" as Utils
import "../js/settingsStorage.js" as SettingsStore

AbstractPage {
    id: threadPage
    objectName: "threadPage"
    property string mode: "thread"
    property string boardTitle: ""
    property variant currentModel : model
    property bool threadItem:true
    property int pages
    property bool showPinnedPage: false

    title: boardId ? "<b>/"+boardId+"/</b>" : "Neliapila"

    function replacePage() {
        showPinnedPage = true
    }

    function change_board(boardId) {
        if (helpTxt.enabled) {
            helpTxt.enabled = false
        }

        listView.scrollToTop()
        pyt.getThreads(boardId,1)
    }

    function change_page() {
        listView.scrollToTop()
        pyt.getThreads(boardId)
        infoBanner.alert("Reload");
    }

    SilicaListView {
        id: listView
        model: currentModel
        anchors {
            fill: parent
        }

        // Quickscroll being enabled is a user setting
        quickScroll: SettingsStore.getSetting("QuickscrollEnabled") == 1 ? true : false

        VerticalScrollDecorator { flickable: listView }

        PushUpMenu {
            id: mainPushUpMenu
            busy: busy

            MenuItem {
                id:menuBottomRefresh
                text: qsTr("Reload")
                enabled: false
                visible: mode === "thread"
                onClicked: {
                    pyt.getThreads(boardId)
                }
            }
        }

        PullDownMenu {
            id: mainPullDownMenu
            busy : busy

            // Soon...
            MenuItem {
                text: qsTr("Settings")
                onClicked: {
                    pageStack.push("SettingsPage.qml");
                }
            }

            MenuItem {
                id: showPinnedMenu
                text: qsTr("Pinned posts");
                visible: mode === "thread" ? true: false

                onClicked: {
                    showPinnedTimer.start()
                }
            }

            MenuItem {
                text: qsTr("New post");
                enabled: !newPostPanel.open
                onClicked: {
                    newPostPanel.open = !newPostPanel.open
                }
            }

            MenuItem {
                id: backToThreadMode
                text: "Back to <b>/"+boardId+"/</b>"
                visible: mode === "pinned" ? true: false

                onClicked: {
                    showThreadTimer.start()
                }
            }

            MenuItem {
                id:menuRefresh
                text: qsTr("Reload")
                enabled: false
                visible: mode === "thread"
                onClicked: {
                    pyt.getThreads(boardId)
                }
            }

            Label {
                text: boardTitle
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeExtraSmall
                color: Theme.secondaryHighlightColor
                clip: true
                smooth: true
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        header: PageHeader {
            id: pageHeader
            title: threadPage.title //<b>/"+boardId+"/</b>"

            Image {
                id: appIcon
                anchors {
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                    leftMargin: pageMargin
                }
                width: parent.height*0.6;
                height: width
                fillMode: Image.PreserveAspectFit
                smooth: true
                source: "../img/neliapila.png"

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        pageStack.push("AboutPage.qml")
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
                                   "content": fullError
                               });
            }
        }

        ViewPlaceholder {
            id: helpTxt
            text: "No board selected"
            enabled: false
        }

        ListModel {
            id: model
        }

        ListModel {
            id: pinModel
        }

        delegate: PostItem {
            id: delegate
        }

        Component {
            id: contextMenuComponent

            ContextMenu {
                property int index
                property bool pin

                MenuItem {
                    visible: pin ? true : false
                    text: qsTr("Remove pin")
                    onClicked: {
                        pyt.unpin(index)
                    }
                }

                MenuItem {
                    visible: pin ? false : true
                    text: qsTr("Add pin")
                    onClicked: {
                        pyt.pin(index)
                    }
                }
            }
        }

        add: Transition {
            NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 300 }
        }

        remove: Transition {
            NumberAnimation { property: "opacity"; from: 1.0; to: 0; duration: 300 }
        }

        displaced: Transition {
            NumberAnimation { properties: "x,y"; duration: 800; easing.type: Easing.InSine }
        }
    }

    DockedNewPost {
        id: newPostPanel
        width: parent.width
        dock: Dock.Bottom //threadPage.isPortrait ? Dock.Top : Dock.Right
    }

    Component.onCompleted: {
        if (boardId) {
            pyt.getThreads(boardId,1)
        }
        else {
            pyt.call('threads.get_default',[],function(result) {
                if (typeof result === 'undefined') {
                    busy = false
                    helpTxt.enabled = true
                }
                else {
                    boardId = result
                    pageNo = 1
                    pyt.getThreads(result,1)
                }
            });
        }
    }

    Timer {
        id: showThreadTimer
        interval: 500; running: false; repeat: false
        onTriggered: {
            helpTxt.enabled = false
            mode = "thread"
            title ="<b>/"+boardId+"/</b>"
            currentModel = model
        }
    }

    Timer {
        id: showPinnedTimer
        interval: 500; running: false; repeat: false
        onTriggered: pyt.getPinned()
    }

    onStatusChanged: {
        if (status === PageStatus.Active && pageStack.depth === 1 && mode === "thread") {
            pageStack.pushAttached(Qt.resolvedUrl("NaviPage.qml"),{boardId: boardId} );
            if (model.count != 0) {
                pyt.call('pinned.data.thread_this', ['get_by_board',{'board':boardId}],function() {});
            }
        }
        else if (status === PageStatus.Active && pageStack.depth === 1 && mode === "pinned") {
            pageStack.pushAttached(Qt.resolvedUrl("NaviPage.qml"),{boardId: boardId} );
            pyt.getPinned()
        }
    }

    Python {
        id: pyt

        Component.onCompleted: {
            // Add the Python library directory to the import path
            var pythonpath = Qt.resolvedUrl('../../py/').substr('file://'.length);

            addImportPath(pythonpath);

            // Manage/silence onReceived from boards
            setHandler('boards', function(result) { });
            setHandler('posts', function(result) { });
            setHandler('pinned_postno', function(result) { });
            setHandler('posts_status', function(result) { });

            setHandler('pinned_board', function(result) {
                for (var i=0; i<model.count; i++) {
                    var no = model.get(i)['no']

                    var updateItem
                    updateItem = model.get(i)

                    if (result.indexOf(no) >= 0) {
                        updateItem.pin = 1
                    }
                    else {
                        updateItem.pin = 0
                    }
                }
            });

            setHandler('threads', function(result) {
                for (var i=0; i<result.length; i++) {
                    model.append(result[i]);
                }

                busy = false
                menuRefresh.enabled = true
                menuBottomRefresh.enabled = true

                call('pinned.data.thread_this', ['get_by_board',{'board':boardId}],function() {});

                call('threads.get_pages', [boardId],function(pages) {
                    threadPage.pages = pages
                });
            });

            setHandler('pinned_all', function(result) {
                for (var i=0; i<result.length; i++) {
                    pinModel.append(result[i]);
                }

                if (!result.length) {
                    helpTxt.text = "No pinned posts"
                    helpTxt.enabled = true
                }

                busy = false
            });

            setHandler('pinned_all_update', function(result) {
                for (var i=0; i<pinModel.count; i++) {

                    var no = pinModel.get(i)['no']

                    var updateItem
                    updateItem = pinModel.get(i)

                    updateItem.postCount = result[i]['postCount']

                }
            });

            importModule('threads', function() {});
            importModule('pinned', function() {});

            setHandler('reply_successfull', function(result) { });
            setHandler('reply_failed', function(result) { });
            setHandler('set_challenge', function(result) { });
            setHandler('reply_set_response', function(result) { });

            importModule('posting', function() {});

            setHandler('post_successfull', function(result) {
                console.log("SUCCESS : "+result);
                newPostPanel.busy = false;
                newPostPanel.open = false;
                newPostPanel.clearFields();
                threadPage.forwardNavigation = true;
                var newPostId = result[1];

                pyt.getThreads(boardId);
                Remorse.popupAction(threadPage, "Post sent, opening your thread", function() {
                    console.log("remorse fired")
                    pageStack.push("PostsPage.qml", {postNo: newPostId, boardId: boardId, pinned: false} )
                })

            });

            setHandler('post_failed', function(result) {
                console.log("FAILED : "+result);
                if (String(result).search('banned')) {
                    infoBanner.alert("You are banned ;_;");
                }
                else {
                    infoBanner.alert("Failed to send");
                }
                newPostPanel.busy = false;
                threadPage.forwardNavigation = true;

            });

            setHandler('post_set_response', function(result) {
                if (result.length === 1) {
                    console.log("threads post_set_response "+result);
                    newPostPanel.captcha_token = result[0]
                    newPostPanel.busy = true
                    post()
                }
                else {
                    infoBanner.alert("Something went wrong, try reverify");
                }
            });
        }

        function post() {
            console.log("posting with captchatoken "+newPostPanel.captcha_token)
            console.log("posting with filepath "+newPostPanel.selectedFile)
            console.log("posting with subject "+newPostPanel.subject)
            console.log("posting to board "+boardId)

            call('posting.post', [
                     newPostPanel.nickname,
                     newPostPanel.comment,
                     newPostPanel.subject,
                     newPostPanel.selectedFile,
                     newPostPanel.captcha_token,
                     boardId
                 ], function() {});
        }

        function getThreads(boardId) {
            busy = true

            if (model.count !== 0) {
                model.clear()
            }

            if (currentModel === pinModel) {
                pinModel.clear()
                currentModel = model
            }

            threadPage.boardId = boardId

            call('threads.data.thread_this', ['get',{'board':boardId}],function() {});
        }

        function getPinned() {
            busy=true
            pinModel.clear()
            currentModel = pinModel
            helpTxt.enabled = false
            mode = "pinned"
            title = "Pinned posts"
            call('pinned.data.thread_this', ['get_all',{}],function() {});
        }

        function pin(index) {
            var model = currentModel

            var postNo = model.get(index)['no']
            var board = model.get(index)['post_board']
            var com = model.get(index)['com']
            var thumbUrl = model.get(index)['thumbUrl']
            var time = model.get(index)['time']
            var replies = model.get(index)['replies_count']

            call('pinned.add_pin', [postNo,board,com,thumbUrl,time,replies],function() {
                updateItem(1,index)
            });
        }

        function unpin(index) {
            var model = currentModel

            var postNo = model.get(index)['no']
            var board = model.get(index)['post_board']

            call('pinned.delete_pins', [postNo,board],function() {
                updateItem(0,index)
            });
        }

        function updateItem(pin,index) {
            var model = currentModel

            switch(mode){
            case "thread":
                var updateItem
                updateItem = model.get(index)
                updateItem.pin = pin
                break;
            case "pinned":
                model.remove(index)
                break;
            }
        }

        onError: {
            // when an exception is raised, this error handler will be called
            console.log('threads python error: ' + traceback);
            busy=false
            Utils.tracebackCatcher(traceback,helpTxt)
        }
        onReceived: {
            // asychronous messages from Python arrive here
            // in Python, this can be accomplished via pyotherside.send()
            console.log('threads got message from python: ' + data);
        }
    }
}
