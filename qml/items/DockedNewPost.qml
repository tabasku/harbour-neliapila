import QtQuick 2.0
import Sailfish.Silica 1.0
import Sailfish.Pickers 1.0
import io.thp.pyotherside 1.4
import Nemo.Thumbnailer 1.0

DockedPanel {

    id: newPostItem

    property string boardId: boardId
    property int replyTo: 0
    property string selectedFile

    property string nickname: nameText.text
    property string options: ""
    property string subject: subjectText.text
    property string comment: commentText.text
    //property string file_path: selectedFile ? selectedFile : ""
    property variant captcha_token
    property bool optionalFieldsVisible: false

    //anchors.fill: parent
    width: parent.width
    height: commentRow.height + postActionButtons.height + optionalFields.height + pageMargin*2

    Item {
        anchors.fill: parent

        Rectangle {
            anchors.fill: parent

            //color: "black"

            gradient: Gradient {
                GradientStop { position: 0.0; color: Theme.rgba(Theme.highlightDimmerColor, 1) }
                GradientStop { position: 5.0; color: Theme.rgba(Theme.highlightDimmerColor, 0.5) }
            }

        }
    }

    Item{

        anchors{
            fill: parent
            topMargin: pageMargin
            bottomMargin: Theme.paddingSmall
            leftMargin: pageMargin
            rightMargin: pageMargin
        }


        Column {
            id: column

            width: parent.width
            height: commentText.text
                    ? commentText.height
                    : commentText.height + screen.height * 0.3
            //height: parent.contentHeight
            spacing: Theme.paddingSmall

            anchors.fill: parent

            Row{
                id: commentRow
                //width: parent.width

                spacing: 0
                //spacing: Theme.paddingSmall

                Rectangle{
                    //spacing: Theme.paddingSmall
                    width: column.width/3
                    height: width

                    //color: "transparent"

                    gradient: Gradient {
                        GradientStop { position: 0.0; color: Theme.rgba(Theme.primaryColor, 0) }
                        GradientStop { position: 1.0; color: Theme.rgba(selectedFile
                                                                        ? Theme.primaryColor
                                                                        : "red", 0.2) }
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

                        MouseArea{
                            anchors.fill: parent
                            onClicked: pageStack.push(filePickerPage)
                        }

                    }
                }

                Column{
                    height: commentText.contentHeight < column.width/3
                            ? column.width/3
                            : commentText.contentHeight
                    spacing: 0

                    TextArea{
                        id: commentText
                        width: column.width/3*2
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeSmall
                        clip: false
                        //focus: newPostPanel.open
                        focus: false
                        wrapMode: TextEdit.Wrap
                        color: text ? Theme.primaryColor : 'red'
                        label: 'Comment ' + text.length + '/2000'
                        placeholderText: 'Comment'
                        text: comment
                    }
                }
            }

            Rectangle{
                id: optionalFields

                //spacing: Theme.paddingSmall
                width: column.width
                height: optionalFieldsVisible
                        ? nameText.height + subjectText.height + Theme.paddingSmall
                        : 0
                color: "transparent"

                /*
                gradient: Gradient {
                    GradientStop { position: 0.0; color: Theme.rgba(Theme.primaryColor, 0) }
                    GradientStop { position: 1.0; color: Theme.rgba(Theme.primaryColor, 0.2) }
                }
                */

                Column{

                    TextField{
                        id: subjectText
                        width: column.width
                        visible: optionalFieldsVisible
                        //wrapMode: Text.WordWrap
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.primaryColor
                        //text: content
                        //x: Theme.paddingSmall
                        clip: true

                        focus: optionalFieldsVisible
                        label: 'Subject'
                        placeholderText: 'Subject'
                        text: subject
                    }

                    Row {

                        TextField{
                            id: nameText
                            width: column.width/3*2
                            visible: optionalFieldsVisible
                            //wrapMode: Text.WordWrap
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.primaryColor
                            //text: content
                            //x: Theme.paddingSmall
                            clip: true
                            focus: false
                            placeholderText: "Anonymous"
                            label: 'Name'
                            text: nickname
                        }

                        TextField{
                            id: optionsText
                            width: column.width/3
                            visible: optionalFieldsVisible
                            //wrapMode: Text.WordWrap
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.primaryColor
                            //text: content
                            //x: Theme.paddingSmall
                            clip: true
                            focus: false
                            label: 'Options'
                            placeholderText: 'Options'
                            text: options
                        }

                    }
                }
            }

            Rectangle{
                id: postActionButtons
                color: "transparent"
                width: column.width
                height: Theme.iconSizeMedium

                IconButton {
                    id: closePostButton
                    width: Theme.iconSizeMedium
                    height: width


                    anchors {
                        bottom: parent.bottom
                        left: parent.left
                        leftMargin: Theme.paddingSmall
                    }

                    icon.source: "image://theme/icon-m-tab-close"
                    onClicked: {
                        newPostItem.open = false
                    }
                }

                IconButton {
                    id: postButton
                    width: Theme.iconSizeMedium
                    height: width

                    enabled: commentText.text.length && selectedFile
                            ? true
                            : false

                    anchors {
                        bottom: parent.bottom
                        right: parent.right
                        rightMargin: Theme.paddingSmall
                    }

                    icon.source: "image://theme/icon-m-message"
                    onClicked: {
                        pyPosting.post()
                        //pageStack.push("../pages/Captcha2Page.qml")
                    }
                }


                IconButton {
                    id: expandOptionalButton
                    width: Theme.iconSizeMedium
                    height: width


                    anchors {
                        bottom: parent.bottom
                        right: postButton.left
                        rightMargin: Theme.paddingSmall
                    }

                    icon.source: optionalFieldsVisible
                                 ? "image://theme/icon-m-up"
                                 : "image://theme/icon-m-down"
                    onClicked: {
                        optionalFieldsVisible
                                ? optionalFieldsVisible = false
                                : optionalFieldsVisible = true

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
            //newPostItem.selectedImageThumb.source = selectedContentProperties.filePath
            selectedImageThumb.source = "image://nemoThumbnail/" + selectedContentProperties.filePath
        }
    }
}

}
