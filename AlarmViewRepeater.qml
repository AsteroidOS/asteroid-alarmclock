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

import QtQuick 2.0
import org.asteroid.controls 1.0

Repeater {
    signal editClicked (var alarm)

    function twoDigits(x) {
        if (x<10) return "0"+x;
        else      return x;
    }

    function parseAlarmTitle(title) {
        if      (title === "")        return qsTr("Once");
        else if (title === "mtwTf")   return qsTr("Weekdays");
        else if (title === "sS")      return qsTr("Weekends");
        else if (title === "mtwTfsS") return qsTr("Every day");
        else {
            var returnString = "";
            if (title.indexOf("m") >= 0) returnString = Qt.locale().dayName(1, Locale.ShortFormat) + ", ";
            if (title.indexOf("t") >= 0) returnString = returnString + Qt.locale().dayName(2, Locale.ShortFormat) + ", ";
            if (title.indexOf("w") >= 0) returnString = returnString + Qt.locale().dayName(3, Locale.ShortFormat) + ", ";
            if (title.indexOf("T") >= 0) returnString = returnString + Qt.locale().dayName(4, Locale.ShortFormat) + ", ";
            if (title.indexOf("f") >= 0) returnString = returnString + Qt.locale().dayName(5, Locale.ShortFormat) + ", ";
            if (title.indexOf("s") >= 0) returnString = returnString + Qt.locale().dayName(6, Locale.ShortFormat) + ", ";
            if (title.indexOf("S") >= 0) returnString = returnString + Qt.locale().dayName(7, Locale.ShortFormat);
            return returnString.replace(/, $/, "");
        }
    }

    MouseArea {
        id: editByClick
        height: 60
        width: app.width
        onClicked: editClicked(alarm);

        Text {
            id: timeField
            text: twoDigits(alarm.hour) + " : " + twoDigits(alarm.minute);
            font.pixelSize: parent.height*0.45
            color: enableSwitch.checked ? "white" : "lightgrey"
            anchors {
                bottom: parent.verticalCenter
                left: parent.left
                leftMargin: parent.height/2
            }
        }

        Text {
            id: daysField
            text: parseAlarmTitle(alarm.title);
            color: enableSwitch.checked ? "white" : "lightgrey"
            font.pixelSize: parent.height*0.25
            anchors {
                top: parent.verticalCenter
                left: parent.left
                leftMargin: parent.height/2
            }
        }

        Switch {
            id: enableSwitch
            width: parent.width*0.22
            Component.onCompleted: checked = alarm.enabled
            onCheckedChanged: {
                alarm.enabled = enableSwitch.checked
                alarm.save()
            }
            anchors {
                topMargin: parent.height*0.1
                top: parent.top
                right: parent.right
                rightMargin: parent.height/2
            }
        }

        MouseArea {
            id: largerSwitchArea
            width: app.width*0.4
            onClicked: enableSwitch.checked = !enableSwitch.checked
            anchors {
                top: parent.top
                bottom: parent.bottom
                right: parent.right
            }
        }

    }
}
