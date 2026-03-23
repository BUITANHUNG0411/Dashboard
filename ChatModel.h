#ifndef CHATMODEL_H
#define CHATMODEL_H

#include <QAbstractListModel>
#include <QString>
#include <QVector>

struct ChatMessage {
    QString author;
    QString text;
};

class ChatModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum ChatRoles { AuthorRole = Qt::UserRole + 1, TextRole };

    explicit ChatModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    void appendMessage(const QString &author, const QString &text);
    void clear();
    const QVector<ChatMessage>& messages() const { return m_messages; }

private:
    QVector<ChatMessage> m_messages;
};

#endif
