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
    property int newAlarmHour: 0
    property int newAlarmMinute: 0
    property var pop
    property var popTimePicker

    Label {
        id: title
        text: qsTr("Repetition").toUpperCase()
        height: Dims.h(20)
        font.pixelSize: Dims.l(6)
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }

    Row {
        id: firstDaysRow
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -Dims.h(10)
        anchors.horizontalCenter: parent.horizontalCenter
        height: Dims.h(20)
        width: Dims.w(80)
        DayButton { id: buttonDayMon; day: 1; checked: false; width: firstDaysRow.height; height: firstDaysRow.height }
        DayButton { id: buttonDayTue; day: 2; checked: false; width: firstDaysRow.height; height: firstDaysRow.height }
        DayButton { id: buttonDayWed; day: 3; checked: false; width: firstDaysRow.height; height: firstDaysRow.height }
        DayButton { id: buttonDayThu; day: 4; checked: false; width: secondDaysRow.height; height: secondDaysRow.height }
    }
    Row {
        id: secondDaysRow
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: Dims.h(10)
        anchors.horizontalCenter: parent.horizontalCenter
        height: Dims.h(20)
        width: Dims.w(60)
        DayButton { id: buttonDayFri; day: 5; checked: false; width: secondDaysRow.height; height: secondDaysRow.height }
        DayButton { id: buttonDaySat; day: 6; checked: false; width: secondDaysRow.height; height: secondDaysRow.height }
        DayButton { id: buttonDaySun; day: 7; checked: false; width: secondDaysRow.height; height: secondDaysRow.height }
    }

    IconButton {
        iconName: !isNewAlarm ? "ios-checkmark-circle-outline" : "ios-add-circle-outline"

        onClicked: {
            var daysString = "";
            if(buttonDayMon.checked) daysString = "m"
            if(buttonDayTue.checked) daysString = daysString + "t"
            if(buttonDayWed.checked) daysString = daysString + "w"
            if(buttonDayThu.checked) daysString = daysString + "T"
            if(buttonDayFri.checked) daysString = daysString + "f"
            if(buttonDaySat.checked) daysString = daysString + "s"
            if(buttonDaySun.checked) daysString = daysString + "S"

            var alarm = alarmModel.createAlarm();
            if(!isNewAlarm) {
                alarm.hour = alarmObject.hour;
                alarm.minute = alarmObject.minute;
                alarmObject.deleteAlarm();
            } else {
                alarm.hour = newAlarmHour;
                alarm.minute = newAlarmMinute;
            }

            alarm.title = "";
            alarm.daysOfWeek = daysString;
            alarm.enabled = true;

            alarm.save()

            if(isNewAlarm) root.popTimePicker();
            root.pop();
        }
    }

    Component.onCompleted: {
        if (!isNewAlarm) {
            buttonDayMon.checked = alarmObject.daysOfWeek.indexOf("m") >= 0;
            buttonDayTue.checked = alarmObject.daysOfWeek.indexOf("t") >= 0;
            buttonDayWed.checked = alarmObject.daysOfWeek.indexOf("w") >= 0;
            buttonDayThu.checked = alarmObject.daysOfWeek.indexOf("T") >= 0;
            buttonDayFri.checked = alarmObject.daysOfWeek.indexOf("f") >= 0;
            buttonDaySat.checked = alarmObject.daysOfWeek.indexOf("s") >= 0;
            buttonDaySun.checked = alarmObject.daysOfWeek.indexOf("S") >= 0;
        }
    }
}
