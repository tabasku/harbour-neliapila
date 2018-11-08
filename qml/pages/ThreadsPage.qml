import QtQuick 2.0
import Sailfish.Silica 1.0
import "../items"
import io.thp.pyotherside 1.4
import "../js/utils.js" as Utils

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

    function replacePage(){
        showPinnedPage = true
    }

    function change_board(boardId){
        if(helpTxt.enabled){
            helpTxt.enabled = false
        }

        listView.scrollToTop()
        pyt.getThreads(boardId,1)
    }

    function change_page(pageNo){
        listView.scrollToTop()
        pyt.getThreads(boardId,pageNo)
        infoBanner.alert("Page "+pageNo);
    }

    Drawer {
        id: drawer

        anchors.fill: parent
        dock: threadPage.isPortrait ? Dock.Top : Dock.Left
        //height: screen.height

        background: PostEditor {}

    SilicaListView {
        id: listView
        model: currentModel
        //anchors.fill: parent
        anchors {
            fill: parent
        }
        //focus: true
        VerticalScrollDecorator {}

        //height:  drawer.open ? parent.height/2 : parent.height


        MouseArea {
            enabled: drawer.open
            anchors.fill: parent
            onClicked: {
                drawer.open = false
                threadPage.forwardNavigation = true
            }
        }

        PullDownMenu {
            id: mainPullDownMenu
            enabled: drawer.open ? false : true
            visible: drawer.open ? false : true

            busy : busy

//            MenuItem {
//                text: qsTr("Settings")
//                onClicked: {
//                    pageStack.push("SettingsPage.qml");
//                }
//            }
/*
            MenuItem {
                text: qsTr("About")
                onClicked: {
                    pageStack.push("AboutPage.qml");
                }
            }
*/
            MenuItem {
                id: showPinnedMenu
                text: qsTr("Pinned posts");
                visible: mode === "thread" ? true: false

                onClicked: {
                    showPinnedTimer.start()
                }
            }

            MenuItem {
                id: backToThreadMode
                //text: qsTr("/"+ boardId+"/")
                text: "Back to <b>/"+boardId+"/</b>"
                visible: mode === "pinned" ? true: false

                onClicked: {
                    showThreadTimer.start()
                }
            }

            MenuItem {
                id:menuRefresh
                text: qsTr("Refresh")
                enabled: false

                onClicked: {
                    pyt.getThreads(boardId,pageNo)
                    infoBanner.alert("Refreshing...")
                }
            }
            Label{
                text: boardTitle
                //wrapMode: Text.WordWrap
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
                anchors{
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

        Button{
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

        delegate: PostItem{
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
                    onClicked:{
                        pyt.unpin(index)
                    }
                }

                MenuItem {
                    visible: pin ? false : true
                    text: qsTr("Add pin")
                    onClicked:{
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

        footer: ThreadPageFooter{
            id: pageNav
            visible : model.count<5 || mode === "pinned" ? false : true
        }
    }

        DockedNewPost {
            id: newPostPanel

            width: parent.width
            //height: screen.height*0.4

            /*
            PostEditorDocked {
                id: newPostItem
                anchors.centerIn: parent
            }*/

            dock: threadPage.isPortrait ? Dock.Bottom : Dock.Right
        }

    }

    Component.onCompleted: {

        if(boardId){
            pyt.getThreads(boardId,1)
        }
        else{
            pyt.call('threads.get_default',[],function(result){
                if(typeof result === 'undefined'){
                    busy = false
                    helpTxt.enabled = true
                    //pageStack.navigateForward();
                }
                else{
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
            if(model.count != 0){
                pyt.call('pinned.data.thread_this', ['get_by_board',{'board':boardId}],function() {});
            }
        }
        else if (status === PageStatus.Active && pageStack.depth === 1 && mode === "pinned") {
            pageStack.pushAttached(Qt.resolvedUrl("NaviPage.qml"),{boardId: boardId} );
            pyt.getPinned()
        }
    }

    IconButton {
        anchors {
            //right: (threadPage.isPortrait ? parent.right : parent.left)
            //bottom: (threadPage.isPortrait ? infoPanel.top : parent.bottom)
            right: parent.right
            bottom: parent.bottom
            margins: {
                left: Theme.paddingLarge
                bottom: Theme.paddingLarge
            }
        }

        id: newPost
        width: Theme.iconSizeLarge
        height: width
        visible: !isPortrait ? true : !newPostPanel.open
        enabled: boardId ? true: false
        icon.source: newPostPanel.open
                     ? "image://theme/icon-l-clear"
                     : "image://theme/icon-l-add"
        onClicked: {
            newPostPanel.open = !newPostPanel.open


            //newPostPanel.show()
            //drawer.open = true
            threadPage.forwardNavigation = !newPostPanel.open
        }
    }

    Python {
        id: pyt

        Component.onCompleted: {
            // Add the Python library directory to the import path
            var pythonpath = Qt.resolvedUrl('../../py/').substr('file://'.length);

            //var pythonpath = Qt.resolvedUrl('.').substr('file://'.length);
            addImportPath(pythonpath);
            //console.log("Threads: "+pythonpath);

            setHandler('boards', function(result) {
                //To silence onReceived from boards
            });

            setHandler('posts', function(result) {
                //To silence onReceived from posts
            });

            setHandler('pinned_postno', function(result) {
                //To silence onReceived from pinned
            });

            setHandler('posts_status', function(result) {
                //To silence onReceived from pinned
            });
/*
            setHandler('set_challenge', function(result) {
                //To silence onReceived from boards
            });

            setHandler('set_response', function(result) {
                //To silence onReceived from boards
            });

            setHandler('failed_challenge', function(result) {
                //To silence onReceived from boards
            });*/

            setHandler('pinned_board', function(result) {

                for (var i=0; i<model.count; i++) {

                    var no = model.get(i)['no']

                    var updateItem
                    updateItem = model.get(i)

                    if(result.indexOf(no) >= 0) {
                        //console.log("THIS POST IS PINNED: " + no)
                        updateItem.pin = 1
                    }
                    else{
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

                call('pinned.data.thread_this', ['get_by_board',{'board':boardId}],function() {});

                call('threads.get_pages', [boardId],function(pages) {
                    threadPage.pages = pages
                });

            });

            setHandler('pinned_all', function(result) {

                for (var i=0; i<result.length; i++) {
                    pinModel.append(result[i]);
                }

                if(!result.length){
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

                    for (var i=0; i<result.length; i++) {
                        updateItem.postCount = result[i]['postCount']
                        //updateItem.threadDead = result[i]['threadDead']
                        //updateItem.closed = result[i]['closed']
                    }

                }

            });

            importModule('threads', function() {});
            importModule('pinned', function() {});

            importModule('posting', function() {});

             setHandler('post_successfull', function(result) {
                 console.log("SUCCESS : "+result);
                 newPostPanel.busy = true
                 newPostPanel.open = false

                 infoBanner.alert("Post sent")

             });

            setHandler('post_failed', function(result) {
                console.log("FAILED : "+result);
                infoBanner.alert("Failed to send");
                newPostPanel.busy = false;

            });

            setHandler('set_response', function(result) {
                if(result.length === 1){
                    console.log("set_response fired"+result);
                    newPostPanel.captcha_token = result[0]
                    newPostPanel.busy = true
                    post()
                }
                else {
                    infoBanner.alert("Something went wrong, try reverify")
                }

            });

        }



        function post(){
            if(!newPostPanel.comment.length){infoBanner.alert("Cannot post without comment");return}
            console.log("posting with captchatoken "+newPostPanel.captcha_token)
            console.log("posting with filepath "+newPostPanel.selectedFile)
            console.log("posting with subject "+newPostPanel.subject)

            call('posting.post', [
                     newPostPanel.nickname,
                     newPostPanel.comment,
                     newPostPanel.subject,
                     newPostPanel.selectedFile,
                     newPostPanel.captcha_token
                 ], function() {});
            //(nickname="", comment="", subject="", file_attach="", captcha_response="")

        }

        function getThreads(boardId,pageNo){
            busy = true

            if(model.count !== 0){
                model.clear()
            }
            if(currentModel === pinModel){
                pinModel.clear()
                currentModel = model

                console.log("Model changed to model")
            }

            threadPage.boardId = boardId
            threadPage.pageNo = pageNo

            call('threads.data.thread_this', ['get',{'board':boardId,'page':pageNo}],function() {});

        }

        function getPinned(){
            busy=true
            pinModel.clear()
            currentModel = pinModel
            helpTxt.enabled = false
            mode = "pinned"
            title = "Pinned posts"
            call('pinned.data.thread_this', ['get_all',{}],function() {});
        }

        function pin(index){

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

        function unpin(index){
            var model = currentModel

            var postNo = model.get(index)['no']
            var board = model.get(index)['post_board']

            call('pinned.delete_pins', [postNo,board],function() {
                updateItem(0,index)
            });

        }

        function updateItem(pin,index){

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
/*
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
        }*/
    }
}
