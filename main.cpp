#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "ChatController.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    ChatController chatBackend;

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("chatBackend", &chatBackend);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("ChatBotDemo", "Main");

    return app.exec();
}
