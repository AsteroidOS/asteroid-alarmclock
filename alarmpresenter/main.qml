/*
 * Copyright (C) 2017 - Florent Revest <revestflo@gmail.com>
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
import org.nemomobile.alarms 1.0
import org.nemomobile.ngf 1.0
import org.nemomobile.dbus 1.0
import org.nemomobile.configuration 1.0
import org.asteroid.controls 1.0

Application {
    id: app
    property var alarmDialog
    overridesSystemGestures: alarmDialog !== undefined && alarmDialog !== null

    centerColor: "#333333"
    outerColor: "#000000"

    function twoDigits(x) {
        if (x<10) return "0"+x;
        else      return x;
    }

    AlarmsModel  { id: alarmModel }
    AlarmHandler {
        id: alarmHandler
        onError: console.log("asteroid-alarmpresenter: error in AlarmHandler: " + message);
        onActiveDialogsChanged: {
            if (activeDialogs.length > 0 && activeDialogs[0].type === Alarm.Clock) {
                alarmDialog = activeDialogs[0]
                dialogOnScreen = true
            }
        }
    }

    ConfigurationValue {
        id: use12H
        key: "/org/asteroidos/settings/use-12h-format"
        defaultValue: false
    }

    Text {
        id: alarmTimeField
        color: "white"
        font.pixelSize: Dims.l(18)
        anchors.centerIn: parent
        text: {
            if(alarmDialog == undefined || alarmDialog == null)
                return ""
            else {
                if(use12H.value) {
                    var amPm = "AM";
                    if(alarm.hour >= 12)
                        amPm = "PM";
                    return twoDigits(alarmDialog.hour%12) + ":" + twoDigits(alarmDialog.minute) + amPm
                } else
                    return twoDigits(alarmDialog.hour) + ":" + twoDigits(alarmDialog.minute) : ""
            }
        }
    }

    IconButton {
        id: alarmDismiss
        iconName: "ios-sunny"
        edge: Qt.LeftEdge
        onClicked: {
            // Disable the alarm if it is a singleshot
            for(var i = 0; alarmModel.count > i; i++) {
                if (alarmModel.get(i).alarmTime === (+twoDigits(alarmDialog.hour)+":"+twoDigits(alarmDialog.minute))) {
                    if (alarmModel.get(i).alarmName === alarmDialog.title) {
                        alarmModel.get(i).alarmEnabled = false;
                    }
                }
            }
            feedback.stop()
            if(alarmDialog !== undefined && alarmDialog !== null)
                alarmDialog.dismiss()
            alarmTimeField.text = ""
            alarmHandler.dialogOnScreen = false
            window.close()
        }
    }

    IconButton {
        id: alarmSnooze
        iconName: "ios-moon"
        edge: Qt.RightEdge
        onClicked: {
            feedback.stop()
            if(alarmDialog !== undefined && alarmDialog !== null)
                alarmDialog.snooze()
            alarmTimeField.text = ""
            alarmHandler.dialogOnScreen = false
            window.close()
        }
    }

    NonGraphicalFeedback {
        id: feedback
        event: "clock"
    }

    DBusInterface {
        id: mceRequest

        destination: "com.nokia.mce"
        path: "/com/nokia/mce/request"
        iface: "com.nokia.mce.request"

        busType: DBusInterface.SystemBus
    }

    Timer {
        id: autoSnoozeTimer
        interval: 30000
        onTriggered: {
            feedback.stop()
            if(alarmDialog !== undefined && alarmDialog !== null)
                alarmDialog.snooze()
            alarmTimeField.text = ""
            alarmHandler.dialogOnScreen = false
            window.close()
        }
    }

    DBusInterface {
        bus: DBus.SystemBus
        service: 'com.nokia.mce'
        path: '/com/nokia/mce/signal'
        iface: 'com.nokia.mce.signal'
        signalsEnabled: true

        function alarm_ui_feedback_ind(event) {
            if (event == "powerkey") {
                feedback.stop()
                if(alarmDialog !== undefined && alarmDialog !== null)
                    alarmDialog.snooze()
                alarmTimeField.text = ""
                alarmHandler.dialogOnScreen = false
                window.close()
            }
        }
    }

    Component.onCompleted: {
        mceRequest.call("req_display_state_on", undefined)
        feedback.play()
        autoSnoozeTimer.start()
    }
}
