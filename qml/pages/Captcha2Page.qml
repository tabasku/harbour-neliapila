import QtQuick 2.2
import Sailfish.Silica 1.0
import Sailfish.Pickers 1.0

Page {
    id: page

    SilicaWebView {
        id: webView

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: urlField.top
        }
        url: "http://sailfishos.org"
    }
}

