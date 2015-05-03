#ifndef DBUSSERVICE_H
#define DBUSSERVICE_H

#include <QObject>
#include <QVariant>

class DbusService : public QObject
{
    Q_OBJECT
public:
    explicit DbusService(QObject *parent = 0);

signals:

public slots:
    void doSomething(QVariant arg) const;
    void ignore(QVariant arg) const;
};

#endif // DBUSSERVICE_H
