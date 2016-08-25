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
import QtFeedback 5.0
import org.asteroid.controls 1.0
import org.nemomobile.dbus 1.0

Rectangle {
    id: alarmDialogRoot
    property var alarmObject
    color: "black"

    function twoDigits(x) {
        if (x<10) return "0"+x;
        else      return x;
    }

    Text {
        id: alarmTimeField
        color: "white"
        font.pixelSize: 50
        anchors.centerIn: parent
        text: twoDigits(alarmObject.hour) + ":" + twoDigits(alarmObject.minute)
    }

    IconButton {
        id: alarmDisable
        iconColor: "white"
        pressedIconColor: "lightgrey"
        iconName: "sunny"

        anchors {
            verticalCenter: parent.verticalCenter
            leftMargin: Units.dp(8)
            left: parent.left
        }

        onClicked: {
            // Disable the alarm if it is a singleshot
            if(alarmObject.title.length == 0) {
                //find alarm index
                for(var i = 0; alarmModel.count > i; i++) {
                    if (alarmModel.get(i).alarmTime === (+twoDigits(alarmObject.hour)+":"+twoDigits(alarmObject.minute))) {
                        if (alarmModel.get(i).alarmName === alarmObject.title) {
                            alarmModel.get(i).alarmEnabled = false;
                        }
                    }
                }
            }
            alarmObject.dismiss();
        }
    }

    IconButton {
        id: alarmSnooze
        iconColor: "white"
        pressedIconColor: "lightgrey"
        iconName: "moon"

        anchors {
            verticalCenter: parent.verticalCenter
            rightMargin: Units.dp(8)
            right: parent.right
        }

        onClicked: alarmObject.snooze();
    }

    ThemeEffect {
         id: haptics
         effect: "PressStrong"
     }

    property DBusInterface _dbus: DBusInterface {
        id: dbus

        destination: "com.nokia.mce"
        path: "/com/nokia/mce/request"
        iface: "com.nokia.mce.request"

        busType: DBusInterface.SystemBus
    }

    Component.onCompleted: {
        haptics.play()
        dbus.call("req_display_state_on", undefined)
        window.raise()
    }
}
