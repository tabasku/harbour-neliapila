import QtQuick 2.0
import Sailfish.Silica 1.0
import "../js/utils.js" as Utils
import "../js/settingsStorage.js" as SettingsStore

GridItem {
    id: delegate
    width: !isPortrait && mode !== 'post' ? parent.width /2 : parent.width;
    contentHeight: mode === 'post' && menuOpen  ? contextMenu.height + post.height : mode ==='post' ? post.height : isPortrait ? parent.width/2: parent.width/4;

    property Item contextMenu
    property bool menuOpen: contextMenu != null && contextMenu.parent === delegate;

    property int ratio: Math.round(parent.width/3);
    property int infoAreaHeight: Math.round(Theme.paddingLarge*2);
    property int contentAreaHeight: isPortrait ? ratio :Math.round(parent.width/5);

    Item {
        anchors.fill: parent;

        Rectangle {
            anchors.bottom: parent.bottom;
            width: parent.width;
            height: post.height + infoAreaHeight;

            gradient: Gradient {
                GradientStop { position: 0.0; color: Theme.rgba(Theme.primaryColor, 0) }
                GradientStop { position: 1.0; color: Theme.rgba(Theme.primaryColor, 0.1) }
            }
        }
    }
    Item {
        anchors.fill: parent;

        Rectangle {
            visible: highlight_post
            width: parent.width
            height: post.height

            gradient: Gradient {
                GradientStop { position: 0.0; color: Theme.rgba(Theme.primaryColor, 0.2) }
                GradientStop { position: 1.0; color: Theme.rgba(Theme.primaryColor, 0.4) }
            }
        }
    }

    Column {
        id: post
        anchors {
            left:parent.left;
            right:parent.right;
            leftMargin: pageMargin;
            rightMargin: pageMargin;
        }

        Item {
            width: !isPortrait && mode !== 'post' ? parent.width / 2 : parent.width;
            height: !isPortrait && mode !== 'post' ? infoAreaHeight  : infoAreaHeight;

            Row {
                id: headerContentRow;
                anchors.fill: parent;

                Item {
                    id: timeArea
                    width: timeText.contentWidth
                    height: timeText.contentHeight
                    anchors{
                        verticalCenter: parent.verticalCenter
                    }

                    Label {
                        id: timeText
                        text: now
                        font.pixelSize: infoFontSize
                        color: infoFontColor
                    }
                }

                Item {
                    id: postNoArea
                    width: !isPortrait && mode !== 'post' ? parent.width*2-timeArea.width-padding : parent.width-timeArea.width-padding
                    height: postNoText.contentHeight
                    anchors {
                        verticalCenter: parent.verticalCenter
                    }

                    Image{
                        id:stickyImg
                        source: "image://theme/icon-s-high-importance"
                        height:postNoText.contentHeight
                        width: !isPortrait && mode !== 'post' ? height /2: height
                      fillMode: Image.PreserveAspectFit
                        visible: sticky ? true : false
                        cache: true
                        anchors {
                            right: closedImg.left
                            rightMargin: padding
                            verticalCenter: parent.verticalCenter
                        }
                    }

                    Image {
                        id:closedImg
                        source: "image://theme/icon-s-secure"
                        height:postNoText.contentHeight*0.9
                        width: height
                        fillMode: Image.PreserveAspectFit
                        visible: closed ? true : false
                        anchors {
                            right: postNoText.left
                            rightMargin: padding
                            verticalCenter: parent.verticalCenter
                        }
                    }

                    Label {
                        id: postNoText
                        text: mode === "pinned" ? "<b>/"+post_board+"/</b>"+no : no
                        font.pixelSize: infoFontSize
                        color: infoFontColor
                        anchors {
                            right: parent.right
                        }
                    }
                }
            }
        }

        Item {
            width: parent.width;
            height: {
                switch(mode) {
                case "post":
                    if (has_file) {
                        if (contentAreaHeight < postText.contentHeight)
                            postText.contentHeight
                        else
                            contentAreaHeight
                    }
                    else {
                        postText.contentHeight
                    }
                    break;
                default:
                    !isPortrait && mode !== 'post' ? postText.height - padding*1.5: contentAreaHeight
                                   }
            }

            Row {
                id: contentRow
                anchors.fill: parent
                spacing: padding

                Item {
                    id: thumbNailArea
                    width: has_file ? (!isPortrait && mode !== 'post' ? ratio /2 : contentAreaHeight) : 0;
                    height: !isPortrait && mode !=='post' ? parent.height: contentAreaHeight

                    Image {
                        id: thumbImg
                        fillMode: Image.PreserveAspectCrop
                        asynchronous : true
                        source: !has_file ? "" : SettingsStore.getSetting("SpoilerImages") == 1 && spoiler ? "https://s.4cdn.org/image/spoiler.png" : thumbUrl;

                        anchors.fill: parent;
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
                                    text: ""
                                }

                                Rectangle {
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

                                Rectangle {
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
                            switch(ext) {
                            case ".webm":
                                pageStack.push(Qt.resolvedUrl("../pages/VideoViewPage.qml"),
                                               {
                                                   "imgUrl": imgUrl,
                                                   "filename": filename,
                                                   "filename_original": filename_original
                                               });
                                break;
                            case ".gif":
                                pageStack.push(Qt.resolvedUrl("../pages/GifViewPage.qml"),
                                               {
                                                   "imgUrl": imgUrl,
                                                   "thumbUrl": thumbUrl,
                                                   "filename": filename,
                                                   "filename_original": filename_original
                                               });
                                break;

                            default:
                                pageStack.push(Qt.resolvedUrl("../pages/ImageViewPage.qml"),
                                               {
                                                   "imgUrl": imgUrl,
                                                   "thumbUrl": thumbUrl,
                                                   "filename": filename,
                                                   "filename_original": filename_original
                                               });
                            }
                        }
                    }
                }
                Item {
                    id: commentArea
                    width: has_file ? parent.width-thumbNailArea.width : parent.width;
                    height:isPortrait ? (mode === 'post' ? post.height + infoAreaHeight : contentAreaHeight) :ratio/2

                    Text {
                        id: postText
                        anchors {
                            fill: parent
                        }

                        text: com
                        textFormat: Text.StyledText
                        wrapMode: Text.Wrap
                        font.pixelSize: postFontSize
                        color: Theme.primaryColor
                        clip: mode === "post" ? false : true
                        linkColor : Theme.highlightColor
                        verticalAlignment: Text.AlignTop

                        onLinkActivated: {
                            Utils.openLink(link)
                        }
                        onLineLaidOut: {
                            if (line.y > thumbNailArea.height && has_file && mode === 'post') {
                                line.x = line.x - (thumbNailArea.width + 5)
                                line.width = line.width + (thumbNailArea.width + 5)
                            }
                        }
                        Image {
                            id: dots
                            height: 32
                            width: 32
                            anchors {
                                bottom: parent.bottom
                                right: parent.right
                            }
                            source: "image://theme/icon-lock-more"
                            visible: false
                        }
                        Component.onCompleted: {
                            if (mode !== "post" && contentAreaHeight < postText.contentHeight) {
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
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                    }

                    Label {
                        id: nameText
                        text : mode !== 'post' ? name : poster_id == "" ? name : name + " (" + poster_id + ")"
                        font.pixelSize: infoFontSize
                        color: infoFontColor
                    }
                }

                Item {
                    id: infoArea
                    width: parent.width-nameArea.width;
                    height: parent.height;
                    anchors {
                        verticalCenter: parent.verticalCenter
                    }
                    
                    Image {
                        id: flag
                        anchors {
                            right: pinIndicator.left
                            rightMargin: imgcount.contentWidth
                            bottom: parent.bottom
                        }
                        height:parent.height
                        width:parent.height/2
                        cache: true
                        fillMode: Image.PreserveAspectFit
                        visible: has_flag || has_memeflag
                        source: has_flag ? "https://s.4cdn.org/image/country/" + countrycode.toLowerCase() + ".gif" : has_memeflag ? "https://s.4cdn.org/image/flags/" +  boardId + "/" + board_flag.toLowerCase() + ".gif" : ""
                     }
                    
                    Image {
                        id: pinIndicator
                        anchors {
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
                            font.pixelSize: Theme.fontSizeTiny
                            color: infoFontColor
                            visible: imgcount.text === "0" ? false : true
                        }
                    }

                    Image {
                        id: replychecker
                        anchors {
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
                            text: mode === "pinned" ? "<b>New : " + postCount + "</b>" : replies
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
            pageStack.push(Qt.resolvedUrl("../pages/PostsPage.qml"), {postNo: no, boardId: post_board, pinned: true, repscount: postCount } )
            break;
        case "thread":
            if(pin) {
                pageStack.push(Qt.resolvedUrl("../pages/PostsPage.qml"), {postNo: no, boardId: post_board, pinned: true } )
            }
            else {
                pageStack.push(Qt.resolvedUrl("../pages/PostsPage.qml"), {postNo: no, threadId: threadId, boardId: post_board, pinned: false} )
            }
            break;

        default:
            var pP = pageStack.find(function(page) {
                // This should stop the bug relating to deeper reply levels
                return page.objectName === "postsPage" && page.pageCount !== 1;
            });

            if (pP)
                var modelToStrip = pP.returnModel()

            if (postsModel.get(index).repliesList) {

                var postsToShow = postsModel.get(index).repliesList
                var thisPostNo = postsModel.get(index).no

                if (modelToStrip) {
                    pageStack.push(Qt.resolvedUrl("../pages/PostsPage.qml"), {
                                       postNo: thisPostNo,
                                       boardId: boardId,
                                       modelToStrip : modelToStrip,
                                       postsToShow : postsToShow,
                                       threadId: threadId
                                   } )
                }
                else {
                    pageStack.push(Qt.resolvedUrl("../pages/PostsPage.qml"), {
                                       postNo: thisPostNo,
                                       boardId: boardId,
                                       modelToStrip : postsModel,
                                       postsToShow : postsToShow,
                                       threadId: threadId
                                   } )
                }
            }
        }
    }

    onPressAndHold: {
        switch(mode) {
        case "post":
            var postReplies
            if (replies) {
                postReplies = postsModel.get(index).repliesList
            }

            var pP = pageStack.find(function(page) {
                // Fixed deeper reply level filtering bug
                return page.objectName === "postsPage" && page.pageCount !== 1;
            });

            if (pP)
                var modelToStrip = pP.returnModel()

            contextMenu = contextMenuComponent.createObject(listView, {postReplies: postReplies, thisPostNo: no, modelToStrip : modelToStrip,com: com, poster_id: poster_id})
            contextMenu.open(delegate)
            break;

        default:
            contextMenu = contextMenuComponent.createObject(listView, {index:index,pin:pin})
        }
    }
}
