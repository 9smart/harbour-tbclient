#include "dbusservice.h"
#include <QtDBus>
#include <QDebug>

DbusService::DbusService(QObject *parent) :
    QObject(parent)
{
    QDBusConnection bus = QDBusConnection::sessionBus();
    if (!bus.registerService("org.tbclient")) {
        qDebug() << bus.lastError().message();
    }

    bus.registerObject("/service", this, QDBusConnection::ExportAllSlots);
}

void DbusService::ignore(QVariant arg) const
{
    qDebug()<<arg;
}

void DbusService::doSomething(QVariant arg) const
{
    qDebug()<<arg;
}
