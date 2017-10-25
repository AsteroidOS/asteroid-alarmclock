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

    Text {
        id: title
        color: "white"
        text: qsTr("Time").toUpperCase()
        height: Dims.h(20)
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

        CircularSpinner {
            id: hourLV
            height: parent.height
            width: parent.width/2
            model: 24
            showSeparator: true
        }

        CircularSpinner {
            id: minuteLV
            height: parent.height
            width: parent.width/2
            model: 60
        }
    }

    IconButton {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Dims.iconButtonMargin

        iconName: !isNewAlarm ? "ios-checkmark-circle-outline" : "ios-arrow-dropright"
        iconColor: "white"

        onClicked: {
            if(!isNewAlarm) {
                var alarm = alarmModel.createAlarm();
                alarm.hour = hourLV.currentIndex;
                alarm.minute = minuteLV.currentIndex;
                alarm.title = "";
                alarm.daysOfWeek = alarmObject.daysOfWeek;
                alarm.enabled = true;

                alarmObject.deleteAlarm();

                alarm.save()

                root.pop();
            } else {
                layerStack.push(daysSelectorLayer, {"newAlarmHour": hourLV.currentIndex, "newAlarmMinute": minuteLV.currentIndex, "popTimePicker": root.pop})
            }
        }
    }

    WallClock { id: wallClock }

    Component.onCompleted: {
        if (isNewAlarm) {
            hourLV.currentIndex = wallClock.time.getHours();
            minuteLV.currentIndex = wallClock.time.getMinutes();
        }
        else {
            hourLV.currentIndex   = alarmObject.hour;
            minuteLV.currentIndex = alarmObject.minute;
        }
    }
}
