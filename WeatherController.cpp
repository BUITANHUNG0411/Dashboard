#include "WeatherController.h"
#include <QByteArray>
#include <QGeoPositionInfo>
#include <QGeoPositionInfoSource>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QUrl>

WeatherController::WeatherController(QObject *parent)
    : QObject{parent}, m_networkManager(new QNetworkAccessManager(this)),
      m_gpsManager(QGeoPositionInfoSource::createDefaultSource(this))
{
    // connect(m_gpsManager, &QGeoPositionInfoSource::positionUpdated, this, [=](QGeoPositionInfo info) {
    //         double lat = info.coordinate().latitude();
    //         double lon = info.coordinate().longitude();
    //         this->fetchWeatherUsingGPS(lat, lon);
    // });

    // connect(m_gpsManager, &QGeoPositionInfoSource::errorOccurred, this,
    //       [=]() { fetchWeatherUsingGPS(10.8231, 106.67); qDebug() << "Error while finding real gps" << "\n";});

    // m_gpsManager->requestUpdate();

    fetchLocationByIP();
}

void WeatherController::fetchWeather(QString location) {
  QString apiKey = "d6f3d488a290b3bcc1002483e193648c";
  QString urlString =
      "https://api.openweathermap.org/data/2.5/weather?q=" + location +
      "&appid=" + apiKey + "&units=metric";
  QUrl url(urlString);
  QNetworkRequest request(url);
  QNetworkReply *reply = m_networkManager->get(request);

  connect(reply, &QNetworkReply::finished, this,
          [this, reply]() { processWeatherReply(reply); });
}

void WeatherController::fetchWeatherUsingGPS(double lat, double lon) {
  QString apiKey = "d6f3d488a290b3bcc1002483e193648c";
  QString urlString = "https://api.openweathermap.org/data/2.5/weather?lat=" +
                      QString::number(lat) + "&lon=" + QString::number(lon) +
                      "&appid=" + apiKey + "&units=metric";
  QUrl url(urlString);

  QNetworkRequest request(url);
  QNetworkReply *reply = m_networkManager->get(request);

  connect(reply, &QNetworkReply::finished, this,
          [this, reply]() { processWeatherReply(reply); });
}

void WeatherController::fetchLocationByIP()
{
    QUrl url("http://ip-api.com/json");
    QNetworkRequest request(url);
    QNetworkReply *reply = m_networkManager->get(request);

    connect(reply, &QNetworkReply::finished, this, [this, reply](){
        if (reply->error() == QNetworkReply::NoError) {
            QByteArray responseData = reply->readAll();
            QJsonDocument responseDoc = QJsonDocument::fromJson(responseData);
            QJsonObject response = responseDoc.object();

            QString status = response["status"].toString();
            double lat = response["lat"].toDouble();
            double lon = response["lon"].toDouble();
            QString city = response["city"].toString();
            QString country = response["country"].toString();

            // qDebug() << "Status = " << status << "\n"
            //          << "Lat = " << lat << "\n"
            //          << "Lon = " << lon << "\n"
            //          << "City = " << city << "\n"
            //          << "Country = " << country << "\n";
            if (status == "success") fetchWeatherUsingGPS(lat,lon);
            else qDebug() <<"Can not find your real location" << "\n";
        }
        reply->deleteLater();
    });
}

void WeatherController::processWeatherReply(QNetworkReply *reply) {
  if (reply->error() == QNetworkReply::NoError) {
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
  } else {
    qDebug() << reply->errorString() << "\n";
  }
  reply->deleteLater();
}
