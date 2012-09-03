/*************************************************************************************
                AlloCine application for Harmattan
         This application is released under BSD-2 license
                   -------------------------

Copyright (c) 2012, Antoine Vacher, Sahobimaholy Ravelomanana
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

  * Redistributions of source code must retain the above copyright notice,
    this list of conditions and the following disclaimer.
  * Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation and/or
    other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*************************************************************************************/

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

