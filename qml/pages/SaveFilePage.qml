import QtQuick 2.1
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.4

Dialog {
    id: page
    property string uri: ""
    property var dirs: []
    property string dir: "."

    onAccepted: py.call('savefile.save', [dir, uri.match(/\d+\.[a-z]+/)[0], uri] );

    SilicaListView {
        id: saveform
        header: PageHeader {
            title: qsTr("Save")
        }
        model: dirs
        anchors{
            fill: parent
        }
        delegate: BackgroundItem {
            id: directory
            width: ListView.view.width
            height: Theme.itemSizeSmall
            Label {
                text: modelData
                color: directory.highlighted ? Theme.highlightColor : Theme.primaryColor
                anchors{
                    left: parent.left
                    leftMargin: 10
                }
            }
            onClicked: {
                dir = dir + "/" + modelData
                cd (dir)
            }
        }
        Component.onCompleted: cd (dir)
    }
    Python {
        id: py

        Component.onCompleted: {
            // Add the Python library directory to the import path
            var pythonpath = Qt.resolvedUrl('../py/').substr('file://'.length);
            //var pythonpath = Qt.resolvedUrl('.').substr('file://'.length);
            addImportPath(pythonpath);
            console.log(pythonpath);
            importModule('savefile', function() {});
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

    function cd(dir) {
        py.call('savefile.getdirs', [dir], function(response) {
            page.dirs = response
        });
    }
}
