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

#ifndef SHARESTRING_H
#define SHARESTRING_H

#include <QObject>

class ShareString : public QObject
{
    Q_OBJECT
public:
    explicit ShareString(QObject *parent = 0);
    Q_INVOKABLE void share();

    Q_PROPERTY(QString text READ text WRITE setText)
    Q_PROPERTY(QString description READ description WRITE setDescription)
    Q_PROPERTY(QString mimeType READ mimeType WRITE setMimeType)
    Q_PROPERTY(QString title READ title WRITE setTitle)


    QString text()const;
    QString description()const;
    QString mimeType()const;
    QString title()const;
    void setText(const QString);
    void setDescription(const QString);
    void setMimeType(const QString);
    void setTitle(const QString);

signals:
    
public slots:
private:
    QString _text;
    QString _description;
    QString _mimeType;
    QString _title;

};

#endif // SHARESTRING_H
