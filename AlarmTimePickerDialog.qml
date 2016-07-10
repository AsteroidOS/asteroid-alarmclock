/*
 * Copyright (C) 2015 - Florent Revest <revestflo@gmail.com>
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

import QtQuick 2.0
import org.nemomobile.time 1.0
import org.asteroid.controls 1.0

Rectangle {
    id: root
    property var alarmObject

    Text {
        text: typeof alarmObject === 'undefined' ? "New Alarm" : "Edit Alarm"
        font.pixelSize: 20
        anchors {
            top: parent.top
            topMargin: 5
            horizontalCenter: parent.horizontalCenter
        }
    }

    TimePicker {
        id: tp
        height: parent.height*0.75
        width: parent.width*0.75
        anchors.centerIn: parent
    }

    // TODO: Find a better component for round screens, for example successive buttons in a circle
    Row {
        anchors {
            bottom: parent.bottom
            right: parent.right
            left: parent.left
        }
        height: 30
        DayButton { id: buttonDayMon; day: 1; checked: false; width: parent.width/7; height: 30 }
        DayButton { id: buttonDayTue; day: 2; checked: false; width: parent.width/7; height: 30 }
        DayButton { id: buttonDayWed; day: 3; checked: false; width: parent.width/7; height: 30 }
        DayButton { id: buttonDayThu; day: 4; checked: false; width: parent.width/7; height: 30 }
        DayButton { id: buttonDayFri; day: 5; checked: false; width: parent.width/7; height: 30 }
        DayButton { id: buttonDaySat; day: 6; checked: false; width: parent.width/7; height: 30 }
        DayButton { id: buttonDaySun; day: 7; checked: false; width: parent.width/7; height: 30 }
    }

    IconButton {
        id: acceptButton
        iconColor: "black"
        iconName: "checkmark-circled"
        anchors.centerIn: parent

        onClicked: {
            if(typeof alarmObject !== 'undefined') alarmObject.deleteAlarm();

            var daysString = "";
            if(buttonDayMon.checked) daysString = "m"
            if(buttonDayTue.checked) daysString = daysString + "t"
            if(buttonDayWed.checked) daysString = daysString + "w"
            if(buttonDayThu.checked) daysString = daysString + "T"
            if(buttonDayFri.checked) daysString = daysString + "f"
            if(buttonDaySat.checked) daysString = daysString + "s"
            if(buttonDaySun.checked) daysString = daysString + "S"

            var alarm = alarmModel.createAlarm();
            alarm.hour = tp.hours;
            alarm.minute = tp.minutes;
            alarm.title = daysString;
            alarm.daysOfWeek = daysString;
            alarm.enabled = true;
            alarm.save();
        }
    }

    WallClock { id: wallClock }

    Component.onCompleted: {
        if (typeof alarmObject === 'undefined') {
            tp.hours   = wallClock.time.getHours();
            tp.minutes = wallClock.time.getMinutes();
        }
        else {
            tp.hours   = alarmObject.hour;
            tp.minutes = alarmObject.minute;

            buttonDayMon.checked = ( alarmObject.daysOfWeek.indexOf("m") >= 0 ? true : false );
            buttonDayTue.checked = ( alarmObject.daysOfWeek.indexOf("t") >= 0 ? true : false );
            buttonDayWed.checked = ( alarmObject.daysOfWeek.indexOf("w") >= 0 ? true : false );
            buttonDayThu.checked = ( alarmObject.daysOfWeek.indexOf("T") >= 0 ? true : false );
            buttonDayFri.checked = ( alarmObject.daysOfWeek.indexOf("f") >= 0 ? true : false );
            buttonDaySat.checked = ( alarmObject.daysOfWeek.indexOf("s") >= 0 ? true : false );
            buttonDaySun.checked = ( alarmObject.daysOfWeek.indexOf("S") >= 0 ? true : false );
        }
    }
}
