#include "ChatController.h"
#include "WeatherController.h"
#include "note.h"
#include "NoteFilterModel.h"
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

int main(int argc, char *argv[]) {
  QGuiApplication app(argc, argv);

  ChatController chatBackend;
  WeatherController weatherControl;
  Note noteControl;
  NoteFilterModel noteFilterControl;

  QQmlApplicationEngine engine;
  engine.rootContext()->setContextProperty("chatBackend", &chatBackend);
  engine.rootContext()->setContextProperty("weatherControl", &weatherControl);
  engine.rootContext()->setContextProperty("noteControl", &noteControl);
  engine.rootContext()->setContextProperty("noteFilterControl", &noteFilterControl);
  noteFilterControl.setSourceModel(&noteControl);

      QObject::connect(
          &engine, &QQmlApplicationEngine::objectCreationFailed, &app,
          []() { QCoreApplication::exit(-1); }, Qt::QueuedConnection);
  engine.loadFromModule("ChatBotDemo", "Main");

  return app.exec();
}
 