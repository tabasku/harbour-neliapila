import QtQuick 2.2
import Sailfish.Silica 1.0
import Sailfish.Pickers 1.0
import io.thp.pyotherside 1.4


AbstractPage {
    id: captchaPage

    property string title
    property string captchaId
    property string captchaText
    property string captchaImageData
    property variant captchaInput : []
    allowedOrientations : Orientation.All

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height

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

            Column{

                height: Theme.paddingLarge * 2
                width: parent.width

                Label {
                    id: captchaTextObject
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeMedium
                    horizontalAlignment: Text.AlignHCenter
                    color: Theme.primaryColor
                    text: captchaText
                    //anchors.horizontalCenter: captchaImageColumn.horizontalCenter
                }
            }
            Column{
                id: captchaImageColumn
                Image {
                    id: captchaImage
                    opacity: 1
                    //anchors{
                        //right: parent.right
                        //bottom: parent.bottom
                    //    horizontalCenter:  parent.horizontalCenter
                    //}
                    height:column.width
                    width: column.width

                    fillMode: Image.PreserveAspectFit
                    visible: true
                    source: captchaImageData
                    //source:"feels.jpg";
                    //source: "https://www.google.com/recaptcha/api2/payload?c=03AMGVjXgI8qfCH54yx73T6cm4OiABf7vLFvO0rWQFFS_hTJF3hI-kjQMn2wdg6k_-fMNcrh3_-lvN5L1MBlCT0ObaQSfDJdN8E6Acx8nuYbgXP-H_XPHBgl8HlVZZF0hVY-bdtjsRNUO4O5PxupbcevC1Ybh9p6HF-iL73ZJTQESfZA4CoD173OHyyYwkvBgDsap9hiNkx9pYwGBLYbKQV6pYXeHuoQ7rJuNRAwtShXn448bBC7MWGjH6Mad55IQsFb0ESojIW6xqPUWH_txSw8i6e3smABijJXd1lUh73byWEYGyc0IBgfekBQ-yet5wLL57CtdnC9HnGzq3Z5q_fKc-TIq4L9K7wT2wTX1aYjaIBPcICLlEa9A&k=6Ldp2bsSAAAAAAJ5uyx_lx34lJeEpTLVkP5k04qc";

                    //asynchronous : true
                    Grid {
                      id: grid
                      anchors.fill: parent
                      width: parent.width
                      height: parent.height


                      columns: 3
                      rows: 3

                      Repeater {
                         // 5 * 5 elements here
                         model: grid.columns * grid.rows;
                         // Component to use to represent each image you want
                         Rectangle {

                             color: Theme.highlightColor
                             opacity: selected ? 0.5 : 0
                             //anchors.fill: parent
                             width: parent.width/3
                             height: parent.height/3

                             property bool selected: false

                             Label {
                                 text: index

                                 font.family: Theme.fontFamily
                                 font.pixelSize: Theme.fontSizeLarge
                                 anchors {
                                             centerIn: parent
                                         }
                             }


                             MouseArea
                             {
                                 anchors.fill: parent
                                 width: parent.width
                                 height: parent.height
                                 onClicked: {
                                    console.log('u toched: ' + index);
                                     if(!parent.selected){
                                         parent.selected = true
                                         captchaInput.push(index);
                                         //captchaInput[index] = 1

                                     }
                                     else{
                                         parent.selected = false
                                         captchaInput.pop(index);
                                         //captchaInput[index] = 0
                                     }
                                    console.log(captchaInput);

                                 }
                             }

                             //Component.onCompleted: {
                              //  captchaInput[index] = 0
                             //}
                           }


                       }

                    }
                }


            }

            Column{
                Button{

                    id: captchaSubmit
                    //anchors.horizontalCenter: captchaImageColumn.horizontalCenter
                    text: "Submit"
                    onClicked: {
                        console.log("Submit");
                        py.submitCaptcha(captchaInput)
                    }
                }

            }

        }
    }

    /*
    SilicaGridView {
        id:list
        width: parent.width;
        height: parent.height

        cellWidth: width / 3
        cellHeight: width / 2

        model: ListModel {
           id: myJSModel

        }
        header: PageHeader {
            id: header
            title: "Verify"
        }
        delegate: Item {
            width: list.cellWidth
            height: list.cellHeight



            Label {
                text: value
                font.pixelSize: Theme.fontSizeMedium
                anchors {
                            left: parent.left
                            right: parent.right
                            margins: Theme.paddingLarge

                        }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    var value = list.model.get(index).value
                    console.log(value);
                }
            }
        }

        Component.onCompleted: {
            for(var i=0;i<=100;i++) {
                var element = { "value" : i }
                myJSModel.append(element)
            }
        }
    }*/
    /*
    SilicaWebView {
        id: webView
        anchors.fill: parent
        opacity: loading ? 0.5 : 1

        header: PageHeader {
             title: "Verification"
        }

        url: "http://sailfishos.org"

        Component.onCompleted: {

            var resource = 'https://www.google.com/recaptcha/api/fallback?k=6Ldp2bsSAAAAAAJ5uyx_lx34lJeEpTLVkP5k04qc';
            var xhr = new XMLHttpRequest;

            xhr.open('GET', resource);
            xhr.onreadystatechange = function() {
                if (xhr.readyState === XMLHttpRequest.DONE) {
                    console.log("GOT RESPONSE");

                    var response = xhr.responseText;

                    console.log(
                                console.response
                                );
                    webView.loadHtml(response);
                }
            };
            console.log("SENDING");
            xhr.send();
        }
    }*/

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
                console.log("Handler set_challenge : "+result);
                captchaId = result[0];
                captchaText = result[1];
                captchaImageData = result[2];
            });


            setHandler('set_response', function(result) {

                console.log("Handler fired"+result);
                //captchaText = result[1];
                //captchaImageData = result[2];
            });

        }


        function submitCaptcha(value){


            var string = value.toString().replace(/\,/g, "");

            console.log("captchaId "+captchaId);
            console.log(string);
            call('captcha.get_response', [captchaId,string], function() {});

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

