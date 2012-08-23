#include <shareuiinterface.h>
#include "sharestring.h"

ShareString::ShareString(QObject *parent) :
    QObject(parent)
{
}
void ShareString::share(const QString& string)
{


    QStringList items;
    items << string;

    ShareUiInterface shareIf("com.nokia.ShareUi");

    if (shareIf.isValid())
    {
        shareIf.share(items);
    }
    else
        qDebug() << "Invalid ShareUi";
}
