import QtQuick 2.2
import Sailfish.Silica 1.0
//import Sailfish.Pickers 1.0
import io.thp.pyotherside 1.4
import "../items/"


AbstractPage {
    id: captchaPage

    property string title
    property string captchaId
    property string captchaText: "Fetching verification challenge..."
    property string captchaImageData
    property variant captchaInput : []
    busy : true
    allowedOrientations : Orientation.All

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height + Theme.paddingLarge

        // Why is this necessary?
        contentWidth: parent.width


        // Tell SilicaFlickable the height of its content.
        //contentHeight: column.height

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.


        Column {
            id: column

            width: parent.width
            height: parent.height
            spacing: Theme.paddingLarge
            PageHeader {
                title: "Verification"
            }

            Row {
                id: captchaTextRow
                spacing: Theme.paddingLarge
                anchors.horizontalCenter: parent.horizontalCenter

                Label {
                    id: captchaTextObject
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeMedium
                    color: Theme.primaryColor
                    text: captchaText
                }
            }

            Row {
                id: captchaImageRow
                spacing: Theme.paddingLarge
                anchors.horizontalCenter: parent.horizontalCenter

                Image {
                    id: captchaImage
                    opacity: captchaPage.busy ? 0 : 1
                    height:column.width
                    width: column.width

                    fillMode: Image.PreserveAspectFit
                    visible: true
                    source: captchaImageData

                    // Draw grid over captcha challenge
                    Grid {
                      id: grid
                      anchors.fill: parent
                      width: parent.width
                      height: parent.height


                      columns: 3
                      rows: 3

                      Repeater {
                         id: repeater
                         // 5 * 5 elements here
                         model: grid.columns * grid.rows;
                         // Component to use to represent each image you want
                         Rectangle {

                             color: Theme.highlightColor
                             opacity: selected ? 0.5 : 0
                             FadeAnimation on opacity {}
                             width: parent.width/3
                             height: parent.height/3

                             property bool selected: false

                             MouseArea
                             {
                                 anchors.fill: parent
                                 width: parent.width
                                 height: parent.height
                                 onClicked: {

                                     if(!parent.selected){
                                         parent.selected = true
                                         captchaInput.push(index);
                                     }
                                     else{
                                         parent.selected = false
                                         captchaInput.pop(index);
                                     }

                                     if(captchaInput.length){
                                         captchaSubmit.enabled = true
                                     }
                                     else{
                                        captchaSubmit.enabled = false
                                     }

                                 }
                             }
                           }


                       }

                    }
                }


            }

            Row {
                id: submitRow
                spacing: Theme.paddingLarge*2
                anchors.horizontalCenter: parent.horizontalCenter

                Button{

                    id: captchaSubmit
                    text: "Submit"
                    enabled: captchaInput.length
                    onClicked: {
                        console.log("Submit");
                        py.submitCaptcha(captchaInput)
                    }
                }

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
            //console.log(pythonpath);
            importModule('captcha', function() {
                call('captcha.get_challenge', [], function () {});
             });

            setHandler('set_challenge', function(result) {
                //console.log("Handler set_challenge : "+result);
//                infoBanner.alert("Verification done");

                captchaId = result[0];
                captchaText = result[1];
                captchaImageData = result[2];
                captchaPage.busy = false
                //captchaSubmit.enabled = true

            });

            setHandler('failed_challenge', function(result) {

                //console.log("set_response fired"+result);
                infoBanner.alert("Verification failed, try again");
                captchaInput.forEach(function(element) {
                  //console.log(element);
                  repeater.itemAt(element).selected = false
                });
                captchaSubmit.enabled = false
                captchaInput = []
                captchaPage.busy = false
                //captchaText = result[1];
                //captchaImageData = result[2];
            });

            setHandler('set_response', function(result) {

                //console.log("set_response fired"+result);
                //infoBanner.alert("Verification done");

                //newPostPage.captcha_token = result
                pageStack.navigateBack();

                //captchaText = result[1];
                //captchaImageData = result[2];
            });

        }


        function submitCaptcha(value){
            captchaSubmit.enabled = false
            var string = value.toString().replace(/\,/g, "");
            call('captcha.get_response', [captchaId,string], function() {});

        }

/*
        onError: {
            // when an exception is raised, this error handler will be called
            console.log('python error: ' + traceback);
        }
        onReceived: {
            // asychronous messages from Python arrive here
            // in Python, this can be accomplished via pyotherside.send()
            console.log('got message from python: ' + data);
        }*/
    }
}

