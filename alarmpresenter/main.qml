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
import Nemo.Alarms 1.0
import Nemo.DBus 2.0
import Nemo.Configuration 1.0
import Nemo.Ngf 1.0
import org.asteroid.controls 1.0

Application {
    id: app
    property var alarmDialog
    overridesSystemGestures: alarmDialog !== undefined && alarmDialog !== null
    leftIndicVisible: false
    topIndicVisible: false

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
            if (activeDialogs.length > 0 && (activeDialogs[0].type === Alarm.Clock || activeDialogs[0].type === Alarm.Countdown)) {
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

    StatusPage {
        icon: (alarmDialog && (alarmDialog.type === Alarm.Countdown)) ? "ios-timer-outline" : "ios-alarm-outline"
    }

    Label {
        id: alarmTimeField
        font.pixelSize: Dims.l(15)
        anchors.centerIn: parent
        anchors.verticalCenterOffset: Dims.h(13)
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
                    return twoDigits(alarmDialog.hour) + ":" + twoDigits(alarmDialog.minute)
            }
        }
    }

    IconButton {
        id: alarmDismiss
        iconName: "ios-checkmark-circle-outline"
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
            leftMargin: Dims.iconButtonMargin
        }
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
        iconName: "ios-sleep-circle-outline"
        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
            rightMargin: Dims.iconButtonMargin
        }
        visible: (alarmDialog !== undefined && alarmDialog !== null) && (alarmDialog.type !== Alarm.Countdown)
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
        event: "alarm"
    }

    DBusInterface {
        id: mceRequest

        service: "com.nokia.mce"
        path: "/com/nokia/mce/request"
        iface: "com.nokia.mce.request"

        bus: DBus.SystemBus
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
