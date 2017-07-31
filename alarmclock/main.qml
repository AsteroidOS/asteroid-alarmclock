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

import QtQuick 2.8
import org.nemomobile.alarms 1.0
import org.asteroid.controls 1.0

Application {
    id: app

    centerColor: "#dfb103"
    outerColor: "#be4e0e"

    Component  { id: timePickerLayer;  AlarmTimePickerDialog { } }
    LayerStack {
        id: layerStack
        firstPage: firstPageComponent
    }

    AlarmsModel  { id: alarmModel }

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
                    Text {
                        id: title
                        color: "white"
                        text: qsTr("Alarms")
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        width: parent.width; height: Dims.h(22)
                    }

                    AlarmViewRepeater {
                        id: alarmList
                        model: alarmModel
                        onEditClicked: layerStack.push(timePickerLayer, {"alarmObject": alarm})
                    }

                    Item { width: parent.width; height: Dims.h(20) }
                }
            }

            Text {
                text: qsTr("No alarms")
                color: "white"
                font.pixelSize: Dims.l(8)
                visible: alarmModel.populated && alarmList.count === 0
                anchors.centerIn: parent
            }

            IconButton {
                id: newAlarmBtn
                iconColor: "white"
                pressedIconColor: "lightgrey"
                iconName:  "ios-add-circle-outline"
                visible: alarmModel.populated
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: Dims.iconButtonMargin
                onClicked: layerStack.push(timePickerLayer)
            }
        }
    }
}
