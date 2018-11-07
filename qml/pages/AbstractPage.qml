/*
    Neliapila - 4chan.org client for mobile phones
    Copyright (C) 2015  Joni Kurunsaari
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see [http://www.gnu.org/licenses/].
*/

import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.4
import "../items"

Page {
    id: abstractPage

    property bool busy: false
    property string title: ""
    //property string singlePost;

    property string boardId
    property int pageNo: 1
    property string postNo

    property string errorText: "Oops, somethind did go wrong..."
    property string fontPixelSize: Theme.fontSizeSmall

    property int padding : Theme.paddingSmall
    property int infoFontSize: Theme.fontSizeSmall
    property variant infoFontColor: Theme.secondaryHighlightColor
    property int postFontSize: Theme.fontSizeMedium
    property int pageMargin : Theme.horizontalPageMargin
    property bool animations : false


    allowedOrientations : Orientation.All

    BusyIndicator {
        id: busyIndicator;
        anchors.centerIn: parent;
        size: BusyIndicatorSize.Large;
        running: busy;
    }
/*
    IconButton {
        id: play
        icon.source: "image://theme/icon-l-play"
        onClicked: iconButtons.playing = true
        enabled: !iconButtons.playing
        anchors {
            left: parent.right
            bottom: parent.bottom
            leftMargin: Theme.paddingMedium
            bottomMargin: Theme.paddingMedium

        }
        z: -1

    }*/

    function setBusy(state) {
        busy = state;
        busyIndicator.running = state;
        //console.log("busyIndicator "+busyIndicator.running)
    }

    function hideBusyIndicator() {
        busyIndicator.visible = false
    }

    function sleep(milliseconds) {
        var start = new Date().getTime();
        for (var i = 0; i < 1e7; i++) {
            if ((new Date().getTime() - start) > milliseconds){
                break;
            }
        }
    }

    Python {
        id: pyPosting

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
