/*
    This file based on:
    Quickddit - Reddit client for mobile phones
    Copyright (C) 2017  Sander van Grieken
    modifications by szopin
    modifications by jacquesCedric

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
import QtMultimedia 5.0
import "../js/settingsStorage.js" as SettingsStore


Page {
    id: videoViewPage

    property string imgUrl
    property string title
    property string ext
    property string filename
    property string filename_original
    title : filename_original

    property bool error: false

    SilicaFlickable {
        id: videoFlickable
        anchors {
            top: parent.top;
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom
        }

        PullDownMenu {
            id: videoViewMenu

            MenuItem {
                text: qsTr("Open in browser")
                onClicked: {
                    Qt.openUrlExternally(imgUrl)
                }
            }

            MenuItem {
                text: qsTr("Save as")
                onClicked: pageStack.push(Qt.resolvedUrl("SaveFilePage.qml"), {uri: imgUrl})
            }

            Label {
                text: title
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeExtraSmall
                color: Theme.secondaryHighlightColor
                clip: true
                smooth: true
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                playPauseButton.opacity = 1
                if (mediaPlayer.playbackState == MediaPlayer.PlayingState)
                    hideTimer.restart()
            }
        }

        VideoOutput {
            anchors.fill: parent

            source: MediaPlayer {
                id: mediaPlayer
                autoPlay: false
                onDurationChanged: loops = 1
                muted: SettingsStore.getSetting("VideosAutomaticallyMuted") == 1 ? true : false

                onStopped: {
                    if (SettingsStore.getSetting("VideosAutomaticallyLoops") == 1) {
                        play()
                    }
                    playPauseButton.opacity = 1
                }
                onError: {
                    infoBanner.warning(errorString);
                    console.log(errorString);
                }

                onBufferProgressChanged: {
                    if (bufferProgress > 0.90 && SettingsStore.getSetting("VideosAutomaticallyStart") == 1)
                        play();
                    else if (bufferProgress < 0.10)
                        pause();
                }
            }

            Item {
                id: spinner
                anchors.centerIn: parent

                width: busyIndicator.width
                height: busyIndicator.height
                visible: mediaPlayer.bufferProgress < 1 && mediaPlayer.error === MediaPlayer.NoError && !error

                BusyIndicator {
                    id: busyIndicator
                    size: BusyIndicatorSize.Large
                    running: true
                }

                Label {
                    anchors.centerIn: parent
                    text: Math.round(mediaPlayer.bufferProgress * 100) + "%"
                }
            }

            Label {
                id: errorText
                anchors.centerIn: parent
                visible: mediaPlayer.error !== MediaPlayer.NoError || error
                text: qsTr("Error loading video")
            }
        }

        Slider {
            id: progressBar
            enabled: mediaPlayer.seekable && opacity > 0
            opacity: playPauseButton.opacity
            anchors {
                left: parent.left
                bottom: parent.bottom
                right: parent.right
            }
            maximumValue: mediaPlayer.duration > 0 ? mediaPlayer.duration : 1
            value: mediaPlayer.position
            onReleased: {
                mediaPlayer.seek(value)
                value = Qt.binding(function() { return mediaPlayer.position; })
                playPauseButton.opacity = 1
                hideTimer.restart()
            }
        }

        Text {
            anchors {
                right: progressBar.right
                bottom: progressBar.top
                rightMargin: progressBar.rightMargin
                bottomMargin: -progressBar._extraPadding
            }
            opacity: playPauseButton.opacity
        }

        Image {
            id: playPauseButton
            source: "image://theme/icon-l-" + (mediaPlayer.playbackState === MediaPlayer.PlayingState ? "pause" : "play")

            anchors {
                bottom: progressBar.top
                horizontalCenter: parent.horizontalCenter
            }

            MouseArea {
                anchors.fill: parent
                enabled: playPauseButton.opacity > 0
                onClicked: {
                    if (mediaPlayer.playbackState === MediaPlayer.PlayingState) {
                        mediaPlayer.pause()
                        hideTimer.stop()
                        playPauseButton.opacity = 1
                    }
                    else if (mediaPlayer.playbackState === MediaPlayer.PausedState || mediaPlayer.playbackState === MediaPlayer.StoppedState) {
                        mediaPlayer.play()
                        hideTimer.start()
                    }
                }
            }

            Behavior on opacity { NumberAnimation { duration: 200 } }
        }

        // Mute button control
        Image {
            id: muteButton
            source: "image://theme/icon-m-speaker-" + (mediaPlayer.muted === true ? "mute" : "on")
            opacity: playPauseButton.opacity

            anchors {
                left: playPauseButton.right
                leftMargin: 35
                verticalCenter: playPauseButton.verticalCenter
            }

            MouseArea {
                anchors.fill: parent
                enabled: muteButton.opacity > 0
                onClicked: {
                    mediaPlayer.muted = !mediaPlayer.muted
                }
            }
        }
    }

    Component.onCompleted: {
        mediaPlayer.source = imgUrl
    }

    Timer {
        id: hideTimer
        running: true
        interval: 1500
        onTriggered: {
            playPauseButton.opacity = 0
        }
    }

    onError: {
        error = true
        infoBanner.warning(qsTr("Problem finding stream URL"));
    }
}
