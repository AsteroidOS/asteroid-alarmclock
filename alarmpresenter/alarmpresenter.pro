TEMPLATE = app
QT += qml quick
CONFIG += link_pkgconfig
PKGCONFIG += qdeclarative5-boostable

SOURCES +=     main.cpp
RESOURCES +=   resources.qrc
OTHER_FILES += main.qml

TARGET = asteroid-alarmpresenter
target.path = /usr/bin/

systemd.path = /usr/lib/systemd/user/
systemd.files = alarmpresenter.service

dbus.path = /usr/share/dbus-1/services
dbus.files = com.nokia.voland.service

INSTALLS += target dbus systemd
