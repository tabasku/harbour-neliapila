#include "networkaccessmanager.h"

NetworkAccessManager::NetworkAccessManager(QObject *parent) :
QNetworkAccessManager(parent)
{
}

QNetworkReply* NetworkAccessManager::get(const QNetworkRequest &request) {
    qDebug() << "Url path: " << request.url().path();
    return NetworkAccessManager::get(request);
}

QNetworkReply* NetworkAccessManager::createRequest(Operation op, const QNetworkRequest &req, QIODevice outgoingData) {
qDebug() << "Create request";
QNetworkReply reply = QNetworkAccessManager::createRequest(op, req, outgoingData);
return reply;
}

NetworkAccessManagerFactory::NetworkAccessManagerFactory(QObject *parent) :
QObject(parent)
{
}

QNetworkAccessManager *NetworkAccessManagerFactory::create(QObject *parent)
{
NetworkAccessManager *nam = new NetworkAccessManager(parent);
return nam;
}
