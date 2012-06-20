#include <QTranslator>
#include <QLocale>
#include <QtGui/QApplication>
#include "qmlapplicationviewer.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));
    QScopedPointer<QmlApplicationViewer> viewer(QmlApplicationViewer::create());

    QString locale = QLocale::system().name();
    QTranslator translator;

    // fall back to using English translation, if one specific to the current
    // setting of the device is not available.
    if (!(translator.load("tr_"+locale, ":/")))
        translator.load("tr_en", ":/");

    app->installTranslator(&translator);

    viewer->setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer->setMainQmlFile(QLatin1String("qml/AlloCine/main.qml"));
    viewer->showExpanded();

    return app->exec();
}
