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

AbstractPage {
    id: settingsPage

    title: "Settings"
    busy: false

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height

        Component.onCompleted: {
            // Initialize the database
            SettingsStore.initialize();
            // Sets a value in the database
            SettingsStore.setSetting("testValue","first test");

            console.log("The value of mySetting is:\n" + SettingsStore.getSetting("testValue"))
        }

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column

            width: settingsPage.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: "Settings"
            }

            Column {
                id:settings_spacer
                width: settingsPage.width
                height: 10
            }

            Column {
                id: timer_settings_column
                width: settingsPage.width

                TextSwitch {
                    id: timerSwitch
                    text: "Start with last used board"
                    description: "Overrides first board setting on <i>Boards</i>"
                    onCheckedChanged: {
                        if (timer) {
                            timer=false
                        }
                        else {
                            timer=true
                        }
                    }
                }

                TextSwitch {
                    id: activationSwitch
                    text: "Pepe enabled"
                    description: "Shows frog when something goes wrong"
                    onCheckedChanged: {
                        autoincrement  = true

                        if (autoincrement) {
                            weightField.opacity = 1
                        }
                        else{
                            weightField.opacity = 0
                        }
                    }
                }
            }

            Column {
                id:auto_increment_column
                width: settingsPage.width




            }

            Column {
                id: redownload_boards_column
                anchors.horizontalCenter: parent.horizontalCenter

                Button {
                    id:redownload_boards_button
                    text: "Refresh boards"
                    onClicked: {
                        console.log("I don't work yet!")
                    }
                }
            }

            Column {
                id: example_setting_column
                anchors.horizontalCenter: parent.horizontalCenter

                Button {
                    id:example_install_button
                    text: "About Neliapila"
                    onClicked: {
                        pageStack.push("AboutPage.qml");
                    }
                }
            }
        }
    }
}


