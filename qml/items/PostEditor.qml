import QtQuick 2.0
import Sailfish.Silica 1.0
import Sailfish.Pickers 1.0
import io.thp.pyotherside 1.4
import Nemo.Thumbnailer 1.0

BackgroundItem {
    Item {
        anchors.fill: parent

        Rectangle {
            anchors.bottom: parent.bottom
            width: parent.width
            height: screen.height*0.5

            gradient: Gradient {
                GradientStop { position: 0.0; color: Theme.rgba(Theme.highlightDimmerColor, 1) }
                GradientStop { position: 0.5; color: Theme.rgba(Theme.highlightDimmerColor, 0.5) }
                GradientStop { position: 1.0; color: Theme.rgba(Theme.highlightDimmerColor, 0.1) }
            }
        }
    }

    id: newPostItem
    anchors.fill: parent

    property string boardId: boardId
    property int replyTo: 0
    property string selectedFile

    property string nickname: nameText.text
    property string options: ""
    property string subject: subjectText.text
    property string comment: commentText.text
    property variant captcha_token

    SilicaFlickable {
        anchors.fill: parent

        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height

        PullDownMenu {
            id: newPostPullDownMenu
            busy : busy

            MenuItem {
                text: qsTr("Post")

                onClicked: {
                    pageStack.push("../pages/Captcha2Page.qml");
                }
            }
        }

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column

            width: parent.width
            height: parent.contentHeight
            spacing: Theme.paddingSmall

            anchors {
                left:parent.left
                right:parent.right
                leftMargin: pageMargin
                rightMargin: pageMargin
            }

            PageHeader {
                title: "New Post"
            }

            Row {
                spacing: 0
                //spacing: Theme.paddingSmall

                Rectangle {
                    //spacing: Theme.paddingSmall
                    width: column.width/3
                    height: width
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: Theme.rgba(Theme.primaryColor, 0) }
                        GradientStop { position: 1.0; color: Theme.rgba(Theme.primaryColor, 0.2) }
                    }

                    Image {
                        id: selectedImageThumb
                        source: selectedFile ? "image://nemoThumbnail/" + selectedFile : "image://theme/icon-l-image"
                        width: parent.width
                        height: parent.height
                        fillMode: Image.PreserveAspectCrop
                        sourceSize.width: selectedImageThumb.width
                        sourceSize.height: selectedImageThumb.height
                        asynchronous: true

                        MouseArea {
                            anchors.fill: parent
                            onClicked: pageStack.push(filePickerPage)
                        }
                    }
                }

                Column {
                    height: commentText.contentHeight < column.width/3 ? column.width/3 : commentText.contentHeight

                    TextField{
                        id: subjectText
                        width: column.width/3*2
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.primaryColor
                        clip: true
                        focus: false
                        label: 'Subject'
                        placeholderText: 'Subject'
                        text: subject
                    }

                    TextArea {
                        id: commentText
                        width: column.width/3*2
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeSmall
                        clip: false
                        focus: false
                        wrapMode: TextEdit.Wrap
                        color: text ? Theme.primaryColor : 'red'
                        label: 'Comment'
                        placeholderText: 'Comment'
                        text: comment
                    }
                }
            }

            Rectangle {
                width: column.width
                height: nameText.height + optionsText.height
                color: "transparent"

                Row {
                    TextField {
                        id: nameText
                        width: column.width/3*2
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.primaryColor
                        clip: true
                        focus: false
                        placeholderText: "Anonymous"
                        label: 'Name'
                        text: nickname
                    }

                    TextField {
                        id: optionsText
                        width: column.width/3
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.primaryColor
                        clip: true
                        focus: false
                        label: 'Options'
                        placeholderText: 'Options'
                        text: options
                    }
                }
            }
        }
    }

    Component {
        id: filePickerPage
        FilePickerPage {
            nameFilters: [ '*.jpg', '*.png', '*.webm','*.gif' ]
            onSelectedContentPropertiesChanged: {
                newPostItem.selectedFile = selectedContentProperties.filePath
                selectedImageThumb.source = "image://nemoThumbnail/" + selectedContentProperties.filePath
            }
        }
    }
}
