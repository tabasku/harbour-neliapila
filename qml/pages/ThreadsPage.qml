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

    SilicaListView {
        id: listView
        model: currentModel
        anchors.fill: parent
        contentHeight: threadPage.height
        focus: true

        PullDownMenu {
            id: mainPullDownMenu

            busy : busy

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

//                MenuItem {
//                    text: qsTr("Open thread in browser")
//                    onClicked: {
//                        var url = "https://boards.4chan.org/"+boardId+"/thread/"+postNo
//                        infoBanner.alert("Opening thread in browser");
//                        Qt.openUrlExternally(url)
//                    }
//                }
            }
        }

        add: Transition {
            NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 300 }
            //NumberAnimation { property: "scale"; easing.type: Easing.InQuint; from: 0; to: 1.0; duration: 500 }

        }

        remove: Transition {
            NumberAnimation { property: "opacity"; from: 1.0; to: 0; duration: 300 }
            //NumberAnimation { property: "scale"; easing.type: Easing.InQuint; from: 1.0; to: 0; duration: 1000 }
        }

        displaced: Transition {
            NumberAnimation { properties: "x,y"; duration: 800; easing.type: Easing.InSine }
        }

        footer: ThreadPageFooter{
            id: pageNav
            visible : model.count<5 || mode === "pinned" ? false : true
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

    Python {
        id: pyt

        Component.onCompleted: {
            // Add the Python library directory to the import path
            var pythonpath = Qt.resolvedUrl('../py/').substr('file://'.length);
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

                //                for (var i=0; i<result.length; i++) {
                //                    //model.append(result[i]);
                //                    console.log(result[i]['postNo'])
                //                    model.get()

                //                }

                //To silence onReceived from pinned
            });

            setHandler('threads', function(result) {
                for (var i=0; i<result.length; i++) {
                    model.append(result[i]);
                }

                busy = false
                menuRefresh.enabled = true

                call('pinned.data.thread_this', ['get_by_board',{'board':boardId}],function() {});

                call('threads.get_pages', [boardId],function(pages) {
                    //console.log(threadPage.pages)
                    threadPage.pages = pages
                    //console.log(threadPage.pages)
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
            //model.clear()
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
