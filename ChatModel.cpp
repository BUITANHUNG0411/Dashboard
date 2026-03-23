#include "ChatModel.h"

ChatModel::ChatModel(QObject *parent) : QAbstractListModel(parent)
{
}

int ChatModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid()) return 0;
    return m_messages.count();
}

QVariant ChatModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_messages.count()) return QVariant();

    const ChatMessage &message = m_messages[index.row()];
    if (role == AuthorRole) return message.author;
    if (role == TextRole) return message.text;

    return QVariant();
}

QHash<int, QByteArray> ChatModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[AuthorRole] = "author";
    roles[TextRole] = "text";
    return roles;
}

void ChatModel::appendMessage(const QString &author, const QString &text)
{
    beginInsertRows(QModelIndex(), m_messages.count(), m_messages.count());
    m_messages.append({author, text});
    endInsertRows();
}

void ChatModel::clear()
{
    beginResetModel();
    m_messages.clear();
    endResetModel();
}
