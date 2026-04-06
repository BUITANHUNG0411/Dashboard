#ifndef NOTEFILTERMODEL_H
#define NOTEFILTERMODEL_H

#include <note.h>
#include <QObject>
#include <QSortFilterProxyModel>
#include <QVariant>
#include <QMetaType>
#include <QModelIndex>

class NoteFilterModel : public QSortFilterProxyModel
{
    Q_OBJECT
    Q_PROPERTY(int condition READ getCondition WRITE setCondition NOTIFY conditionChanged FINAL)
public:
    explicit NoteFilterModel(QObject *parent = nullptr);
    enum statusRole{
        Todo = 0,
        Done,
        All
    };

    Q_INVOKABLE int getCondition(){ return m_condition; };
    Q_INVOKABLE void setCondition(int value);
    Q_INVOKABLE void removeNote(int proxyRow);

protected:
    Q_INVOKABLE bool filterAcceptsRow(int source_row, const QModelIndex &source_parent) const override;

signals:
    void conditionChanged(int value);

private:
    int m_condition;

};

#endif // NOTEFILTERMODEL_H
