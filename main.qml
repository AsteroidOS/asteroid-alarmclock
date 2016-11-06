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

import QtQuick 2.4
import org.nemomobile.alarms 1.0
import org.asteroid.controls 1.0

Application {
    id: app

    Component  { id: timePickerLayer;  AlarmTimePickerDialog { } }
    Component  { id: alarmDialogLayer; AlarmDialog           { } }
    LayerStack {
        id: layerStack
        firstPage: firstPageComponent
    }

    AlarmsModel  { id: alarmModel }
    AlarmHandler {
        onError: console.log("asteroid-alarmclock: error in AlarmHandler: " + message);
        onAlarmReady: if(alarmModel.populated) layerStack.push(alarmDialogLayer, {"alarmObject": alarm})
    }

    Component {
        id: firstPageComponent
        Item {
            Flickable {
                contentHeight: col.height
                contentWidth: width
                boundsBehavior: Flickable.DragOverBounds
                flickableDirection: Flickable.VerticalFlick
                anchors.fill: parent
                interactive: alarmModel.populated && alarmList.count !== 0
                Column {
                    id: col
                    width: parent.width

                    Item { width: parent.width; height: DeviceInfo.hasRoundScreen ? app.height/6 : 0 }

                    AlarmViewRepeater {
                        id: alarmList
                        model: alarmModel
                        onEditClicked: layerStack.push(timePickerLayer, {"alarmObject": alarm})
                    }

                    Item { width: parent.width; height: Units.dp(8) }

                    IconButton {
                        id: newAlarmBtn
                        iconColor: "white"
                        pressedIconColor: "lightgrey"
                        iconName:  "ios-add-circle-outline"
                        visible: alarmModel.populated
                        anchors.horizontalCenter: parent.horizontalCenter
                        onClicked: layerStack.push(timePickerLayer)
                    }
                }
            }

            Text {
                text: qsTr("No alarms")
                color: "white"
                font.pixelSize: Units.dp(14)
                visible: alarmModel.populated && alarmList.count === 0
                anchors.centerIn: parent
            }
        }
    }
}
