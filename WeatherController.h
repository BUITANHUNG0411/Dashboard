#ifndef WEATHERCONTROLLER_H
#define WEATHERCONTROLLER_H

#include <QObject>
#include <QtNetwork/qnetworkaccessmanager.h>

class WeatherController : public QObject {
  Q_OBJECT
public:
  explicit WeatherController(QObject *parent = nullptr);

  Q_INVOKABLE void fetchWeather(QString location);

signals:
  void weatherDataReceived(QString name, double temp, QString description, double humidity, double windSpeed, QString icon);
private:
  QNetworkAccessManager *m_networkManager;
};

#endif // WEATHERCONTROLLER_H
