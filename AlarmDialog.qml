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
import org.asteroid.controls 1.0

Rectangle {
    id: alarmDialogRoot
    color: "black"

    property alias alarmName : alarmNameField.text
    property alias alarmTime : alarmTimeField.text
    property var alarmObject

    signal alarmDisableClicked
    signal alarmSnoozeClicked

    MouseArea {
        anchors.fill: parent
        z: 15
    }

    Text {
        id: alarmNameField
        color: "gray"
        font.pixelSize: 40
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Text {
        id: alarmTimeField
        color: "white"
        font.pixelSize: 50
        anchors.centerIn: parent
    }

    IconButton {
        id: alarmDisable
        iconColor: "white"
        iconName: "sunny"

        anchors {
            verticalCenter: parent.verticalCenter
            leftMargin: Units.dp(8)
            left: parent.left
        }

        onClicked: {
            alarmDisableClicked();
            alarmDialogRoot.visible = false;
        }
    }

    IconButton {
        id: alarmSnooze
        iconColor: "white"
        iconName: "moon"

        anchors {
            verticalCenter: parent.verticalCenter
            rightMargin: Units.dp(8)
            right: parent.right
        }

        onClicked: {
            alarmSnoozeClicked();
            alarmDialogRoot.visible = false;
        }
    }
}
