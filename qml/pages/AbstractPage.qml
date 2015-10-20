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

}
