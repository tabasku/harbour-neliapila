/*
Neliapila - client for browsing 4chan image board.
2015-2019 Joni Kurunsaari
2019- Jacob Gold
2019- szopin
Issues: https://github.com/tabasku/harbour-neliapila/issues

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0
import "../js/settingsStorage.js" as SettingsStore


Page {
    id: settingsPage

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height + Theme.paddingLarge

        VerticalScrollDecorator {}

        RemorsePopup { id: settingClearedRemorse }

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column
            spacing: Theme.paddingLarge
            width: parent.width

            PageHeader { title: "Settings" }

            ExpandingSectionGroup {
                id: settingsExpandingGroup
                currentIndex: 2

                ExpandingSection {
                    id: behaviourSection

                    property int sectionIndex: 0
                    title: "Behaviour"

                    content.sourceComponent: Column {
                        width: settingsExpandingGroup.width

                        ComboBox {
                            label: "Boards list"
                            description: "Which boards to display by default, all boards (with favourites pinned to the top) or only favourites"
                            currentIndex: SettingsStore.getSetting("ModelToDisplayOnNavipage")

                            menu: ContextMenu {
                                MenuItem { text: "All Boards" }
                                MenuItem { text: "Favourites" }
                            }

                            onCurrentIndexChanged: {
                                SettingsStore.setSetting("ModelToDisplayOnNavipage", currentIndex)
                            }
                        }

                        ComboBox {
                            label: "Thread refresh time"
                            description: "Set the time (in seconds) between fetching new posts in a thread or, optionally, disable auto-refresh"
                            currentIndex: SettingsStore.getSetting("ThreadRefreshTime")

                            menu: ContextMenu {
                                MenuItem { text: "60 seconds" }
                                MenuItem { text: "45 seconds" }
                                MenuItem { text: "30 seconds" }
                                MenuItem { text: "off" }
                            }

                            onCurrentIndexChanged: {
                                SettingsStore.setSetting("ThreadRefreshTime", currentIndex)
                            }
                        }

                        TextSwitch {
                            text: "Quickscroll active"
                            description: "Disable or enable quickscroll funtionality"
                            checked: SettingsStore.getSetting("QuickscrollEnabled") == 1 ? true : false

                            onCheckedChanged: {
                                SettingsStore.setSetting("QuickscrollEnabled", checked ? 1 : 0)
                            }
                        }
                    }
                } // End of Behaviour Settings section

                ExpandingSection {
                    id: mediaSection

                    property int sectionIndex: 1
                    title: "Media"

                    content.sourceComponent: Column {
                        width: settingsExpandingGroup.width

                        TextSwitch {
                            text: "Automatically start webm videos"
                            description: "Disable or enable Automatic playing of webms"
                            checked: SettingsStore.getSetting("VideosAutomaticallyStart") == 1 ? true : false

                            onCheckedChanged: {
                                SettingsStore.setSetting("VideosAutomaticallyStart", checked ? 1 : 0)
                            }
                        }

                        TextSwitch {
                            text: "Automatically loop webm videos"
                            description: "Disable or enable Automatic looping of webms"
                            checked: SettingsStore.getSetting("VideosAutomaticallyLoops") == 1 ? true : false

                            onCheckedChanged: {
                                SettingsStore.setSetting("VideosAutomaticallyLoops", checked ? 1 : 0)
                            }
                        }

                        TextSwitch {
                            text: "Start videos muted"
                            description: "Toggle videos automatically playing muted or not"
                            checked: SettingsStore.getSetting("VideosAutomaticallyMuted") == 1 ? true : false

                            onCheckedChanged: {
                                SettingsStore.setSetting("VideosAutomaticallyMuted", checked ? 1 : 0)
                            }
                        }
                    }
                } // End of Media Settings section


                // This part could look better
                // Should be worked on in the future
                ExpandingSection {
                    id: aboutSection

                    property int sectionIndex: 2
                    title: "About"

                    content.sourceComponent: Column {
                        width: settingsExpandingGroup.width

                        ListItem {
                            id: aboutListItem
                            anchors.margins: 15

                            Label {
                                id: aboutListItemPrimaryLabel
                                text: "About Neliapila..."
                            }

                            Label {
                                anchors.top: aboutListItemPrimaryLabel.bottom

                                text: "Version 0.8"
                                font.pixelSize: Theme.fontSizeExtraSmall
                            }

                            onClicked: {
                                pageStack.push("AboutPage.qml");
                            }
                        }

                        ListItem {
                            id: returnDefaultSettingListItem
                            anchors.margins: 15

                            Label {
                                id: returnToDefaultLabel
                                text: "Reset Settings to default"
                            }

                            Label {
                                anchors.top: returnToDefaultLabel.bottom

                                text: "Neliapila will exit after this (irreversible) action!"
                                font.pixelSize: Theme.fontSizeExtraSmall
                            }

                            onClicked: {
                                settingClearedRemorse.execute("Clearing settings and restarting app", function() {
                                    SettingsStore.resetSettingsDB()
                                    Qt.quit()
                                })
                            }

                            Rectangle {
                                anchors.fill: parent
                                color: "#33FF0000"
                            }
                        }
                    }
                } // End of About section
            }
        }
    }
}


