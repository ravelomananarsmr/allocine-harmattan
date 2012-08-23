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
