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
    property var pop

    function zeroPadding(x) {
        if (x<10) return "0"+x;
        else      return x;
    }

    Text {
        id: title
        color: "white"
        text: typeof alarmObject === 'undefined' ? qsTr("New Alarm").toUpperCase() : qsTr("Edit Alarm").toUpperCase()
        height: Dims.h(15)
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
        height: Dims.h(16)
        width: Dims.w(48)
        DayButton { id: buttonDayMon; day: 1; checked: false; width: firstDaysRow.height; height: firstDaysRow.height }
        DayButton { id: buttonDayTue; day: 2; checked: false; width: firstDaysRow.height; height: firstDaysRow.height }
        DayButton { id: buttonDayWed; day: 3; checked: false; width: firstDaysRow.height; height: firstDaysRow.height }
    }
    Row {
        id: secondDaysRow
        anchors.top: firstDaysRow.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        height: Dims.h(16)
        width: Dims.w(64)
        DayButton { id: buttonDayThu; day: 4; checked: false; width: secondDaysRow.height; height: secondDaysRow.height }
        DayButton { id: buttonDayFri; day: 5; checked: false; width: secondDaysRow.height; height: secondDaysRow.height }
        DayButton { id: buttonDaySat; day: 6; checked: false; width: secondDaysRow.height; height: secondDaysRow.height }
        DayButton { id: buttonDaySun; day: 7; checked: false; width: secondDaysRow.height; height: secondDaysRow.height }
    }

    Row {
        id: timeSelector
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: secondDaysRow.bottom
        anchors.topMargin: Dims.h(5)
        height: Dims.h(28)

        ListView {
            id: hourLV
            height: parent.height
            width: Dims.w(50)
            clip: true
            spacing: Dims.h(2)
            model: 24
            delegate: Item {
                width: hourLV.width
                height: Dims.h(10)
                Text {
                    text: index
                    anchors.centerIn: parent
                    color: parent.ListView.isCurrentItem ? "white" : "lightgrey"
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
            color: "white"
            anchors.verticalCenter: parent.verticalCenter
        }

        ListView {
            id: minuteLV
            height: parent.height
            width: Dims.w(50)
            clip: true
            spacing: Dims.h(2)
            model: 60
            delegate: Item {
                width: minuteLV.width
                height: Dims.h(10)
                Text {
                    text: zeroPadding(index)
                    anchors.centerIn: parent
                    color: parent.ListView.isCurrentItem ? "white" : "lightgrey"
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
        iconName: "ios-trash-circle"
        iconColor: "white"
        pressedIconColor: "lightgrey"
        visible: typeof alarmObject !== 'undefined'
        anchors.right: parent.horizontalCenter
        anchors.rightMargin: Dims.w(2)
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Dims.h(3)
        onClicked: {
            alarmObject.deleteAlarm()
            root.pop()
        }
    }

    IconButton {
        anchors.left: typeof alarmObject !== 'undefined' ? parent.horizontalCenter : undefined
        anchors.leftMargin: Dims.w(2)
        anchors.horizontalCenter: typeof alarmObject !== 'undefined' ? undefined : parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Dims.h(3)

        iconName: typeof alarmObject !== 'undefined' ? "ios-checkmark-circle-outline" : "ios-add-circle-outline"
        iconColor: "white"
        pressedIconColor: "lightgrey"

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

            alarm.save()

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
