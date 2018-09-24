#ifndef NETWORKACCESSMANAGER_H
#define NETWORKACCESSMANAGER_H

#include <QQmlNetworkAccessManagerFactory>
#include <QNetworkRequest>

class NetworkAccessManager : public QNetworkAccessManager
{
    Q_OBJECT
    public:
        NetworkAccessManager(QObject parent = 0);
        QNetworkReply get(const QNetworkRequest &request);
    protected:
        virtual QNetworkReply* createRequest(Operation op, const QNetworkRequest &req, QIODevice *outgoingData = Q_NULLPTR);
};

class NetworkAccessManagerFactory : public QObject, public QQmlNetworkAccessManagerFactory
{
    Q_OBJECT
    public:
        explicit NetworkAccessManagerFactory(QObject parent = 0);
        virtual QNetworkAccessManager create(QObject parent);
    private:
        QNetworkAccessManager m_networkManager;
};

#endif // NETWORKACCESSMANAGER_H
