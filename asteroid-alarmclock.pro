TEMPLATE = app
QT += qml quick
CONFIG += link_pkgconfig
PKGCONFIG += qdeclarative5-boostable

SOURCES +=     main.cpp
RESOURCES +=   resources.qrc
OTHER_FILES += main.qml \
               DayButton.qml \
               AlarmTimePickerDialog.qml \
               AlarmDialog.qml \
               AlarmViewRepeater.qml

lupdate_only{
    SOURCES = main.qml \
              DayButton.qml \
              AlarmTimePickerDialog.qml \
              AlarmDialog.qml \
              AlarmViewRepeater.qml
}

TARGET = asteroid-alarmclock
target.path = /usr/bin/

desktop.path = /usr/share/applications
desktop.files = asteroid-alarmclock.desktop

systemd.path = /usr/lib/systemd/user/
systemd.files = open-alarm.service

dbus.path = /usr/share/dbus-1/services
dbus.files = com.nokia.voland.service

INSTALLS += target desktop dbus systemd
