#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif

#include <sailfishapp.h>

int main(int argc, char *argv[])
{
    return SailfishApp::main(argc, argv);
}

/*class MyNetworkManager : public QNetworkAccessManager {
    public: QNetworkReply *QNetworkAccessManager::get(const QNetworkRequest &request) {
        if (request.url.contains("captcha2.html")) {
            request.setRawHeader("Referer", "https://boards.4chan.org/");
        }
        return QNetworkAccessManager::get(request);
    }
};*/
