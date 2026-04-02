#ifndef NOTE_H
#define NOTE_H

#include <QAbstractListModel>
#include <QDir>
#include <QFile>
#include <QHash>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QList>
#include <QObject>
#include <QStandardPaths>
#include <QString>

struct NoteType {
  QString content;
  bool status;
};

class Note : public QAbstractListModel {
  Q_OBJECT
public:
  explicit Note(QObject *parent = nullptr);

  enum RoleName { contentRole = Qt::UserRole + 1, statusRole };

  int rowCount(const QModelIndex &parent = QModelIndex()) const override;
  QHash<int, QByteArray> roleNames() const override;
  QVariant data(const QModelIndex &index,
                int role = Qt::DisplayRole) const override;

  Q_INVOKABLE void addNote();
  Q_INVOKABLE void removeNote(int index);
  Q_INVOKABLE void setContent(int index, QString text);
  Q_INVOKABLE void setStatus(int index, bool status);

private:
  QList<NoteType> m_note;
  Q_INVOKABLE void saveNote();
  Q_INVOKABLE void loadNote();
};

#endif // NOTE_H
