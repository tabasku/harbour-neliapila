import QtQuick 2.0
import Sailfish.Silica 1.0
import "../items"
import io.thp.pyotherside 1.4
import "../js/utils.js" as Utils

AbstractPage {
    id: postsPage
    objectName: "postsPage"
    property string mode: "post";
    property string singlePost;
    property var postsToShow;
    property var modelToStrip;
    property bool pinned;

    function getBackToPost(){
        pageStack.pop(pageStack.find( function(page){ return(page._depth === 1)} ), PageStackAction.Immediate)
    }

    function returnModel(){
        return postsModel
    }

    title: "<b>/" + boardId + "/</b>"+postNo

    SilicaListView {
        id: listView
        model: postsModel
        anchors.fill: parent
        focus: true
        VerticalScrollDecorator {}

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
                text: "Add pin"
                visible: !pinned && pageStack.depth === 2
                onClicked: {
                    //console.log("Add pin for post "+postNo +" on board "+boardId)
                    pyp.pin(postNo,boardId)
                }
            }
            MenuItem {
                text: "Remove pin"
                visible: pinned && pageStack.depth === 2
                onClicked: {
                    //console.log("REMOVE pin for post "+postNo +" on board "+boardId)
                    pyp.unpin(postNo,boardId)
                }
            }
            MenuItem {
                id: backToPost
                text: qsTr("Back to "+postNo )
                visible: false
                onClicked: {
                    getBackToPost()
                }
            }
            MenuItem {
                text: qsTr("Reload")
                onClicked: {
                    //postsModel.clear()
                    //postWorker.getData()
                    pyp.getPosts(boardId,postNo)
                    infoBanner.alert("Refreshing...")
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
            id: postViewPlaceholder
            text: "Something crashed..."
            enabled: false
        }

        header: PageHeader {
            title: {
                if(postsToShow){
                    qsTr("<b>/" + boardId + "/</b>"+postNo+"/replies")
                }
                else{
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
                //property var postReplies : []
                property string com
                property var quote
                property var thisPostNo
                property var modelToStrip
                visible: mode === "thread" ? false : true

                MenuItem {
                    visible: postReplies ? true : false
                    text: qsTr("View replies")
                    onClicked:{
                        postsToShow = postReplies
                        if(modelToStrip){
                            //console.log("WE HAVE TO HO DEEPPER")
                            pageStack.push(Qt.resolvedUrl("../pages/PostsPage.qml"), {
                                               postNo: thisPostNo,
                                               boardId: boardId,
                                               modelToStrip : modelToStrip,
                                               postsToShow : postsToShow
                                           } )
                        }
                        else{
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
                /*
                MenuItem {
                    text: qsTr("Reply")
                    onClicked: {
                        var replyform = pageStack.nextPage()
                        //pageStack.previousPage()
                        replyform.comment = comment + comm
                        navigateForward()
                    }
                }*/
                MenuItem {
                    text: "Show text"

                    visible: com !== "" ? true : false

                    onClicked: {
                        com = com.replace(/<(?:.|\n)*?>/gm, '\n');
                        pageStack.push(Qt.resolvedUrl("TextPage.qml"),
                                       {
                                           "title" : postNo,
                                           "content": com
                                       });
                    }
                }
                MenuItem {
                    text: qsTr("Open post in browser")
                    onClicked: {

                        var url = "https://boards.4chan.org/"+boardId+"/thread/"+postNo+"#p"+thisPostNo
                        infoBanner.alert("Opening post in web browser");
                        Qt.openUrlExternally(url)
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
            function work(){

                sendMessage({
                                'postNo': postNo,
                                'model': postsModel,
                                'postsToShow': postsToShow,
                                'modelToStrip': modelToStrip
                            });
            }
        }

        delegate: PostItem{
            id: delegate
        }

        add: Transition {
            NumberAnimation { property: "opacity"; easing.type: Easing.InQuad; from: 0; to: 1.0; duration: 300 }
        }

        populate: Transition {
            NumberAnimation { property: "opacity"; easing.type: Easing.OutBounce; from: 0; to: 1.0; duration: 500 }
        }

        footer:PostsPageFooter{
        }

    }

    Component.onCompleted: {

        pyp.getPosts(boardId,postNo)
        //console.log("MODEL TO STRIP : " + postsPage.modelToStrip.count)

        //postWorker.getData()
        if(1 < pageStack.depth){
            backToPost.visible = true
        }
        //        else if(0 < pageStack.depth) {
        //            backToBoard.visible = true
        //        }

    }
    /*
    onStatusChanged: {
        if (status === PageStatus.Active && pageStack.depth > 2) {
            backMenuItem.visible = true
        }
        else if(status === PageStatus.Active && pageStack.depth !== 0) {
            backMenuItem.visible = true
        }
    }*/

    Python {
        id: pyp

        Component.onCompleted: {
            // Add the Python library directory to the import path
            var pythonpath = Qt.resolvedUrl('../py/').substr('file://'.length);
            //var pythonpath = Qt.resolvedUrl('.').substr('file://'.length);
            addImportPath(pythonpath);
            //console.log("Threads: "+pythonpath);

            setHandler('pinned_postno', function(result) {
                if(result.length){
                    //console.log("THIS BOARD IS PINNED")
                    pinned = true
                    updateItem(pinned)
                }
                else{
                    //console.log("THIS BOARD IS NOT PINNED")
                    pinned = false
                    updateItem(pinned)
                }
            });

            setHandler('posts', function(result) {
//                console.log("POSTS HANDLER")
                for (var i=0; i<result.length; i++) {
                    postsModel.append(result[i]);
                }

                busy = false
                updateItem(pinned)

                //If needed, we can get post pin status here and pinned_postno handler will update status
                // But for now, previous model handles status
                //call('pinned.data.thread_this', ['get_by_postno',{'postno':postNo}],function() {});
            });

            setHandler('posts_status', function(result) {
                busy = false
                postViewPlaceholder.text= "404: Page not found"
                postViewPlaceholder.enabled = true
            });

            setHandler('pinned_all_update', function(result){});

            importModule('posts', function() {});
            importModule('pinned', function() {});

        }

        function getPosts(boardId,postNo){

            busy = true

            if(postsModel.count !== 0){
                postsModel.clear()
            }

            postsPage.boardId = boardId
            postsPage.postNo = postNo

            if(!postsToShow){
                call('posts.data.thread_this', ['get',{'board':boardId,'postno':postNo}],function() {});
            }
//            else if(postsToShow && pageStack.depth > 2 ){
//                console.log("GET AND STRIP")
//                stripper.work()
//                //console.log(postsPage.postNo)
//                //call('posts.data.thread_this', ['get',{'board':postsPage.boardId,'postno':postsPage.postNo}],function() {});
//            }
            else{
                //Create page from previous model by stripping it
                stripper.work()
            }
        }

        function pin(postNo,boardId){

            var com = postsModel.get(0)['com']
            var thumbUrl = postsModel.get(0)['thumbUrl']
            var time = postsModel.get(0)['time']
            var replies = postsModel.get(0)['replies_count']

            call('pinned.add_pin', [postNo,boardId,com,thumbUrl,time,replies],function() {
                pinned = true
                updateItem(pinned)
            });

        }

        function unpin(postNo,boardId){
            //console.log("UNPIN: "+postNo+" board:"+boardId)
            call('pinned.delete_pins', [postNo,boardId],function() {
                pinned = false
                updateItem(pinned)
            });

        }

        function updateItem(pinned){

            //console.log(postsModel.get(0)['no'])

            if (pageStack.depth === 2 && postsModel.count !== 0){
                var pin
                if(pinned){
                    pin = 1
                }
                else{
                    pin = 0
                }



                var updateItem
                updateItem = postsModel.get(0)
                updateItem.pin = pin
            }


        }

        onError: {
            // when an exception is raised, this error handler will be called
            //console.log('posts python error: ' + traceback);
            postsModel.clear()
            busy = false


            Utils.tracebackCatcher(traceback,postViewPlaceholder)
        }

        onReceived: {
            // asychronous messages from Python arrive here
            // in Python, this can be accomplished via pyotherside.send()
            console.log('posts got message from python: ' + data);
        }
    }

}
