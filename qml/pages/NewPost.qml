import QtQuick 2.2
import Sailfish.Silica 1.0
import Sailfish.Pickers 1.0
import io.thp.pyotherside 1.4
import Nemo.Thumbnailer 1.0
import "../items/"

Page {
    id: newPostPage

    property string boardId: boardId
    property int replyTo: 0
    property string selectedFile

    property string nickname: nameText.text
    property string options: ""
    property string subject: subjectText.text
    property string comment: commentText.text
    //property string file_path: selectedFile ? selectedFile : ""
    property variant captcha_token


    //(nickname="", comment="", subject="", file_attach="", captcha_response="")





    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height

        PullDownMenu {
            id: newPostPullDownMenu

            busy : busy

            MenuItem {
                id:newThread
                text: qsTr("Post")
                //enabled: boardId ? true: false
                enabled: true// comment.length ? true : false



                onClicked: {
                    //pageStack.push("Captcha2Page.qml");
                    py.post()
                }
            }
/*
            MenuItem {
                id:menuRefresh
                text: qsTr("Save draft")
                enabled: false

                onClicked: {
                    pyt.getThreads(boardId,pageNo)
                    infoBanner.alert("Refreshing...")
                }
            }
*/
            Label{
                text: typeof boardId === 'undefined' ?  " PERKEL" : "New post to /"+boardId+"/"
                //wrapMode: Text.WordWrap
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeExtraSmall
                color: Theme.secondaryHighlightColor
                clip: true
                smooth: true
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column

            width: parent.width
            height: parent.contentHeight
            spacing: Theme.paddingLarge
            PageHeader {
                title: "New Post"
            }

            TextArea{
                id: nameText
                width: parent.width
                //wrapMode: Text.WordWrap
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.primaryColor
                //text: content
                x: Theme.paddingSmall
                clip: true
                focus: false
                placeholderText: "Anonymous"
                wrapMode: TextEdit.Wrap
                label: 'Name'
                text: nickname
            }

            /*
            TextArea{
                id: optionsText
                width: parent.width
                //wrapMode: Text.WordWrap
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.primaryColor
                //text: content
                x: Theme.paddingSmall
                clip: true
                focus: false

                wrapMode: TextEdit.Wrap
                label: 'Options'
                placeholderText: 'Options'
                text: options
            }
            */

            TextArea{
                id: subjectText
                width: parent.width
                //wrapMode: Text.WordWrap
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.primaryColor
                //text: content
                x: Theme.paddingSmall
                clip: true
                focus: false

                wrapMode: TextEdit.Wrap
                label: 'Subject'
                placeholderText: 'Subject'
                text: subject
            }

            TextArea{
                id: commentText
                width: parent.width
                //wrapMode: Text.WordWrap
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeSmall
                //color: Theme.primaryColor
                //text: content
                x: Theme.paddingSmall
                clip: true
                focus: false

                wrapMode: TextEdit.Wrap
                color: text ? Theme.primaryColor : 'red'
                label: 'Comment'
                placeholderText: 'Comment'
                text: comment
            }


            Button {
               id: verificationButton
               text: "Verification"
               color: captcha_token ? Theme.primaryColor : 'red'
               //onClicked: pageStack.push("Captcha2Page.qml")
               onClicked:  pageStack.push("Captcha2Page.qml")
               anchors.horizontalCenter: parent.horizontalCenter
            }



            ValueButton {
                label: "File"
                value: selectedFile ? selectedFile : "None"
                onClicked: pageStack.push(filePickerPage)
                anchors.horizontalCenter: parent.horizontalCenter
            }

            /*
            Image {
                id: selectedImage
                height: 200
                width: 300
                sourceSize.height: Theme.itemSizeHuge
                asynchronous: true
            }
            */

            Image {
                id: selectedImageThumb
                source: "image://nemoThumbnail/" + selectedFile
                width: 100
                height: 100
                sourceSize.width: width
                sourceSize.height: height
                asynchronous: true
            }

        }
    }

    Component {
        id: filePickerPage
        FilePickerPage {
            nameFilters: [ '*.jpg', '*.png', '*.webm','*.gif' ]
            onSelectedContentPropertiesChanged: {
                newPostPage.selectedFile = selectedContentProperties.filePath
                newPostPage.selectedImageThumb.source = selectedContentProperties.filePath
                selectedImageThumb.source = selectedContentProperties.filePath
            }
        }
    }

    Python {
        id: py

        Component.onCompleted: {
            // Add the Python library directory to the import path
            var pythonpath = Qt.resolvedUrl('../../py/').substr('file://'.length);
            //var pythonpath = Qt.resolvedUrl('.').substr('file://'.length);
            addImportPath(pythonpath);
            console.log(pythonpath);
            importModule('posting', function() {});

             setHandler('post_successfull', function(result) {
                 console.log("SUCCESS : "+result);
                 infoBanner.alert("SUCCESS")

             });

            setHandler('post_failed', function(result) {
                console.log("FAILED : "+result);
                infoBanner.alert("Failed to send")

            });

            setHandler('set_response', function(result) {
                if(result.length === 1){
                    console.log("set_response fired"+result);
                    newPostPage.captcha_token = result[0]
                    verificationButton.enabled = false
                    verificationButton.color = "green"
                    infoBanner.alert("Verified")


                }
                else {
                    infoBanner.alert("Something went wrong, try reverify")
                }

            });

        }



        function post(){
            if(!comment.length){infoBanner.alert("Cannot post without comment");return}
            console.log("posting with captchatoken "+captcha_token)
            console.log("posting with filepath "+selectedFile)
            console.log("posting with subject "+subject)

            call('posting.post', [
                     nickname,
                     comment,
                     subject,
                     selectedFile,
                     captcha_token
                 ], function() {});
            //(nickname="", comment="", subject="", file_attach="", captcha_response="")

        }

        onError: {
            // when an exception is raised, this error handler will be called
            console.log('python error: ' + traceback);
        }
        onReceived: {
            // asychronous messages from Python arrive here
            // in Python, this can be accomplished via pyotherside.send()
            console.log('got message from python: ' + data);
        }
    }
}

