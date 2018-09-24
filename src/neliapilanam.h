#ifndef NELIAPILANAM_H
#define NELIAPILANAM_H

#include <QObject>

#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>

#include <QDebug>

class NeliapilaNAM : public QNetworkAccessManager
{
    public:
       explicit NeliapilaNAM(QObject *parent = 0);

    protected:
        QNetworkReply *createRequest( Operation op, const QNetworkRequest &req, QIODevice * outgoingData=0 );

};

#endif // NELIAPILANAM_H
