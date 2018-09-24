#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif


#include <sailfishapp.h>
#include "neliapilanam.h"

#include <QGuiApplication>
#include <QNetworkAccessManager>

#include <QQmlEngine>
#include <QQmlNetworkAccessManagerFactory>

#include <QNetworkRequest>

#include <QtQuick/QQuickView>

#include <QDebug>
/*
class NAM : public QNetworkAccessManager {

    Q_OBJECT

    protected:

        virtual QNetworkReply * createRequest(Operation op,
                                              const QNetworkRequest & req,
                                              QIODevice * outgoingData = 0) {

            if (req.url().path().endsWith("css")) {
                qDebug() << "skipping " << req.url();
                return QNetworkAccessManager::createRequest(QNetworkAccessManager::GetOperation,
                                                            QNetworkRequest(QUrl()));
            } else {
                return QNetworkAccessManager::createRequest(op, req, outgoingData);
            }
        }


    public:

        virtual QNetworkReply * get(const QNetworkRequest &request) {

            qDebug() << "request header "; // << request.header();

             if (request.url.contains("captcha2.html")) {
                request.setRawHeader("Referer", "https://boards.4chan.org/");


            return QNetworkAccessManager::get(request);
        }

};
*/

class MyNetworkAccessManagerFactory : public QQmlNetworkAccessManagerFactory
{
    public:
        QNetworkAccessManager *create(QObject *parent) override;

};

QNetworkAccessManager *MyNetworkAccessManagerFactory::create(QObject *parent)
{

    NeliapilaNAM *nam = new NeliapilaNAM(parent);
    qInfo() << "MyNetworkAccessManagerFactory CREATED! ";

    return nam;
}

int main(int argc, char *argv[])
{

    QGuiApplication *app = SailfishApp::application(argc, argv);
    QQuickView *view = SailfishApp::createView();
    QString qml = QString("qml/harbour-neliapila.qml");

    //Register custom nam
    MyNetworkAccessManagerFactory networkManagerFactory;
    view->engine()->setNetworkAccessManagerFactory(&networkManagerFactory);


    view->setSource(SailfishApp::pathTo(qml));
    view->show();

    return app->exec();
    //return SailfishApp::main(argc, argv);
}


