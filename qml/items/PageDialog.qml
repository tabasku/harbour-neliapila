import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    id: openLinkDialog

    property int pages: 10
    property string boardId

    SilicaListView {
        id: pageView
        model: pages
        anchors.fill: parent
        header: PageHeader {
            title: "Choose page <b>/"+boardId + "/</b>"
        }
        delegate: BackgroundItem {
            id: delegate
            Label {
                x: Theme.paddingLarge
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeHuge
                text: "<b>"+parseInt(index+1)+"</b>"
                //anchors.verticalCenter: parent.verticalCenter
                color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
            }
            onClicked: {
                var threadPage = pageStack.find(function(page) { return page.objectName === "threadPage"; });
                threadPage.busy = true
                var page = parseInt(index) + 1
                threadPage.change_page(String(page))
                pageStack.navigateBack();
            }
        }
        VerticalScrollDecorator {}
    }

}
