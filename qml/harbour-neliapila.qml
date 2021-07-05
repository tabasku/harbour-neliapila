/*
  Copyright (C) 2019 Joni, Jacob, szopin.
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages"
import "items"
import "js/settingsStorage.js" as SettingsStore

ApplicationWindow {
    initialPage: Component { ThreadsPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")

    InfoBanner { id: infoBanner }

    Component.onCompleted: {
        // Initialize the settings database and standard settings
        // Doesn't do anything if settings already exist
        SettingsStore.initialize();
        initialiseSettings()
    }

    function initialiseSettings() {
        //~ Appearance
        // None implemented yet

        //~ Behaviour
        // Thread Refresh Time
        // Combobox where options [0] = 60s, [1] = 45s, [2] = 30s, [3] = off
        // Default is 45s
        SettingsStore.setSetting( "ThreadRefreshTime",
                                 SettingsStore.getSetting("ThreadRefreshTime", 1) )

        // Quickscroll Active
        // 0 if disabled, 1 is enabled
        SettingsStore.setSetting( "QuickscrollEnabled",
                                 SettingsStore.getSetting("QuickscrollEnabled", 1) )

        // Boards to display on NaviPage
        // 0 if boardModel, 1 is favouriteModel
        SettingsStore.setSetting( "ModelToDisplayOnNavipage",
                                 SettingsStore.getSetting("ModelToDisplayOnNavipage", 0) )

        //////////////////////////
        //~ Media
        // Automatically start webm videos
        // 0 if disabled, 1 is enabled
        SettingsStore.setSetting( "VideosAutomaticallyStart",
                                 SettingsStore.getSetting("VideosAutomaticallyStart", 1) )

        // Automatically loop webm videos
        // 0 if disabled, 1 is enabled
        SettingsStore.setSetting( "VideosAutomaticallyLoops",
                                 SettingsStore.getSetting("VideosAutomaticallyLoops", 1) )

        // Start videos muted
        // 0 if disabled, 1 is enabled
        SettingsStore.setSetting( "VideosAutomaticallyMuted",
                                 SettingsStore.getSetting("VideosAutomaticallyMuted", 0) )

        // Show image spoilers
        // 0 if disabled, 1 is enabled
        SettingsStore.setSetting( "SpoilerImages",
                                 SettingsStore.getSetting("SpoilerImages", 0) )
        //////////////////////////
        //~ About
        // None implemented yet
    }
}


