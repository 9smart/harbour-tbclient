#system(qdbusxml2cpp org.freedesktop.Notifications.xml -p notificationmanagerproxy -c NotificationManagerProxy -i notification.h)

QT += dbus

SOURCES += \
    $$PWD/notification.cpp \
    $$PWD/notificationmanagerproxy.cpp

HEADERS += \
    $$PWD/notification.h \
    $$PWD/notificationmanagerproxy.h

INCLUDEPATH += $$PWD

target.path = $$[QT_INSTALL_LIBS]
pkgconfig.files = $$TARGET.pc
pkgconfig.path = $$target.path/pkgconfig
headers.files = notification.h
headers.path = /usr/include/nemonotifications-qt5

QMAKE_PKGCONFIG_NAME = lib$$TARGET
QMAKE_PKGCONFIG_DESCRIPTION = Convenience library or sending notifications
QMAKE_PKGCONFIG_LIBDIR = $$target.path
QMAKE_PKGCONFIG_INCDIR = $$headers.path
QMAKE_PKGCONFIG_DESTDIR = pkgconfig

INSTALLS += target headers pkgconfig
