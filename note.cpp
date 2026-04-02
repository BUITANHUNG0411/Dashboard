#include "note.h"

Note::Note(QObject *parent) : QAbstractListModel(parent)
{
  loadNote();
}

int Note::rowCount(const QModelIndex &parent) const { return m_note.length(); }

QHash<int, QByteArray> Note::roleNames() const {
  QHash<int, QByteArray> role;
  role[contentRole] = "content";
  role[statusRole] = "status";
  return role;
}

QVariant Note::data(const QModelIndex &index, int role) const {
  if (!index.isValid() || index.row() >= m_note.length())
    return QVariant();
  switch (role) {
  case contentRole:
    return m_note[index.row()].content;
  case statusRole:
    return m_note[index.row()].status;
  default:
    return QVariant();
  }
}

void Note::addNote() {
  beginInsertRows(QModelIndex(), m_note.length(), m_note.length());
  m_note.append({" ", false});
  endInsertRows();
  saveNote();
}

void Note::removeNote(int index) {
  beginRemoveRows(QModelIndex(), index, index);
  m_note.remove(index);
  endRemoveRows();
  saveNote();
}

void Note::setContent(int index, QString text) {
  m_note[index].content = text;
  emit dataChanged(createIndex(index, 0), createIndex(index, 0), {contentRole});
  saveNote();
}

void Note::setStatus(int index, bool status) {
  m_note[index].status = status;
  emit dataChanged(createIndex(index, 0), createIndex(index, 0), {statusRole});
  saveNote();
}

void Note::saveNote() {
  //create file json saved
  QString folderPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
  QDir dir(folderPath);
  if (!dir.exists())
    dir.mkpath(".");
  QFile jsonFile(folderPath + "/notes.json");

  //transfer to json type
  QJsonArray jsonArray;
  for (const auto &note : m_note){
    QJsonObject obj;
    obj["content"] = note.content;
    obj["status"] = note.status;
    jsonArray.append(obj);
  }

  //package data to file json
  QJsonDocument jsonDoc(jsonArray);
  jsonFile.open(QIODevice::WriteOnly);
  if (jsonFile.isOpen()){
    jsonFile.write(jsonDoc.toJson());
    jsonFile.close();
  }
}

void Note::loadNote() {
  QString folderPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
  QString filePath = folderPath+"/notes.json";
  QFile file(filePath);
  if (!file.exists()) return;

  file.open(QIODevice::ReadOnly);
  QByteArray jsonData = file.readAll();
  QJsonParseError parseError;
  QJsonDocument jsonDoc = QJsonDocument::fromJson(jsonData, &parseError);
  if (parseError.error != QJsonParseError::NoError){
    qDebug() << "Error while reading data from history notes file" << "\n";
    return;
  }

  if (jsonDoc.isArray()){
    QJsonArray arr = jsonDoc.array();
    for (auto const member : arr){
      if (!member.isObject()) continue;
      QJsonObject obj = member.toObject();
      m_note.append( {obj["content"].toString(), obj["status"].toBool()} );
    }
  }

  file.close();

}
