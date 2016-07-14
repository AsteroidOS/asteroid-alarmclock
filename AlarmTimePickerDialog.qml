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
    property var pop

    Text {
        id: title
        text: typeof alarmObject === 'undefined' ? "New Alarm" : "Edit Alarm"
        height: parent.height*0.15
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }

    Row {
        id: firstDaysRow
        anchors.top: title.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        height: parent.height*0.16
        width: height*3
        DayButton { id: buttonDayMon; day: 1; checked: false; width: parent.width/3; height: firstDaysRow.height }
        DayButton { id: buttonDayTue; day: 2; checked: false; width: parent.width/3; height: firstDaysRow.height }
        DayButton { id: buttonDayWed; day: 3; checked: false; width: parent.width/3; height: firstDaysRow.height }
    }
    Row {
        id: secondDaysRow
        anchors.top: firstDaysRow.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        height: parent.height*0.16
        width: height*4
        DayButton { id: buttonDayThu; day: 4; checked: false; width: parent.width/4; height: secondDaysRow.height }
        DayButton { id: buttonDayFri; day: 5; checked: false; width: parent.width/4; height: secondDaysRow.height }
        DayButton { id: buttonDaySat; day: 6; checked: false; width: parent.width/4; height: secondDaysRow.height }
        DayButton { id: buttonDaySun; day: 7; checked: false; width: parent.width/4; height: secondDaysRow.height }
    }

    Row {
        id: timeSelector
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: secondDaysRow.bottom
        anchors.topMargin: parent.height*0.05
        height: parent.height*0.28

        ListView {
            id: hourLV
            height: parent.height
            width: parent.width/2-1
            clip: true
            spacing: 6
            model: 24
            delegate: Item {
                width: hourLV.width
                height: 30
                Text {
                    text: index
                    anchors.centerIn: parent
                    color: parent.ListView.isCurrentItem ? "black" : "grey"
                    scale: parent.ListView.isCurrentItem ? 1.5 : 1
                    Behavior on scale { NumberAnimation { duration: 200 } }
                    Behavior on color { ColorAnimation { } }
                }
            }
            preferredHighlightBegin: height / 2 - 15
            preferredHighlightEnd: height / 2 + 15
            highlightRangeMode: ListView.StrictlyEnforceRange
        }

        Rectangle {
            width: 1
            height: parent.height*0.8
            color: "grey"
            anchors.verticalCenter: parent.verticalCenter
        }

        ListView {
            id: minuteLV
            height: parent.height
            width: parent.width/2-1
            clip: true
            spacing: 6
            model: 60
            delegate: Item {
                width: minuteLV.width
                height: 30
                Text {
                    text: index
                    anchors.centerIn: parent
                    color: parent.ListView.isCurrentItem ? "black" : "grey"
                    scale: parent.ListView.isCurrentItem ? 1.5 : 1
                    Behavior on scale { NumberAnimation { duration: 200 } }
                    Behavior on color { ColorAnimation { } }
                }
            }
            preferredHighlightBegin: height / 2 - 15
            preferredHighlightEnd: height / 2 + 15
            highlightRangeMode: ListView.StrictlyEnforceRange
        }
    }

    IconButton {
        iconName: "delete"
        visible: typeof alarmObject !== 'undefined'
        anchors.right: parent.horizontalCenter
        anchors.rightMargin: 5
        anchors.bottom: parent.bottom
        onClicked: {
            alarmObject.deleteAlarm()
            root.pop()
        }
    }

    IconButton {
        height: parent.height*0.2
        width: height
        anchors.left: typeof alarmObject !== 'undefined' ? parent.horizontalCenter : null
        anchors.leftMargin: 5
        anchors.horizontalCenter: typeof alarmObject !== 'undefined' ? null : parent.horizontalCenter
        anchors.bottom: parent.bottom

        iconName: typeof alarmObject !== 'undefined' ? "create" : "add-circle"

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
            alarm.hour = hourLV.currentIndex;
            alarm.minute = minuteLV.currentIndex;
            alarm.title = daysString;
            alarm.daysOfWeek = daysString;
            alarm.enabled = true;

            root.pop();
        }
    }

    WallClock { id: wallClock }

    Component.onCompleted: {
        if (typeof alarmObject === 'undefined') {
            hourLV.currentIndex = wallClock.time.getHours();
            minuteLV.currentIndex = wallClock.time.getMinutes();
        }
        else {
            hourLV.currentIndex   = alarmObject.hour;
            minuteLV.currentIndex = alarmObject.minute;

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
