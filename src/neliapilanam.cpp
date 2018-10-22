#include "neliapilanam.h"

NeliapilaNAM::NeliapilaNAM(QObject *parent)
{

}


/*
QNetworkReply *NeliapilaNAM::get(const QNetworkRequest &request)
{
    if (request.url.contains("google")) {
        request.setRawHeader("Referer", "https://boards.4chan.org/");
    }
    return QNetworkAccessManager::get(request)
}
*/

QNetworkReply *NeliapilaNAM::createRequest(QNetworkAccessManager::Operation op, const QNetworkRequest &req, QIODevice *outgoingData)
{

    QNetworkRequest new_req(req);
    new_req.setRawHeader("User-Agent",
    "Mozilla/5.0 (Maemo; Linux; Jolla; Sailfish; Mobile) AppleWebKit/534.13 (KHTML, like Gecko) NokiaBrowser/8.5.0 Mobile Safari/534.13");
    new_req.setRawHeader("Referer", "https://boards.4chan.org/");
    qDebug() << "NeliapilaNAM used! ";


    QNetworkReply *reply = QNetworkAccessManager::createRequest( op, new_req, outgoingData );
    return reply;

}
