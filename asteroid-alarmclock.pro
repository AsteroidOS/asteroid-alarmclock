TEMPLATE = app
QT += qml quick
CONFIG += link_pkgconfig
PKGCONFIG += qdeclarative5-boostable

SOURCES +=     main.cpp
RESOURCES +=   resources.qrc
OTHER_FILES += main.qml \
               AlarmTimePickerDialog.qml \
               AlarmDialog.qml \
               TumblerIndexHelper.js \
               clockHelper.js \
               AlarmViewRepeater.qml

TARGET = asteroid-alarmclock
target.path = /usr/bin/

desktop.path = /usr/share/applications
desktop.files = asteroid-alarmclock.desktop

INSTALLS += target desktop
