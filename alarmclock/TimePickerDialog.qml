/*
 * Copyright (C) 2016 - Sylvia van Os <iamsylvie@openmailbox.org>
 *               2015 - Florent Revest <revestflo@gmail.com>
 *               2013 - Santtu Mansikkamaa <santtu.mansikkamaa@nomovok.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.9
import org.nemomobile.time 1.0
import org.nemomobile.configuration 1.0
import org.asteroid.controls 1.0

Item {
    id: root
    property var alarmObject
    property bool isNewAlarm: typeof alarmObject === 'undefined'
    property var pop

    function zeroPadding(x) {
        if (x<10) return "0"+x;
        else      return x;
    }

    ConfigurationValue {
        id: use12H
        key: "/org/asteroidos/settings/use-12h-format"
        defaultValue: false
    }

    Label {
        id: title
        text: qsTr("Time").toUpperCase()
        height: Dims.h(20)
        font.pixelSize: Dims.l(6)
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }

    Row {
        id: timeSelector
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: title.bottom
        height: Dims.h(60)

        property int spinnerWidth: use12H.value ? width/3 : width/2

        CircularSpinner {
            id: hourLV
            height: parent.height
            width: parent.spinnerWidth
            model: use12H.value ? 12 : 24
            showSeparator: true
        }

        CircularSpinner {
            id: minuteLV
            height: parent.height
            width: parent.spinnerWidth
            model: 60
            showSeparator: use12H.value
        }

        Spinner {
            id: amPmLV
            height: parent.height
            width: parent.spinnerWidth
            model: 2
            delegate: SpinnerDelegate { text: index == 0 ? "AM" : "PM" }
        }
    }

    IconButton {
        iconName: !isNewAlarm ? "ios-checkmark-circle-outline" : "ios-arrow-dropright"

        onClicked: {
            if(!isNewAlarm) {
                var alarm = alarmModel.createAlarm();
                var hour = hourLV.currentIndex;
                if(use12H.value)
                    hour += amPmLV.currentIndex*12;
                alarm.hour = hour;
                alarm.minute = minuteLV.currentIndex;
                alarm.title = "";
                alarm.daysOfWeek = alarmObject.daysOfWeek;
                alarm.enabled = true;

                alarmObject.deleteAlarm();

                alarm.save()

                root.pop();
            } else {
                layerStack.push(daysSelectorLayer, {"newAlarmHour": hourLV.currentIndex+12*amPmLV.currentIndex, "newAlarmMinute": minuteLV.currentIndex, "popTimePicker": root.pop})
            }
        }
    }

    WallClock { id: wallClock }

    Component.onCompleted: {
        if (isNewAlarm) {
            var hour = wallClock.time.getHours();
            if(use12H.value) {
                amPmLV.currentIndex = hour / 12;
                hour = hour % 12;
            }
            hourLV.currentIndex = hour;
            minuteLV.currentIndex = wallClock.time.getMinutes();
        }
        else {
            var hour = alarmObject.hour;
            if(use12H.value) {
                amPmLV.currentIndex = hour / 12;
                hour = hour % 12;
            }
            hourLV.currentIndex   = hour;
            minuteLV.currentIndex = alarmObject.minute;
        }
    }
}
