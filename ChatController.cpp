#include "ChatController.h"
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QUrl>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QByteArray>
#include <QFile>
#include <QTextStream>
#include <QStandardPaths>
#include <QDir>

ChatController::ChatController(QObject *parent)
    : QObject(parent), 
      m_networkManager(new QNetworkAccessManager(this)), 
      m_currentModel("gemini-2.5-flash"),
      m_chatModel(new ChatModel(this)),
      m_isDarkMode(false)
{
}

void ChatController::setModel(QString modelName)
{
    if (modelName == "Gemini 2.5 Flash") m_currentModel = "gemini-2.5-flash";
    else if (modelName == "Gemini 1.5 Pro") m_currentModel = "gemini-1.5-pro";
    else if (modelName == "Gemini 1.0 Pro") m_currentModel = "gemini-1.0-pro";
}

void ChatController::exportLog()
{
    QString path = QStandardPaths::writableLocation(QStandardPaths::DesktopLocation) + "/chat_log.txt";
    QFile file(path);
    if (file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        QTextStream out(&file);
        const auto &msgs = m_chatModel->messages();
        for (const auto &m : msgs) {
            out << m.author << ": " << m.text << "\n\n";
        }
        file.close();
    }
}

void ChatController::clearChat()
{
    m_chatModel->clear();
}

void ChatController::sendMessage(QString text)
{
    if (text.isEmpty()) return;
    
    m_chatModel->appendMessage("You", text);

    QString urlString = "https://generativelanguage.googleapis.com/v1beta/models/" + m_currentModel + ":generateContent?key=AIzaSyBvlK0IbYno7WkoV-i-JKi7p1mBv0c3wtM";
    QUrl url(urlString);
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QJsonObject textPart;
    textPart["text"] = text;
    QJsonArray partsArray;
    partsArray.append(textPart);
    QJsonObject contentObj;
    contentObj["parts"] = partsArray;
    QJsonArray contentsArray;
    contentsArray.append(contentObj);
    QJsonObject json;
    json["contents"] = contentsArray;
    
    QJsonDocument doc(json);
    QByteArray data = doc.toJson();

    QNetworkReply *reply = m_networkManager->post(request, data);

    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        if (reply->error() == QNetworkReply::NoError) {
            QByteArray responseData = reply->readAll();
            QJsonDocument responseDoc = QJsonDocument::fromJson(responseData);
            QJsonObject responseObj = responseDoc.object();
            QJsonArray candidates = responseObj["candidates"].toArray();
            if (!candidates.isEmpty()) {
                QString replyText = candidates.first().toObject()["content"].toObject()["parts"].toArray().first().toObject()["text"].toString();
                m_chatModel->appendMessage("Gemini", replyText);
                emit responseReceived(replyText);
            }
        } else {
            m_chatModel->appendMessage("Error", reply->errorString());
        }
        reply->deleteLater();
    });
}
