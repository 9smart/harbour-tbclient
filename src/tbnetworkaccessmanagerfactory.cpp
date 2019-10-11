#include "tbnetworkaccessmanagerfactory.h"
#include "utility.h"

#define PORTRAIT_PREFIX "https://tb.himg.baidu.com/sys/portraitn/item/"
#define IMG_PREFIX "https://imgsrc.baidu.com/forum/pic/item/"
#define IMG_UNSUPPORTED_HOST "https://c.tieba.baidu.com/c/p/img"
#define HOST_PREFIX "https://c.tieba.baidu.com/"

TBNetworkAccessManagerFactory::TBNetworkAccessManagerFactory() :
#if(QT_VERSION<0x050000)
    QDeclarativeNetworkAccessManagerFactory()
#else
    QQmlNetworkAccessManagerFactory()
#endif
{
}

QNetworkAccessManager* TBNetworkAccessManagerFactory::create(QObject *parent)
{
    QMutexLocker lock(&mutex);
    Q_UNUSED(lock);
    QNetworkAccessManager* manager = new TBNetworkAccessManager(parent);

#ifdef Q_OS_SYMBIAN
    bool useDiskCache = Utility::Instance()->qtVersion() >= 0x040800;
#else
    bool useDiskCache = true;
#endif
    if (useDiskCache){
        QNetworkDiskCache* diskCache = new QNetworkDiskCache(parent);
#if QT_VERSION<0x050000
        QString dataPath = QDesktopServices::storageLocation(QDesktopServices::CacheLocation);
#else
        QString dataPath = QStandardPaths::standardLocations(QStandardPaths::CacheLocation).at(0);
#endif
        QDir dir(dataPath);
        if (!dir.exists()) dir.mkpath(dir.absolutePath());

        diskCache->setCacheDirectory(dataPath);
        diskCache->setMaximumCacheSize(3*1024*1024);
        manager->setCache(diskCache);
    }

    QNetworkCookieJar* cookieJar = TBNetworkCookieJar::GetInstance();
    manager->setCookieJar(cookieJar);
    cookieJar->setParent(0);

    return manager;
}

TBNetworkAccessManager::TBNetworkAccessManager(QObject *parent) :
    QNetworkAccessManager(parent)
{
}

QNetworkReply *TBNetworkAccessManager::createRequest(Operation op, const QNetworkRequest &request, QIODevice *outgoingData)
{
    QNetworkRequest req(request);
    QSslConfiguration config;

    config.setPeerVerifyMode(QSslSocket::VerifyNone);
#if(QT_VERSION>=0x050000)
    config.setProtocol(QSsl::TlsV1_0);
#else
    config.setProtocol(QSsl::TlsV1);
#endif
    req.setSslConfiguration(config);

    // set user-agent
    if (op == PostOperation){
        req.setRawHeader("User-Agent", "IDP");
    } else {
        req.setRawHeader("User-Agent", "Mozilla/5.0 (iPhone; CPU iPhone OS 7_0_4 like Mac OS X) AppleWebKit/537.51.1 (KHTML, like Gecko) Version/7.0 Mobile/11B554a Safari/9537.53");
    }
#if(QT_VERSION>=0x050000)
    QByteArray urldata = req.url().toString().toLatin1();
    // convert unsupported image url
    QUrl temp_url = req.url();
    temp_url.setQuery("src");
    if (urldata.startsWith(IMG_UNSUPPORTED_HOST) && temp_url.hasQuery()){
        urldata = temp_url.query(QUrl::EncodeUnicode).toLatin1();
        req.setUrl(QUrl::fromEncoded(urldata));
    }
#else
    QByteArray urldata = req.url().toString().toAscii();
    // convert unsupported image url
    if (urldata.startsWith(IMG_UNSUPPORTED_HOST) && req.url().hasEncodedQueryItem("src")){
        urldata = req.url().encodedQueryItemValue("src");
        req.setUrl(QUrl::fromEncoded(urldata));
    }
#endif
    // set cache control
    if (urldata.startsWith(PORTRAIT_PREFIX) || urldata.startsWith(IMG_PREFIX)){
        req.setAttribute(QNetworkRequest::CacheLoadControlAttribute, QNetworkRequest::PreferCache);
    } else {
        req.setAttribute(QNetworkRequest::CacheSaveControlAttribute, false);
    }
    QNetworkReply *reply = QNetworkAccessManager::createRequest(op, req, outgoingData);
    return reply;
}

TBNetworkCookieJar::TBNetworkCookieJar(QObject *parent) :
    QNetworkCookieJar(parent)
{
    keepAliveCookie = QNetworkCookie("ka", "open");
    load();
}

TBNetworkCookieJar::~TBNetworkCookieJar()
{
    save();
}

TBNetworkCookieJar* TBNetworkCookieJar::GetInstance()
{
    static TBNetworkCookieJar cookieJar;
    return &cookieJar;
}

void TBNetworkCookieJar::clearCookies()
{
    QList<QNetworkCookie> emptyList;
    setAllCookies(emptyList);
}

QList<QNetworkCookie> TBNetworkCookieJar::cookiesForUrl(const QUrl &url) const
{
    QMutexLocker lock(&mutex);
    Q_UNUSED(lock);
    QList<QNetworkCookie> cookies = QNetworkCookieJar::cookiesForUrl(url);
    if (url.toEncoded().startsWith(HOST_PREFIX) && !cookies.contains(keepAliveCookie))
        cookies.prepend(keepAliveCookie);
    return cookies;
}

bool TBNetworkCookieJar::setCookiesFromUrl(const QList<QNetworkCookie> &cookieList, const QUrl &url)
{
    QMutexLocker lock(&mutex);
    Q_UNUSED(lock);
    return QNetworkCookieJar::setCookiesFromUrl(cookieList, url);
}

void TBNetworkCookieJar::save()
{
    QMutexLocker lock(&mutex);
    Q_UNUSED(lock);
    QList<QNetworkCookie> list = allCookies();
    QByteArray data;
    foreach (QNetworkCookie cookie, list) {
        if (!cookie.isSessionCookie()){
            QString domain = cookie.domain();
            if (domain.endsWith("tieba.baidu.com")||domain.endsWith("wappass.baidu.com")||domain == ".baidu.com"){
                data.append(cookie.toRawForm());
                data.append("\n");
            }
        }
    }
    Utility::Instance()->setValue("cookies", data);
}

void TBNetworkCookieJar::load()
{
    QMutexLocker lock(&mutex);
    Q_UNUSED(lock);
    QByteArray data = Utility::Instance()->getValue("cookies").toByteArray();
    setAllCookies(QNetworkCookie::parseCookies(data));
}
