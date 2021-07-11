import QtQuick 2.2
import Sailfish.Silica 1.0

//ApplicationWindow{

    
//initialPage: Page {
        Page {
    id: page
        property string imgdata: ""
        property string bgdata: ""
        property string challenge
        property string replyTo
        property string boardId
        property string comment
        property string response
        property int img_width
        property int bg_width
        property int img_height
        property bool loaded: false
                       function getCaptcha(){
            var xhr = new XMLHttpRequest;
        xhr.open("GET",  "https://sys.4channel.org/captcha?board=" + boardId + "&thread_id=" + replyTo);// + thread_id);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                    console.log(boardId, replyTo);
                var data = JSON.parse(xhr.responseText);
                    loaded = true;
                challenge = data.challenge;
                imgdata  = data.img;
                img_width = data.img_width;
                img_height = data.img_height;
                bgdata = data.bg;
                bg_width = data.bg_width;
                    console.log(challenge, img_width, bg_width);                
            }
                                
        }
            xhr.send();

            console.log("end", page.imgdata,page.loaded);
        }

        function postCaptcha(text){
            var xhr = new XMLHttpRequest;
            var url = "https://sys.4channel.org/" + boardId + "/post";
            var params = encodeURI("MAX_FILE_SIZE=4194304&mode=regist&resto=" + replyTo + "&name=&email=&com=" + comment + "&t-response=" + text + "&t-challenge=" + challenge); //!|\nContent-Disposition: form-data; name=\"MAX_FILE_SIZE\"\n\n4194304\n!|\nContent-Disposition: form-data; name=\"mode\"\n\nregist\n!|\nContent-Disposition: form-data; name=\"resto\"\n\n4644876\n!|\nContent-Disposition: form-data; name=\"name\"\n\n\n!|\nContent-Disposition: form-data; name=\"email\"\n\n\n!|\nContent-Disposition: form-data; name=\"com\"\n\nTeStA\n!|\nContent-Disposition: form-data; name=\"t-response\"\n\n" + text + "\n!|\nContent-Disposition: form-data; name=\"t-challenge\"\n\n" + challenge + "\n!|--";
            console.log(params, url);
        xhr.open("POST",  url, true);
            xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
            //multipart/form-data; boundary=!|");
            xhr.setRequestHeader("Content-length", params.length);
            xhr.setRequestHeader("Connection", "close");
            xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                    console.log(xhr.responseText);
                }
            }
            xhr.send(params);    
        }
        
        Item{
            y: screen.height/2 - page.img_height /2
           // x: screen.width/2
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
                        SearchField {
                id: searchField
                width: parent.width
                anchors.top: parent.bottom
                placeholderText:  qsTr("Search in all threads")                                              
                EnterKey.enabled: text.length > 2
                EnterKey.iconSource: "image://theme/icon-m-enter-accept"
                EnterKey.onClicked: {
                        page.postCaptcha(text);
                        pageStack.navigateBack();
                    }
                    

               // onTextChanged: if (!text) _reset()
            }
        

                    /*        Button {
                    id: captchaSubmit
                    text: "Submit"
                                anchors.top: searchField.bottom
                    enabled: page.response.length
                    onClicked: {
                        page.postCaptcha();
                    }*/
            
        //}
        
            Slider {
            id: bgslider
            anchors.bottom: page.bottom
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
}
