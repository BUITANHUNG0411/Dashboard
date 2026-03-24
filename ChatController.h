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
    Q_PROPERTY(bool isDarkMode READ getIsDarkMode WRITE setIsDarkMode NOTIFY isDarkModeChanged FINAL)
public:
    explicit ChatController(QObject *parent = nullptr);

    Q_INVOKABLE void sendMessage(QString text);
    Q_INVOKABLE void setModel(QString modelName);
    Q_INVOKABLE void exportLog();
    Q_INVOKABLE void clearChat();

    bool getIsDarkMode() const { return m_isDarkMode; }
    void setIsDarkMode(bool mode) { if (m_isDarkMode == mode) return; m_isDarkMode = mode; emit isDarkModeChanged(m_isDarkMode); }

    ChatModel* chatModel() const { return m_chatModel; }

signals:
    void responseReceived(QString text);
    void isDarkModeChanged(bool mode);

private:
    QNetworkAccessManager *m_networkManager;
    QString m_currentModel;
    ChatModel *m_chatModel;
    bool m_isDarkMode;
};

#endif
