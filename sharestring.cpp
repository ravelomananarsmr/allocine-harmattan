
#include<qglobal.h>
#include "sharestring.h"
#ifndef QT_SIMULATOR
#include <MDataUri>
#include <shareuiinterface.h>
#endif


ShareString::ShareString(QObject *parent) :
   QObject(parent)
{
}
QString ShareString::text()const
{
    return _text;
}
QString ShareString::description()const
{
    return _description;
}
QString ShareString::mimeType()const
{
    return _mimeType;
}
QString ShareString::title()const
{
    return _title;
}
void ShareString::setText(const QString text)
{
    _text=text;
}

void ShareString::setDescription(const QString description)
{
    _description=description;
}

void ShareString::setMimeType(const QString mimeType)
{
    _mimeType=mimeType;
}

void ShareString::setTitle(const QString title)
{
    _title=title;
}

void ShareString::share()
{

#ifndef QT_SIMULATOR

   QStringList items;

   ShareUiInterface shareIf("com.nokia.ShareUi");
   MDataUri mdata;
   mdata.setTextData(text());
   mdata.setMimeType(mimeType());
   mdata.setAttribute ("title", title());
    mdata.setAttribute ("description", description());

   if (mdata.isValid() == false) {

       qCritical() << "Invalid URI";

   }

   items << mdata.toString();

    if (shareIf.isValid())
   {
       shareIf.share(items);
   }
   else
       qDebug() << "Invalid ShareUi";
#endif
}

