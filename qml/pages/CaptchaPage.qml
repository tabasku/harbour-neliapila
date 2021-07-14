import QtQuick 2.2
import Sailfish.Silica 1.0
import "../items"
import io.thp.pyotherside 1.4


        Page {
        id: page
        property string imgdata: ""
        property string bgdata: ""
        property string nickname
        property string subject 
        property string selectedFile
        property string challenge
        property string replyTo
        property string boardId
        property string url: replyTo ? "https://sys.4channel.org/captcha?board=" + boardId + "&thread_id=" + replyTo : "https://sys.4channel.org/captcha?board=" + boardId
        property string comment
        property string response
        property int img_width
        property int bg_width
        property int img_height
        property bool loaded: false
        
        
        function getCaptcha(){
            var xhr = new XMLHttpRequest;
            xhr.open("GET",  url);
            xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {

                var data = JSON.parse(xhr.responseText);
                loaded = true;
                challenge = data.challenge;
                imgdata  = data.img;
                img_width = data.img_width;
                img_height = data.img_height;
                bgdata = data.bg;
                bg_width = data.bg_width;
             
            }
                                
        }
            xhr.send();

        }

        
        Item{
            y: screen.height/2 - page.img_height /2

                width: page.img_width *2 
                height: page.img_height *2
            Image {
                id: imgfg
                anchors.top: parent.top
                width: page.bg_width *2 
                height: page.img_height *2
                x: 100 - bgslider.value    
                source: !page.loaded ? page.imgdata : "data:image/png;base64," + page.bgdata  
            }
            Image {
                id: imgbg
                anchors.top: parent.top
                width: page.img_width *2 
                height: page.img_height *2
                source: !page.loaded ? page.bgdata : "data:image/png;base64," + page.imgdata  
            }
            Rectangle {
                anchors.left: imgbg.right
                height: page.img_height *2
                width: screen.width - page.img_width *2 
                color: Theme.rgba(Theme.primaryColor, 1)
            }
              TextField {
                id: captchaInput
                width: parent.width
                anchors.bottom: imgbg.top
                placeholderText: "Enter CAPTCHA"                          
                EnterKey.enabled: text.length > 2
                EnterKey.iconSource: "image://theme/icon-m-enter-accept"
                EnterKey.onClicked: {
                   replyTo ? py.postpost(text) : py.postthread(text);
                        pageStack.navigateBack();
                    }
                    

            }
        


        
            Slider {
            id: bgslider
            anchors.top: imgfg.bottom
            minimumValue: 0
            maximumValue: 200
            stepSize: 2
            enabled: true
            width: parent.width
            handleVisible: true
            label: qsTr("Slide to reveal captcha")
            
        
        }
    Component.onCompleted: {
            page.getCaptcha();
        }
}
                Python {
        id: py

        Component.onCompleted: {
            // Add the Python library directory to the import path
            var pythonpath = Qt.resolvedUrl('../../py/').substr('file://'.length);
            addImportPath(pythonpath);
            importModule('posting', function() {});
                }
            function postpost(response) {
            console.log("Replying to "+replyTo)
            console.log("posting with captchatoken "+challenge)
            console.log("posting with filepath "+selectedFile)
            console.log("posting with subject "+subject)
            console.log("posting with comment "+comment)
            console.log("posting to board "+boardId)
                    console.log(response)

            call('posting.post', [
                     nickname,
                     comment,
                     subject,
                     selectedFile,
                     response,
                     boardId,
                     challenge,
                     replyTo
                 ], function() {});
                    }
                
           function postthread(response) {
            console.log("posting with captchatoken "+challenge)
            console.log("posting with filepath "+selectedFile)
            console.log("posting with subject "+subject)
            console.log("posting with comment "+comment)
            console.log("posting to board "+boardId)
                    console.log(response)

            call('posting.post', [
                     nickname,
                     comment,
                     subject,
                     selectedFile,
                     response,
                     boardId,
                     challenge                     
                 ], function() {});
                }
}
}
