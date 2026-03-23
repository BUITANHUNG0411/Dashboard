#ifndef CHATCONTROLLER_H
#define CHATCONTROLLER_H

#include <QObject>
#include <QString>
#include <QNetworkAccessManager>
#include "ChatModel.h"

class ChatController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(ChatModel* chatModel READ chatModel CONSTANT)
public:
    explicit ChatController(QObject *parent = nullptr);

    Q_INVOKABLE void sendMessage(QString text);
    Q_INVOKABLE void setModel(QString modelName);
    Q_INVOKABLE void exportLog();
    Q_INVOKABLE void clearChat();

    ChatModel* chatModel() const { return m_chatModel; }

signals:
    void responseReceived(QString text);

private:
    QNetworkAccessManager *m_networkManager;
    QString m_currentModel;
    ChatModel *m_chatModel;
};

#endif
