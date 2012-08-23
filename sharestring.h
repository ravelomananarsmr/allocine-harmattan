#ifndef SHARESTRING_H
#define SHARESTRING_H

#include <QObject>

class ShareString : public QObject
{
    Q_OBJECT
public:
    explicit ShareString(QObject *parent = 0);
    Q_INVOKABLE void share(const QString& string);
signals:
    
public slots:

    
};

#endif // SHARESTRING_H
