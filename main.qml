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

Application {
    id: app

    Component  { id: timePickerLayer;  AlarmTimePickerDialog { } }
    Component  { id: alarmDialogLayer; AlarmDialog           { } }
    LayerStack { id: layerStack }

    AlarmsModel  { id: alarmModel }
    AlarmHandler {
        onError: console.log("asteroid-alarmclock: error in AlarmHandler: " + message);
        onAlarmReady: if(alarmModel.populated) layerStack.push(alarmDialogLayer, {"alarmObject": alarm})
    }

    Flickable {
        contentHeight: col.height
        contentWidth: width
        boundsBehavior: Flickable.DragOverBounds
        flickableDirection: Flickable.VerticalFlick
        anchors.fill: parent
        Column {
            id: col
            width: parent.width
            AlarmViewRepeater {
                id: alarmList
                model: alarmModel
                onEditClicked: layerStack.push(timePickerLayer, {"alarmObject": alarm})
            }
            
            Label {
                text: "No alarms"
                font.pixelSize: Units.dp(14)
                visible: alarmModel.populated && alarmList.count === 0
                anchors.horizontalCenter: parent.horizontalCenter
            }

            IconButton {
                id: newAlarmBtn
                iconColor: "black"
                iconName:  "add"
                visible: alarmModel.populated
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: layerStack.push(timePickerLayer)
            }
        }
    }
}
