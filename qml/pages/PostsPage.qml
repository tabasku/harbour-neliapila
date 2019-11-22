/*
    Neliapila - 4chan.org client for SailfishOS
    Copyright (C) 2015-2019  Joni Kurunsaari
    Copyright (C) 2019  Jacob Gold
    Copyright (C) 2019  szopin
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
    id: postsPage
    objectName: "postsPage"
    property string mode: "post";
    property string singlePost;
    property var postsToShow;
    property int totalPosts: 0
    property var modelToStrip;
    property bool pinned;
    property int repscount;
    property int replyTo: postNo
    property int reloadTime: {
        switch( SettingsStore.getSetting("ThreadRefreshTime") ) {
        case "0" :
            return 60
        case "1" :
            return 45
        case "2" :
            return 30
        default :
            return -1
        }
    }

    function getBackToPost() {
        pageStack.pop(pageStack.find( function(page){ return(page._depth === 1)} ), PageStackAction.Immediate)
    }

    function returnModel() {
        return postsModel
    }

    title: "<b>/" + boardId + "/</b>"+postNo

        SilicaListView {
            id: listView
            model: postsModel
            anchors.fill: parent
            focus: true

            // Quickscroll being enabled is a user setting
            quickScroll: SettingsStore.getSetting("QuickscrollEnabled") == 1 ? true : false
            VerticalScrollDecorator {}

            PushUpMenu {
                id: postsPushUpMenu
                busy: busy

                MenuItem {
                    property int lastPost: 0
                    text: qsTr("Update thread")
                    visible: pageStack.depth === 2
                    onClicked: {
                        pyp.getPosts(boardId,postNo)
                        infoBanner.alert("Fetching new posts...")
                    }
                }

                MenuItem {
                    text: "Add pin"
                    visible: !pinned && pageStack.depth === 2
                    onClicked: {
                        pyp.pin(postNo,boardId)
                    }
                }

                MenuItem {
                    text: "Remove pin"
                    visible: pinned && pageStack.depth === 2
                    onClicked: {
                        pyp.unpin(postNo,boardId)
                    }
                }

                MenuItem {
                    text: qsTr("Reply")
                    enabled: !replyPostPanel.open
                    visible: pageStack.depth === 2
                    onClicked: {
                        replyPostPanel.open = !replyPostPanel.open
                    }
                }

                MenuItem {
                    text: qsTr("Back to " + postNo )
                    visible: pageStack.depth !== 2
                    onClicked: {
                        getBackToPost()
                    }
                }
            }

            PullDownMenu {
                id: postsPullDownMenu
                busy : busy

                MenuItem {
                    text: qsTr("Open thread in browser")
                    onClicked: {
                        var url = "https://boards.4chan.org/"+boardId+"/thread/"+postNo
                        infoBanner.alert("Opening thread in web browser");
                        Qt.openUrlExternally(url)
                    }
                }
                MenuItem {
                    text: qsTr("Open thread in webview")
                    onClicked: {
                        var url = "https://boards.4chan.org/"+boardId+"/thread/"+postNo
                        onClicked: pageStack.push("WebViewPage.qml", {"pageurl": url });
                    }
                }

                MenuItem {
                    text: "Add pin"
                    visible: !pinned && pageStack.depth === 2
                    onClicked: {
                        pyp.pin(postNo,boardId)
                    }
                }
                
                MenuItem {
                    text: "Scroll to last loaded"
                    visible: pinned && repscount !== 0
                    onClicked: {
                        listView.positionViewAtIndex(postsModel.count - repscount, ListView.Beginning);
                    }
                }
                
                MenuItem {
                    text: "Remove pin"
                    visible: pinned && pageStack.depth === 2
                    onClicked: {
                        pyp.unpin(postNo,boardId)
                    }
                }

                MenuItem {
                    text: qsTr("Back to " + postNo )
                    visible: pageStack.depth !== 2
                    onClicked: {
                        getBackToPost()
                    }
                }

                MenuItem {
                    text: qsTr("Reply")
                    enabled: !replyPostPanel.open
                    visible: pageStack.depth === 2
                    onClicked: {
                        replyPostPanel.open = !replyPostPanel.open
                    }
                }

                MenuItem {
                    text: qsTr("Reload")
                    visible: pageStack.depth === 2
                    onClicked: {
                        pyp.getPosts(boardId,postNo)
                        infoBanner.alert("Fetching new posts...")
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
                id: postViewPlaceholder
                text: "Something crashed..."
                enabled: false
            }

            header: PageHeader {
                title: {
                    if(postsToShow) {
                        qsTr("<b>/" + boardId + "/</b>"+postNo+"/replies")
                    }
                    else {
                        qsTr("<b>/" + boardId + "/</b>"+postNo)
                    }
                }
            }

            ListModel {
                id: postsModel
            }

            Component {
                id: contextMenuComponent

                ContextMenu {
                    property string postReplies
                    property string com
                    property var quote
                    property var thisPostNo
                    property var modelToStrip
                    visible: mode === "thread" ? false : true

                    MenuItem {
                        visible: postReplies && !replyPostPanel.open ? true : false

                        text: qsTr("View replies")
                        onClicked: {
                            postsToShow = postReplies
                            if(modelToStrip) {
                                pageStack.push(Qt.resolvedUrl("../pages/PostsPage.qml"), {
                                                   postNo: thisPostNo,
                                                   boardId: boardId,
                                                   modelToStrip : modelToStrip,
                                                   postsToShow : postsToShow
                                               } )
                            }
                            else {
                                console.log("no modelstrip")
                                pageStack.push(Qt.resolvedUrl("../pages/PostsPage.qml"), {
                                                   postNo: thisPostNo,
                                                   boardId: boardId,
                                                   modelToStrip : postsModel,
                                                   postsToShow : postsToShow
                                               } )
                            }
                        }
                    }

                    MenuItem {
                        text: qsTr("Quote")
                        onClicked: {
                            replyPostPanel.open = true
                            replyPostPanel.addQuote(String(">>"+thisPostNo));
                        }
                    }

                    MenuItem {
                        text: qsTr("Quote text")
                        visible: com !== "" ? true : false
                        onClicked: {
                            var strippedComment = com.replace(/<(?:.|\n)*?>/gm, '');
                            var quote = String(">>"+thisPostNo + "\n>"+strippedComment.replace(/>>\d+/gm, ''))
                            console.log(strippedComment)
                            replyPostPanel.open = true;

                            replyPostPanel.addQuote(quote);
                        }
                    }
                }
            }

            WorkerScript {
                id: stripper
                source: "../js/stripper.js"
                onMessage: {
                    busy = messageObject.busy
                }
                function work() {
                    sendMessage({
                                    'postNo': postNo,
                                    'model': postsModel,
                                    'postsToShow': postsToShow,
                                    'modelToStrip': modelToStrip
                                });
                }
            }

            delegate: PostItem {
                id: delegate
            }

            add: Transition {
                NumberAnimation { property: "opacity"; easing.type: Easing.InQuad; from: 0; to: 1.0; duration: 300 }
            }

            populate: Transition {
                NumberAnimation { property: "opacity"; easing.type: Easing.OutBounce; from: 0; to: 1.0; duration: 500 }
            }

            footer: Rectangle {
                color: "transparent"
                height: Screen.height*0.1
                width: parent.width
                visible : (pageStack.depth !== 2) ? false : true

                Label {
                        id: postCountFooterLabel
                        text: postsModel.count + " posts total"
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: 22
                }

                Label {
                    id: countDownFooterLabel
                    property int timeUntilReload: reloadTime
                    text: {
                        if (busy)
                            return "Working..."
                        return "reloading in " + timeUntilReload
                    }
                    font.pixelSize: Theme.fontSizeExtraSmall
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: postCountFooterLabel.bottom
                }

                Timer {
                    id: postFetchingCounter
                    property int counter: reloadTime
                    interval: 1000; running: true; repeat: true
                    onTriggered: {
                        if (reloadTime === -1) {
                            postFetchingCounter.running = false
                            countDownFooterLabel.text = "Automatic post fetching is disabled"
                        }

                        if (!busy && pageStack.depth === 2) {
                            if (counter == 0) {
                                counter = reloadTime
                                pyp.getPosts(boardId,postNo)
                            }

                            countDownFooterLabel.timeUntilReload = counter
                            counter = counter - 1
                        }
                    }
                }
            }
        }

        DockedNewPost {
            id: replyPostPanel
            width: parent.width
            dock: Dock.Bottom //postsPage.isPortrait ? Dock.Bottom : Dock.Right
            onOpenChanged: {
                replyPostPanel.replyTo = postNo;
            }
        }

    Component.onCompleted: {
        pyp.getPosts(boardId,postNo)
        hideBusyIndicator()
    }

    Python {
        id: pyp

        Component.onCompleted: {
            // Add the Python library directory to the import path
            var pythonpath = Qt.resolvedUrl('../../py/').substr('file://'.length);
            addImportPath(pythonpath);

            setHandler('posts', function(result) {
                // Only append new posts
                if (pageStack.depth === 2) {
                    for (var i=totalPosts; i<result.length; i++) {
                        postsModel.append(result[i]);
                    }
                }

                busy = false
                updateItem(pinned)

                if(pinned){
                    var replies_count = postsModel.count-1

                    call('pinned.update_pin', [postNo,boardId,replies_count],function() {
                        console.log("update pin " + postNo,boardId + " reply count now " + replies_count)
                    });
                }
            });

            setHandler('posts_status', function(result) {
                busy = false
                postPlaceholder.text= "404: Page not found"
                postPlaceholder.enabled = true
            });

            setHandler('pinned_all_update', function(result){});

            importModule('posts', function() {});
            importModule('pinned', function() {});
            importModule('posting', function() {});

            setHandler('set_challenge', function(result) {});

            setHandler('reply_successfull', function(result) {
                console.log("SUCCESS : "+result);
                replyPostPanel.busy = false
                replyPostPanel.open = false
                replyPostPanel.clearFields();

                infoBanner.alert("Reply sent, reloading..")
                pyp.getPosts(boardId,postNo)
            });

            setHandler('reply_failed', function(result) {
                console.log("FAILED REPLY: "+result);

                if(String(result).search('banned')) {
                    infoBanner.alert("You are banned ;_;");
                }
                else {
                    infoBanner.alert("Failed to send");
                }
                replyPostPanel.busy = false;
            });

            setHandler('reply_set_response', function(result) {
                if(result.length === 1) {
                    //console.log("set_response fired from reply "+result);
                    replyPostPanel.captcha_token = result[0]
                    replyPostPanel.busy = true
                    post()
                }
                else {
                    infoBanner.alert("Something went wrong, try reverify")
                }
            });
        }

        function getPosts(boardId,postNo) {
            busy = true

            postsPage.totalPosts = postsModel.count

            postsPage.boardId = boardId
            postsPage.postNo = postNo

            if(!postsToShow) {
                call('posts.data.thread_this', ['get',{'board':boardId,'postno':postNo}],function() {});
            }
            else {
                //Create page from previous model by stripping it
                stripper.work()
            }
        }

        function pin(postNo,boardId) {
            var com = postsModel.get(0)['com']
            var thumbUrl = postsModel.get(0)['thumbUrl']
            var time = postsModel.get(0)['time']
            var replies = postsModel.count-1

            call('pinned.add_pin', [postNo,boardId,com,thumbUrl,time,replies],function() {
                pinned = true
                updateItem(pinned)
            });
        }

        function unpin(postNo,boardId) {
            call('pinned.delete_pins', [postNo,boardId],function() {
                pinned = false
                updateItem(pinned)
            });
        }

        function updateItem(pinned) {
            if (pageStack.depth === 2 && postsModel.count !== 0) {
                var pin
                if(pinned) {
                    pin = 1
                }
                else {
                    pin = 0
                }

                var updateItem
                updateItem = postsModel.get(0)
                updateItem.pin = pin
            }
        }


        function post() {
            console.log("Replying to "+postNo)
            console.log("posting with captchatoken "+replyPostPanel.captcha_token)
            console.log("posting with filepath "+replyPostPanel.selectedFile)
            console.log("posting with subject "+replyPostPanel.subject)
            console.log("posting with comment "+replyPostPanel.comment)
            console.log("posting to board "+boardId)

            call('posting.post', [
                     replyPostPanel.nickname,
                     replyPostPanel.comment,
                     replyPostPanel.subject,
                     replyPostPanel.selectedFile,
                     replyPostPanel.captcha_token,
                     boardId,
                     replyTo
                 ], function() {});
        }

        onError: {
            // when an exception is raised, this error handler will be called
            //console.log('posts python error: ' + traceback);
            postsModel.clear()
            busy = false

            Utils.tracebackCatcher(traceback,postPlaceholder)
        }

        onReceived: {
            // asychronous messages from Python arrive here
            // in Python, this can be accomplished via pyotherside.send()
            console.log('posts got message from python: ' + data);
        }
    }
}
