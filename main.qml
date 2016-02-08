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

import QtQuick 2.4
import QtQuick.Controls 1.3
import org.nemomobile.alarms 1.0
import org.asteroid.controls 1.0
import "clockHelper.js" as CH

Item {
    id: app
    anchors.fill: parent

    property bool populated: false

    Label {
        anchors.centerIn: parent
        text: "No alarms"
        visible: !populated
    }

    Flickable {
        id: listViewFlickable
        clip: true
        contentHeight: alarmModel.count *  82 + 2
        contentWidth: width
        boundsBehavior: Flickable.DragOverBounds
        flickableDirection: Flickable.VerticalFlick
        anchors.fill: parent
        Column {
            AlarmViewRepeater {
                id: alarmList
                onEditClicked: CH.launchDialog(false, alarmObject, index, tDialog);
                model: ListModel {
                    id: alarmModel
                    property var alarmName
                    property var alarmTime
                    property var alarmObject
                    property var alarmEnabled
                    property bool markedForDeletion
                }
            }
        }
    }

    IconButton {
        id: buttonNewAlarm
        iconColor: "black"
        iconName: alarmList.deletionEnabled ? "cancel" : "add";

        anchors {
            verticalCenter: parent.verticalCenter
            leftMargin: Units.dp(8)
            left: parent.left
        }

        onClicked: {
            if (alarmList.deletionEnabled) {
                alarmList.deletionEnabled = false
                CH.clearDeletionMarkers(alarmModel);
            }
            else {
                CH.launchDialog(true, 0, -1, tDialog);
            }
        }
    }

    IconButton {
        id: buttonDeleteAlarm
        iconColor: "black"
        iconName: alarmList.deletionEnabled ? "done" : "delete";

        anchors {
            verticalCenter: parent.verticalCenter
            rightMargin: Units.dp(8)
            right: parent.right
        }

        onClicked: {
            if(!alarmList.deletionEnabled)
                alarmList.deletionEnabled = true;
            else {
                CH.deleteSelectedItems(alarmModel);
                alarmList.deletionEnabled = false;
            }
        }
    }

    AlarmTimePickerDialog {
        id: tDialog
        anchors.fill: parent
        visible: false

/*        onAccepted: {
            if(editingAlarm){
                alarmModel.remove(editIndexRelay);
            }
            CH.callbackFunction(tDialog, alarmModel, systemAlarmModel);
        }*/
    }

    AlarmsModel {
        id: systemAlarmModel

        onPopulatedChanged: app.populated = true
    }

    AlarmHandler {
        id: systemAlarmHandler

        onError: console.log(" +++Error in AlarmHandler: " + message);
        onAlarmReady: {
            console.log(" +++Alarm ready: " + alarm.hour + ":" + alarm.minute + " at " + alarm.title);
            if(app.populated) {
                alarmDialog.alarmName = CH.parseAlarmTitle(alarm.title);
                alarmDialog.alarmTime = CH.twoDigits(alarm.hour) + ":" + CH.twoDigits(alarm.minute);
                alarmDialog.alarmObject = alarm;
                alarmDialog.visible = true;
            }
        }
    }

    AlarmDialog {
        id: alarmDialog
        anchors.fill: parent
        visible: false

        onAlarmSnoozeClicked: alarmObject.snooze();
        onAlarmDisableClicked: {
            CH.updateAlarmEnabledStatus(alarmObject, alarmModel);
            alarmObject.dismiss();
        }
    }
}
