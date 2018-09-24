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
    new_req.setRawHeader("User-Agent", "myAppName");
    new_req.setRawHeader("Referer", "https://boards.4chan.org/");
    qDebug() << "NeliapilaNAM used! ";


    QNetworkReply *reply = QNetworkAccessManager::createRequest( op, new_req, outgoingData );
    return reply;

}
