#include <QtWebKit/QWebSettings>
#if QT_VERSION<0x050000
#include <QtGui/QApplication>
#include <QtDeclarative>
#include "qmlapplicationviewer.h"
#include "src/scribblearea.h"
#include "src/qwebviewitem.h"
#endif
#include "src/utility.h"
#include "src/tbnetworkaccessmanagerfactory.h"
#include "src/downloader.h"
#include "src/httpuploader.h"
#include "src/audiorecorder.h"
#include "src/imageuploader.h"

#ifdef Q_WS_SIMULATOR
#include <QtNetwork/QNetworkProxy>
#endif

#ifdef QVIBRA
#include "QVibra/qvibra.h"
#endif

#ifdef Q_OS_HARMATTAN
#include <QtDBus/QDBusConnection>
#include "src/tbclientif.h"
#include "src/harmattanbackgroundprovider.h"
#endif

#ifdef Q_OS_SYMBIAN
#include <QSymbianEvent>
#include <w32std.h>
#include <avkon.hrh>

class SymbianApplication : public QApplication
{
public:
    SymbianApplication(int &argc, char** argv) : QApplication(argc, argv){}

protected:
    bool symbianEventFilter(const QSymbianEvent *event)
    {
        if (event->type() == QSymbianEvent::WindowServerEvent
                && event->windowServerEvent()->Type() == KAknUidValueEndKeyCloseEvent){
            return true;
        }
        return QApplication::symbianEventFilter(event);
    }
};

#endif  // Q_OS_SYMBIAN

#ifdef Q_OS_SAILFISH
#include <sailfishapp.h>
#include <QGuiApplication>
#include "dbusservice.h"
//#include "notification.h"
#endif

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    // Symbian specific
#ifdef Q_OS_SYMBIAN
    QApplication::setAttribute(Qt::AA_CaptureMultimediaKeys);
    QScopedPointer<QApplication> app(new SymbianApplication(argc, argv));
#elif defined(Q_OS_SAILFISH)
    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));
#else
    QScopedPointer<QApplication> app(createApplication(argc, argv));
#endif

#if defined(Q_OS_SYMBIAN)||defined(Q_WS_SIMULATOR)
    QSplashScreen *splash = new QSplashScreen(QPixmap("qml/gfx/splash.jpg"));
    splash->show();
    splash->raise();
#endif

#if QT_VERSION<0x050000
    app->setApplicationName("tbclient");
    app->setOrganizationName("Yeatse");
    app->setApplicationVersion(VER);
#else
    app->setApplicationName("harbour-tbclient");
    app->setOrganizationName("harbour-tbclient");
    app->setApplicationVersion("0.6-3");
#endif

    // Install translator for qt
    QString locale = QLocale::system().name();
    QTranslator qtTranslator;
    if (qtTranslator.load("qt_"+locale, QLibraryInfo::location(QLibraryInfo::TranslationsPath)))
        app->installTranslator(&qtTranslator);
    QTranslator translator;
    if (translator.load(app->applicationName()+"_"+locale, ":/i18n/"))
        app->installTranslator(&translator);

    qmlRegisterUncreatableType<HttpPostField>("com.yeatse.tbclient", 1, 0, "HttpPostField", "Can't touch this");
    qmlRegisterType<HttpPostFieldValue>("com.yeatse.tbclient", 1, 0, "HttpPostFieldValue");
    qmlRegisterType<HttpPostFieldFile>("com.yeatse.tbclient", 1, 0, "HttpPostFieldFile");
    qmlRegisterType<HttpUploader>("com.yeatse.tbclient", 1, 0, "HttpUploader");

    qmlRegisterType<Downloader>("com.yeatse.tbclient", 1, 0, "Downloader");
    qmlRegisterType<AudioRecorder>("com.yeatse.tbclient", 1, 0, "AudioRecorder");
    qmlRegisterType<ImageUploader>("com.yeatse.tbclient", 1, 0, "ImageUploader");
#if QT_VERSION<0x050000
    qmlRegisterType<ScribbleArea>("com.yeatse.tbclient", 1, 0, "ScribbleArea");
    qmlRegisterType<QWebViewItem>("com.yeatse.tbclient", 1, 0, "WebView");
#endif

#ifdef QVIBRA
    qmlRegisterType<QVibra>("com.yeatse.tbclient", 1, 0, "Vibra");
#elif defined(Q_WS_SIMULATOR)
    qmlRegisterType<QObject>("com.yeatse.tbclient", 1, 0, "Vibra");
#endif

#ifdef Q_OS_HARMATTAN
    QWebSettings::globalSettings()->setUserStyleSheetUrl(QUrl::fromLocalFile("/opt/tbclient/qml/js/default_theme.css"));
#else
    QWebSettings::globalSettings()->setUserStyleSheetUrl(QUrl::fromLocalFile("qml/js/default_theme.css"));
#endif

#ifdef Q_OS_SAILFISH
//    qmlRegisterType<Notification>("org.nemomobile.example", 1, 0, "Notification");
    QQuickView *viewer = SailfishApp::createView();
    viewer->engine()->rootContext()->setContextProperty("dbus", new DbusService);
#else
    QmlApplicationViewer *viewer = new QmlApplicationViewer();
    viewer->setAttribute(Qt::WA_OpaquePaintEvent);
    viewer->setAttribute(Qt::WA_NoSystemBackground);
    viewer->viewport()->setAttribute(Qt::WA_OpaquePaintEvent);
    viewer->viewport()->setAttribute(Qt::WA_NoSystemBackground);
#endif

#ifdef Q_OS_HARMATTAN
    new TBClientIf(app.data(), &viewer);
    QDBusConnection bus = QDBusConnection::sessionBus();
    bus.registerService("com.tbclient");
    bus.registerObject("/com/tbclient", app.data());
#endif

    // For fiddler network debugging
#if defined(Q_WS_SIMULATOR)||defined(Q_OS_SAILFISH)
    QNetworkProxy proxy;
    proxy.setType(QNetworkProxy::HttpProxy);
#ifdef Q_OS_SAILFISH
    proxy.setHostName("192.168.1.110");
#else
    proxy.setHostName("localhost");
#endif
    proxy.setPort(8888);
    //QNetworkProxy::setApplicationProxy(proxy);
#endif

    TBNetworkAccessManagerFactory factory;
    viewer->engine()->setNetworkAccessManagerFactory(&factory);

    Utility* utility = Utility::Instance();
    utility->setEngine(viewer->engine());
    viewer->rootContext()->setContextProperty("utility", utility);

#ifdef Q_OS_HARMATTAN
    HarmattanBackgroundProvider provider;
    viewer->engine()->addImageProvider("bgProvider", &provider);
#endif

#if QT_VERSION<0x050000
    // For smoother flicking (only supported by Belle FP2)
    if (utility->qtVersion() > 0x040800)
        QApplication::setStartDragDistance(2);

    // Initialize settings
    if (!utility->getValue("AppVersion","").toString().startsWith("2.1")){
        utility->clearSettings();
        utility->setValue("AppVersion", VER);
    }
#endif

#ifdef Q_OS_SYMBIAN
    viewer->setMainQmlFile(QLatin1String("qml/tbclient/main.qml"));
#elif defined(Q_OS_HARMATTAN)
    viewer->setMainQmlFile(QLatin1String("qml/harmattan/main.qml"));
#elif defined(Q_OS_SAILFISH)
    viewer->setSource(SailfishApp::pathTo("qml/tbclient/main.qml"));
#else
    viewer->setMainQmlFile(QLatin1String("qml/tbclient/main.qml"));
#endif

#ifdef Q_OS_SAILFISH
    viewer->show();
#else
    viewer->showExpanded();
#endif

#if defined(Q_OS_SYMBIAN)||defined(Q_WS_SIMULATOR)
    splash->finish(viewer);
    splash->deleteLater();
#endif

    return app->exec();
}

