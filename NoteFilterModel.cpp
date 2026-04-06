#include <NoteFilterModel.h>
NoteFilterModel::NoteFilterModel(QObject *parent) : QSortFilterProxyModel(parent),
    m_condition(NoteFilterModel::Todo)
{}

void NoteFilterModel::setCondition(int value)
{
    m_condition = value;
    emit conditionChanged(value);
    invalidateFilter();
}

bool NoteFilterModel::filterAcceptsRow(int source_row, const QModelIndex &source_parent) const
{
    if (m_condition == NoteFilterModel::All) return true;
    QVariant statusData = sourceModel()->data(sourceModel()->index(source_row,0,QModelIndex()), Note::statusRole);
    if (statusData.userType() != QMetaType::Bool) return false;

    if (statusData.toBool() == m_condition) return true;
    return false;
}

void NoteFilterModel::removeNote(int proxyRow){
    QModelIndex proxyIndex = this->index(proxyRow,0);
    QModelIndex sourceIndex = (this->mapToSource(proxyIndex));
    int realRow = sourceIndex.row();


}
