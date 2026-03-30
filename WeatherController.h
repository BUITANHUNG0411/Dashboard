#ifndef WEATHERCONTROLLER_H
#define WEATHERCONTROLLER_H

#include <QObject>
#include <QtNetwork/qnetworkaccessmanager.h>
#include <QGeoPositionInfoSource>

class WeatherController : public QObject {
  Q_OBJECT
public:
  explicit WeatherController(QObject *parent = nullptr);

  Q_INVOKABLE void fetchWeather(QString location);
  Q_INVOKABLE void fetchWeatherUsingGPS(double lat, double lon);
  Q_INVOKABLE void fetchLocationByIP();

signals:
  void weatherDataReceived(QString name, double temp, QString description, double humidity, double windSpeed, QString icon);
private:
  QNetworkAccessManager *m_networkManager;
  QGeoPositionInfoSource *m_gpsManager;
  void processWeatherReply(QNetworkReply *reply);

};

#endif // WEATHERCONTROLLER_H
