#include <shareuiinterface.h>
#include <MDataUri>
#include "sharestring.h"

ShareString::ShareString(QObject *parent) :
    QObject(parent)
{
}
void ShareString::share(const QString& string)
{


    QStringList items;

    ShareUiInterface shareIf("com.nokia.ShareUi");
    MDataUri mdata;
    mdata.setTextData(string, QLatin1String("us-ascii"));
    mdata.setMimeType("text-x-url");
    items << mdata.textData();
     if (shareIf.isValid())
    {
        shareIf.share(items);
    }
    else
        qDebug() << "Invalid ShareUi";
}
