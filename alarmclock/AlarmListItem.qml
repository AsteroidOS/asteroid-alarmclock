/*
 * Copyright (C) 2017 - Florent Revest <revestflo@gmail.com>
 *               2016 - Sylvia van Os <iamsylvie@openmailbox.org>
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
import org.asteroid.controls 1.0
import org.nemomobile.configuration 1.0

Item {
    property QtObject alarm
    property bool isLastPage: alarm == null

    signal timeEditClicked (var alarm)
    signal daysEditClicked (var alarm)

    width: app.width
    height: app.height

    function twoDigits(x) {
        if (x<10) return "0"+x;
        else      return x;
    }

    function parseDays(days) {
        if      (days === "")        return qsTr("Once");
        else if (days === "mtwTf")   return qsTr("Weekdays");
        else if (days === "sS")      return qsTr("Weekends");
        else if (days === "mtwTfsS") return qsTr("Every day");
        else {
            var returnString = "";
            var boldLetterOpening = "<b style=\"color:white;\">";
            var boldLetterClosing = "</b>"
            if (days.indexOf("m") >= 0) returnString += boldLetterOpening
            returnString += Qt.locale().dayName(1, Locale.ShortFormat)[0] + " ";
            if (days.indexOf("m") >= 0) returnString += boldLetterClosing

            if (days.indexOf("t") >= 0) returnString += boldLetterOpening
            returnString += Qt.locale().dayName(2, Locale.ShortFormat)[0] + " ";
            if (days.indexOf("t") >= 0) returnString += boldLetterClosing

            if (days.indexOf("w") >= 0) returnString += boldLetterOpening
            returnString += Qt.locale().dayName(3, Locale.ShortFormat)[0] + " ";
            if (days.indexOf("w") >= 0) returnString += boldLetterClosing

            if (days.indexOf("T") >= 0) returnString += boldLetterOpening
            returnString += Qt.locale().dayName(4, Locale.ShortFormat)[0] + " ";
            if (days.indexOf("T") >= 0) returnString += boldLetterClosing

            if (days.indexOf("f") >= 0) returnString += boldLetterOpening
            returnString += Qt.locale().dayName(5, Locale.ShortFormat)[0] + " ";
            if (days.indexOf("f") >= 0) returnString += boldLetterClosing

            if (days.indexOf("s") >= 0) returnString += boldLetterOpening
            returnString += Qt.locale().dayName(6, Locale.ShortFormat)[0] + " ";
            if (days.indexOf("s") >= 0) returnString += boldLetterClosing

            if (days.indexOf("S") >= 0) returnString += boldLetterOpening
            returnString += Qt.locale().dayName(7, Locale.ShortFormat)[0];
            if (days.indexOf("S") >= 0) returnString += boldLetterClosing

            return returnString;
        }
    }

    ConfigurationValue {
        id: use12H
        key: "/org/asteroidos/settings/use-12h-format"
        defaultValue: false
    }

    Item {
        width: parent.width
        height: parent.height
        visible: !isLastPage
        enabled: !isLastPage

        Text {
            id: time
            text: {
                if(isLastPage) return ""

                if(use12H.value) {
                    var amPm = "<font size=\"0.5\">AM</font>";
                    if(alarm.hour >= 12)
                        amPm = "<font size=\"0.5\">PM</font>";
                    return twoDigits(alarm.hour%12) + ":" + twoDigits(alarm.minute) + amPm
                } else
                    return twoDigits(alarm.hour) + ":" + twoDigits(alarm.minute)
            }
            color: "white"
            textFormat: Text.RichText
            opacity: enableSwitch.checked ? 1.0 : 0.7
            font.pixelSize: use12H ? Dims.l(13) : Dims.l(15)
            font.weight: Font.Medium
            anchors.top: enableSwitch.top
            anchors.left: parent.left
            anchors.leftMargin: Dims.w(10)
            height: contentHeight
            width: Dims.w(50)

            MouseArea {
                anchors.fill: parent
                onClicked: timeEditClicked(alarm)
            }
        }

        Text {
            id: enabledDays
            textFormat: Text.RichText
            text: !isLastPage ? parseDays(alarm.daysOfWeek) : ""
            color: "#AAFFFFFF"
            opacity: enableSwitch.checked ? 0.8 : 0.5
            font.pixelSize: Dims.l(7)
            anchors.bottom: enableSwitch.bottom
            anchors.left: parent.left
            anchors.leftMargin: Dims.w(10)
            height: contentHeight
            width: Dims.w(50)

            MouseArea {
                anchors.fill: parent
                onClicked: daysEditClicked(alarm)
            }
        }

        Switch {
            id: enableSwitch
            Component.onCompleted: checked = !isLastPage && alarm.enabled
            onCheckedChanged: {
                if(alarm.enabled != checked) {
                    alarm.enabled = enableSwitch.checked
                    alarm.save()
                }
            }
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -Dims.h(5)
            anchors.right: parent.right
            anchors.rightMargin: Dims.w(10)
        }

        IconButton {
            iconName: "ios-trash-circle"
            iconColor: "white"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: Dims.iconButtonMargin
            onClicked: alarm.deleteAlarm()
        }
    }

    Item {
        width: parent.width
        height: parent.height
        visible: isLastPage
        enabled: isLastPage

        Rectangle {
            id: addAlarmBackground
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -Dims.h(5)
            color: ma.pressed ? "#333333": "black"
            radius: width/2
            opacity: 0.2
            width: Dims.w(25)
            height: width
        }
        Icon {
            anchors.fill: addAlarmBackground
            anchors.margins: Dims.l(3)
            name: "ios-add"
            color: "white"
        }

        Text {
            text: qsTr("Add an alarm")
            font.pixelSize: Dims.l(7)
            color: "white"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.Wrap
            anchors.left: parent.left; anchors.right: parent.right
            anchors.leftMargin: Dims.w(2); anchors.rightMargin: Dims.w(2)
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: Dims.h(15)
        }

        MouseArea {
            id: ma
            width: Dims.w(70)
            height: Dims.h(70)
            anchors.centerIn: parent
            onClicked: layerStack.push(timePickerLayer)
        }
    }
}
