TEMPLATE = app
QT += qml quick
CONFIG += link_pkgconfig
PKGCONFIG += qdeclarative5-boostable

SOURCES +=     main.cpp
RESOURCES +=   resources.qrc
OTHER_FILES += main.qml \
               DayButton.qml \
               AlarmTimePickerDialog.qml \
               AlarmViewRepeater.qml

lupdate_only{
    SOURCES = main.qml \
              DayButton.qml \
              AlarmTimePickerDialog.qml \
              AlarmViewRepeater.qml \
              i18n/asteroid-alarmclock.desktop.h
}

# Needed for lupdate
TRANSLATIONS = i18n/asteroid-alarmclock.ca.ts \
               i18n/asteroid-alarmclock.ckb.ts \
               i18n/asteroid-alarmclock.cs.ts \
               i18n/asteroid-alarmclock.de_DE.ts \
               i18n/asteroid-alarmclock.el.ts \
               i18n/asteroid-alarmclock.es.ts \
               i18n/asteroid-alarmclock.fa.ts \
               i18n/asteroid-alarmclock.fr.ts \
               i18n/asteroid-alarmclock.hu.ts \
               i18n/asteroid-alarmclock.it.ts \
               i18n/asteroid-alarmclock.kab.ts \
               i18n/asteroid-alarmclock.ko.ts \
               i18n/asteroid-alarmclock.nl_NL.ts \
               i18n/asteroid-alarmclock.pl.ts \
               i18n/asteroid-alarmclock.pt_BR.ts \
               i18n/asteroid-alarmclock.ru.ts \
               i18n/asteroid-alarmclock.sk.ts \
               i18n/asteroid-alarmclock.sv.ts \
               i18n/asteroid-alarmclock.ta.ts \
               i18n/asteroid-alarmclock.tr.ts \
               i18n/asteroid-alarmclock.uk.ts \
               i18n/asteroid-alarmclock.zh_CN.ts \
               i18n/asteroid-alarmclock.zh_Hans.ts

TARGET = asteroid-alarmclock
target.path = /usr/bin/

desktop.commands = bash $$PWD/i18n/generate-desktop.sh $$PWD asteroid-alarmclock.desktop
desktop.path = /usr/share/applications
desktop.files = $$OUT_PWD/asteroid-alarmclock.desktop
desktop.CONFIG = no_check_exist

INSTALLS += target desktop
