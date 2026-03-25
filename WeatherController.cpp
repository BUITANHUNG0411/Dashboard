#include "WeatherController.h"
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QUrl>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QByteArray>

WeatherController::WeatherController(QObject *parent)
    : QObject{parent},
    m_networkManager(new QNetworkAccessManager(this)
    )
{}

void WeatherController::fetchWeather(QString location)
{
    QString apiKey = "2053bcc58221bac5c4f9cd5ed00ea57c";
    QString urlString = "https://api.openweathermap.org/data/2.5/weather?q="
                        + location
                        + "&appid="
                        + apiKey
                        + "&units=metric";
    QUrl url(urlString);
    QNetworkRequest request(url);
    QNetworkReply *reply = m_networkManager->get(request);

    connect(reply, &QNetworkReply::finished, this, [this, reply](){
        if (reply->error() == QNetworkReply::NoError){
            QByteArray responseData = reply->readAll();
            QJsonDocument responseDocs = QJsonDocument::fromJson(responseData);
            QJsonObject rootObj = responseDocs.object();

            double temp = rootObj["main"].toObject()["temp"].toDouble();
            QString description = rootObj["weather"].toArray().first().toObject()["description"].toString();
            QString name = rootObj["name"].toString();
            double humidity = rootObj["main"].toObject()["humidity"].toDouble();
            double speed = rootObj["wind"].toObject()["speed"].toDouble();
            QString icon = rootObj["weather"].toArray().first().toObject()["icon"].toString();

            emit weatherDataReceived(name, temp, description, humidity, speed, icon);
        }
        reply->deleteLater();
    });
}
