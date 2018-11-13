import QtQuick 2.0
import Sailfish.Silica 1.0
import "../js/utils.js" as Utils

BackgroundItem {
    id: delegate
    width: parent.width
    height: menuOpen ? contextMenu.height + post.height : post.height

    property Item contextMenu
    property bool menuOpen: contextMenu != null && contextMenu.parent === delegate

    property int ratio: mode === "pinned" ? Math.round(parent.width/5):Math.round(parent.width/3)
    //property int commentAreaWidth: Math.round(2*ratio-2*pageMargin)
    property int infoAreaHeight: Math.round(Theme.paddingLarge*2)
    property int contentAreaHeight: ratio

    Item {
        anchors.fill: parent

        Rectangle {
            anchors.bottom: parent.bottom
            width: parent.width
            height: parent.height

            gradient: Gradient {
                GradientStop { position: 0.0; color: Theme.rgba(Theme.primaryColor, 0) }
                GradientStop { position: 1.0; color: Theme.rgba(Theme.primaryColor, 0.1) }
            }
        }
    }

    Column {
        id: post
        anchors{
            left:parent.left
            right:parent.right
            leftMargin: pageMargin
            rightMargin: pageMargin
        }

        spacing: padding

        Item {
            width: parent.width;
            height: infoAreaHeight;

            Row {
                id: headerContentRow
                anchors.fill: parent
                spacing: padding

                Item {
                    id: timeArea
                    width: timeText.contentWidth
                    height: timeText.contentHeight
                    anchors{
                        verticalCenter: parent.verticalCenter
                    }
                    Label{
                        id: timeText
                        text: now
                        font.pixelSize: infoFontSize
                        color: infoFontColor
                    }

                }

                Item {
                    id: postNoArea
                    width: parent.width-timeArea.width-padding
                    height: postNoText.contentHeight
                    anchors{
                        verticalCenter: parent.verticalCenter
                    }

                    Image{
                        id:stickyImg
                        source: "image://theme/icon-s-high-importance"
                        height:postNoText.contentHeight
                        width: height
                        fillMode: Image.PreserveAspectFit
                        visible: sticky ? true : false
                        cache: true
                        anchors{
                            right: closedImg.left
                            rightMargin: padding
                            verticalCenter: parent.verticalCenter
                        }
                    }

                    Image{
                        id:closedImg
                        source: "image://theme/icon-s-secure"
                        height:postNoText.contentHeight*0.9
                        width: height
                        fillMode: Image.PreserveAspectFit
                        visible: closed ? true : false
                        anchors{
                            right: postNoText.left
                            rightMargin: padding
                            verticalCenter: parent.verticalCenter
                        }
                    }

                    Label{
                        id: postNoText
                        text: mode === "pinned" ? "<b>/"+post_board+"/</b>"+no : no
                        font.pixelSize: infoFontSize
                        color: infoFontColor
                        anchors{
                            right: parent.right
                        }
                    }
                }
            }
        }
        Item {
            width: parent.width;
            //                    height: mode === "post" && !has_file ? postText.contentHeight :  contentAreaHeight;
            height: {
                switch(mode){
                case "post":
                    if(has_file){
                        if(contentAreaHeight < postText.contentHeight)
                            postText.contentHeight
                        else
                            contentAreaHeight
                    }
                    else{
                        postText.contentHeight
                    }

                    break;
                default:
                    contentAreaHeight
                }
            }

            Row {
                id: contentRow
                anchors.fill: parent
                spacing: padding

                Item {
                    id: thumbNailArea
                    width: has_file ? ratio : 0;
                    height: ratio

                    Image {
                        id: thumbImg
                        fillMode: Image.PreserveAspectCrop
//                        smooth: true
                        asynchronous : true
                        source: !has_file ? "" : thumbUrl
//                        clip: true

                        anchors{
                            fill: parent
                        }
                    }

                    Loader {
                        id: busyIndicatorLoader
                        anchors.centerIn: thumbImg
                        sourceComponent: {
                            switch (thumbImg.status) {
                            case Image.Loading: return thumbLoaderComponent
                            case Image.Error: {
                                thumbNailTouchArea.enabled = false
                                return failedLoading
                            }
                            default: return undefined
                            }
                        }

                        Component {
                            id: thumbLoaderComponent

                            Item {
                                width: thumbImg.width
                                height: thumbImg.height

                                Label {
                                    anchors.centerIn: parent
                                    font.pixelSize: Theme.fontSizeSmall
                                    text: ""//Math.round(thumbImg.progress * 100) + "%"
                                }

                                Rectangle{
                                    anchors.fill:parent
                                    color: infoFontColor
                                    opacity: 0.3
                                }

                                Image {
                                    fillMode: Image.PreserveAspectFit
                                    anchors.centerIn: parent
                                    source: "image://theme/icon-m-image"
                                    NumberAnimation {
                                        id: animateOpacity
                                        //target: flashingblob
                                        properties: "opacity"
                                        from: 0.2
                                        to: 1.0
                                        loops: Animation.Infinite
                                        easing {type: Easing.OutBack; overshoot: 500}
                                        running: true
                                    }
                                }
                            }
                        }
                        Component {
                            id: failedLoading;
                            Item {
                                width: thumbImg.width
                                height: thumbImg.height

                                Rectangle{
                                    anchors.fill:parent
                                    color: infoFontColor
                                    opacity: 0.3
                                }

                                Image {
                                    id: failedImage
                                    width: thumbImg.width*0.5
                                    height: thumbImg.height*0.5
                                    fillMode: Image.PreserveAspectFit
                                    anchors.centerIn: parent
                                    //source: "image://theme/icon-m-image"
                                    source: "../img/image_not_found.png"
                                    opacity: 0.5
                                }
                            }
                        }
                    }

                    MouseArea {
                        id: thumbNailTouchArea
                        enabled: mode !== "pinned" ? true : false
                        anchors.fill: thumbImg
                        onClicked: {

                            switch(ext){
                            case ".webm":
                                pageStack.push(Qt.resolvedUrl("../pages/VideoViewPage.qml"),
                                               {
                                                   "imgUrl": imgUrl,
                                                   "filename": filename
                                               });
                                break;

                            default:
                                pageStack.push(Qt.resolvedUrl("../pages/ImageViewPage.qml"),
                                               {
                                                   "imgUrl": imgUrl,
                                                   "thumbUrl": thumbUrl,
                                                   "filename": filename
                                               });
                            }
                        }
                    }
                }
                Item {
                    id: commentArea

                    width: has_file ? parent.width-thumbNailArea.width : parent.width;
                    height: mode === "post" ? postText.contentHeight :  contentAreaHeight;

                    Text {
                        id: postText
                        anchors{
                            fill: parent
                        }

                        text: com
                        wrapMode: Text.Wrap
                        font.pixelSize: postFontSize
                        color: Theme.primaryColor
                        //                        color: listView.isCurrentItem ? Theme.highlightColor : Theme.primaryColor
                        clip: mode === "post" ? false : true
                        linkColor : Theme.highlightColor
                        verticalAlignment: Text.AlignTop

                        onLinkActivated: {
                            Utils.openLink(link)
                        }
                        Image {
                            id: dots
                            height: 32
                            width: 32
                            anchors{
                                //left :parent.left
                                bottom: parent.bottom
                                right: parent.right
                            }
                            source: "image://theme/icon-lock-more"
                            visible: false
                        }
                        Component.onCompleted: {
                            if(mode === "thread" && contentAreaHeight < postText.contentHeight){
                                postText.maximumLineCount = Math.floor(contentAreaHeight/postFontSize-1)
                                dots.visible = true
                            }
                        }
                    }


                }
            }
        }
        Item {
            width: parent.width; height: infoAreaHeight
            Row {
                id: footerContentRow
                anchors.fill: parent
                spacing: padding

                Item {
                    id: nameArea
                    width: parent.width - infoArea.width
                    height: nameText.contentHeight
                    //                    radius: 20.0
                    //                    color: "#024c1c"
                    anchors{
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                    }
                    Label{
                        id: nameText
                        //text: mode === "pinned" ? "READ: "+last_read : name
                        text : name
                        font.pixelSize: infoFontSize
                        color: infoFontColor
                    }
                }
                Item {
                    id: infoArea
                    width: parent.width-nameArea.width;
                    height: parent.height;
                    anchors{
                        verticalCenter: parent.verticalCenter
                    }

                    Image {
                        id: pinIndicator
                        anchors{
                            right: imgchecker.left
                            rightMargin: imgcount.contentWidth
                            bottom: parent.bottom
                        }
                        visible: pin || mode === 'pinned'  ? true : false
                        height:parent.height
                        width:pin || mode === 'pinned' ? parent.height : false
                        fillMode: Image.PreserveAspectFit
                        source: "image://theme/icon-s-attach"
                    }

                    Image {
                        id: imgchecker
                        anchors{
                            right: replychecker.left
                            bottom: parent.bottom
                            rightMargin: repcount.contentWidth
                        }
                        height:parent.height
                        width: imgcount.text === "0" || mode === "post" ? 0 : parent.height
                        fillMode: Image.PreserveAspectFit
                        source: "image://theme/icon-m-image"
                        visible: mode === "post" || mode === "pinned" ? false : true
                        Label {
                            id: imgcount
                            anchors.right: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            text: images
                            font.pixelSize :Theme.fontSizeTiny
                            color: infoFontColor
                            visible: imgcount.text === "0" ? false : true
                        }
                    }

                    Image {
                        id: replychecker
                        anchors{
                            right: parent.right
                            bottom: parent.bottom
                        }
                        height:parent.height
                        width: repcount.text === "0" && mode === "post"  ? 0 : parent.height
                        fillMode: Image.PreserveAspectFit
                        visible: repcount.text === "0" && mode === "post" ? false : true
                        source: "image://theme/icon-m-chat"
                        Label {
                            id: repcount
                            anchors.right: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            text: mode === "pinned" ? "<b>New : " +postCount + "</b>" : replies
                            font.pixelSize :Theme.fontSizeTiny
                            color: infoFontColor
                        }
                    }
                }
            }
        }
    }

    onClicked: {


        switch(mode){
        case "pinned":
            pageStack.push(Qt.resolvedUrl("../pages/PostsPage.qml"), {postNo: no, boardId: post_board, pinned: true } )
            break;
        case "thread":
            if(pin){
                pageStack.push(Qt.resolvedUrl("../pages/PostsPage.qml"), {postNo: no, boardId: post_board, pinned: true } )
            }
            else{
                pageStack.push(Qt.resolvedUrl("../pages/PostsPage.qml"), {postNo: no, boardId: post_board, pinned: false} )
            }
            break;

        default:
            console.log("clicked "+ index)
        }
    }

    onPressAndHold: {

        switch(mode){
        case "post":
            var postReplies
            if(replies){
                postReplies = postsModel.get(index).repliesList
            }

            var pP = pageStack.find(function(page) { return page.objectName === "postsPage"; });
            if (pP)
                var modelToStrip = pP.returnModel()

            contextMenu = contextMenuComponent.createObject(listView, {postReplies: postReplies, thisPostNo: no, modelToStrip : modelToStrip,com: com})
            contextMenu.open(delegate)
            break;

            //        case "thread":
            //            contextMenu = contextMenuComponent.createObject(listView, {index:index,pin:pin})
            //            contextMenu.show(delegate)
            //            break;

            //        case "pinned":
            //            contextMenu = contextMenuComponent.createObject(listView, {index:index,pin:pin})
            //            contextMenu.show(delegate)
            //            break;

        default:
            contextMenu = contextMenuComponent.createObject(listView, {index:index,pin:pin})
            contextMenu.open(delegate)
        }
    }
}
