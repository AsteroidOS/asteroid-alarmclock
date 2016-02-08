/*
 * Copyright (C) 2015 - Florent Revest <revestflo@gmail.com>
 *               2013 - Santtu Mansikkamaa <santtu.mansikkamaa@nomovok.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 2.1 of the
 * License, or (at your option) any later version.
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
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0
import org.nemomobile.time 1.0
import org.asteroid.controls 1.0

Rectangle {
    id: root

    property int hour: 0
    property int minute: 0
    property bool mode24Hour

    property alias enableMonday:    buttonDayMon.checked;
    property alias enableTuesday:   buttonDayTue.checked;
    property alias enableWednesday: buttonDayWed.checked;
    property alias enableThursday:  buttonDayThu.checked;
    property alias enableFriday:    buttonDayFri.checked;
    property alias enableSaturday:  buttonDaySat.checked;
    property alias enableSunday:    buttonDaySun.checked;

    property bool editingAlarm:      false;
    property var editIndexRelay
    property var dateTime

    function update() {
        var time = wallClock.time;
        dateTime = new Date(time.getFullYear(), time.getMonth(), time.getDate(), time.getHours(), time.getMinutes(), time.getSeconds());
    }

    Component.onCompleted: update()

    WallClock {
        id: wallClock
        enabled: true
        updateFrequency: WallClock.Minute
        onTimeChanged:  root.update()
    }

    Label {
        text: "Select time:"
        font.pixelSize: 30
        anchors {
            top: parent.top
            topMargin: 6
            horizontalCenter: parent.horizontalCenter
        }
    }

    TimePicker {
        id: tp
        height: parent.height*0.6
        width: parent.width*0.6
        anchors.centerIn: parent
    }

    Row {
        anchors {
            bottom: parent.bottom
            right: parent.right
            left: parent.left
        }
        height: 55
        Button { id: buttonDayMon; text: "Mon"; checkable: true; width: parent.width/7 }
        Button { id: buttonDayTue; text: "Tue"; checkable: true; width: parent.width/7 }
        Button { id: buttonDayWed; text: "Wed"; checkable: true; width: parent.width/7 }
        Button { id: buttonDayThu; text: "Thu"; checkable: true; width: parent.width/7 }
        Button { id: buttonDayFri; text: "Fri"; checkable: true; width: parent.width/7 }
        Button { id: buttonDaySat; text: "Sat"; checkable: true; width: parent.width/7 }
        Button { id: buttonDaySun; text: "Sun"; checkable: true; width: parent.width/7 }
    }

    IconButton {
        id: acceptButton
        iconColor: "black"
        iconName: "checkmark-circled"

        anchors {
            verticalCenter: parent.verticalCenter
            leftMargin: Units.dp(4)
            left: parent.left
        }

        onClicked: {
            root.hour = tp.hours
            root.minute = tp.minutes
            root.visible = false
        }
    }

    IconButton {
        id: rejectButton
        iconColor: "black"
        iconName: "cancel"

        anchors {
            verticalCenter: parent.verticalCenter
            rightMargin: Units.dp(4)
            right: parent.right
        }

        onClicked: {
            editingAlarm = false;
//            TH.restoreIndex(tumbler);
            root.visible = false
        }
    }

    onHourChanged: {
        tp.hours = root.hour
    }

    onMinuteChanged: {
        tp.minutes = root.minute
    }
}
