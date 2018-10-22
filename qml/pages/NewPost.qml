import QtQuick 2.2
import Sailfish.Silica 1.0
import Sailfish.Pickers 1.0
import io.thp.pyotherside 1.4





Page {
    id: page

    property string selectedFile




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
                enabled: true


                onClicked: {
                    pageStack.push("CaptchaVerify.qml");
                }
            }

            MenuItem {
                id:menuRefresh
                text: qsTr("Save draft")
                enabled: false

                onClicked: {
                    pyt.getThreads(boardId,pageNo)
                    infoBanner.alert("Refreshing...")
                }
            }
            Label{
                text: typeof boardTitle === 'undefined' ?  " PERKEL" : boardTitle
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
            height: contentText.contentHeight
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
            }

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
            }

            TextArea{
                id: subjectTest
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
            }
            TextArea{
                id: contentText
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

            }

            Button {
               text: "Verification"
               color: 'red'
               onClicked: pageStack.push(captcha2Page)
               anchors.horizontalCenter: parent.horizontalCenter
            }

            ValueButton {
                label: "File"
                value: selectedFile ? selectedFile : "None"
                onClicked: pageStack.push(filePickerPage)
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Image {
                id: selectedImage
                sourceSize.height: Theme.itemSizeHuge
                asynchronous: true
            }

        }
    }

    Component {
        id: filePickerPage
        FilePickerPage {
            nameFilters: [ '*.jpg', '*.png', '*.webm','*.gif' ]
            onSelectedContentPropertiesChanged: {
                page.selectedFile = selectedContentProperties.filePath
                page.selectedImage.source = selectedContentProperties.filePath
            }
        }
    }

    Component {
        id: captcha2Page
        Page {
            id: page

            function parsing() {
                var http = new XMLHttpRequest();
                var json , parse , text ;

                http.onreadystatechange = function(){
                    if(http.readyState == 4 && http.status == 200)
                    {
                        //json = http.responseText;

                        //parse = JSON.parse(json);

                        //text = parse.parse.text["*"];
                        text = http.responseText;
                        console.log(text);
                        webView.loadHtml(text);  // <-- LOOK HERE
                        return (text);
                    }
                };
                //http.open('GET','https://www.google.com/recaptcha/api/fallback?k=6Ldp2bsSAAAAAAJ5uyx_lx34lJeEpTLVkP5k04qc');
                http.open('GET','captcha2.html');
                http.send();
            }

            SilicaWebView {
                id: webView
                //opacity: 1
                anchors.fill: parent
                opacity: loading ? 0.5 : 1

                experimental.userAgent: "Mozilla/5.0 (Maemo; Linux; Jolla; Sailfish; Mobile) AppleWebKit/534.13 (KHTML, like Gecko) NokiaBrowser/8.5.0 Mobile Safari/534.13"


                header: PageHeader {
                     title: "Verification"
                }

                //url: "captcha2.html"
                //url: "https://httpbin.org/headers"
                //url: "https://www.google.com/recaptcha/api/fallback?k=6Ldp2bsSAAAAAAJ5uyx_lx34lJeEpTLVkP5k04qc"
                Component.onCompleted: parsing()


            }
/*
            Component.onCompleted: {

                var resource = 'qrc:/captcha2.html';
                console.log("STARTING");
                var xhr = new XMLHttpRequest;
                xhr.open('GET', resource);
                xhr.onreadystatechange = function() {
                    if (xhr.readyState === XMLHttpRequest.DONE) {
                        console.log("THIS IS NEVER HAPPENING?")
                        var response = xhr.responseText;
                        webView.loadHtml(response);
                    }
                };
                console.log("SENDING");
                xhr.send();
            }*/

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
            importModule('savefile', function() {});
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

