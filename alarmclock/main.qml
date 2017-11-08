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

import QtQml 2.2
import QtQuick 2.8
import org.nemomobile.alarms 1.0
import org.asteroid.controls 1.0

Application {
    id: app

    centerColor: "#dfb103"
    outerColor: "#be4e0e"

    Component  { id: timePickerLayer;  TimePickerDialog { } }
    Component  { id: daysSelectorLayer;  DaysSelectorDialog { } }
    LayerStack {
        id: layerStack
        firstPage: firstPageComponent
    }

    AlarmsModel { id: alarmModel }
    Instantiator {
        // This component is needed to access alarmModel.count() and alarmModel.get()
        id: alarmModelAccessor
        model: alarmModel
        delegate: QtObject { property QtObject alarmObject: alarm }
    }

    Component {
        id: firstPageComponent
        Item {
            PageDot {
                height: Dims.h(3)
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 3*Dims.iconButtonMargin
                currentIndex: flick.currentIndex
                dotNumber: alarmModelAccessor.count
                additionalDot: true
            }

            ListView {
                id: flick
                anchors.fill: parent
                model: alarmModelAccessor.count+1

                highlight: Item { width: app.width }
                clip: true
                snapMode: ListView.SnapToItem
                orientation: Qt.Horizontal

                property int currentIndex: Math.round(contentX/(app.width))

                delegate: AlarmListItem {
                    alarm: {
                        var modelObject = alarmModelAccessor.objectAt(index)
                        if(modelObject !== null)
                            modelObject.alarmObject
                        else
                            return null
                    }
                    onTimeEditClicked: layerStack.push(timePickerLayer, {"alarmObject": alarm})
                    onDaysEditClicked: layerStack.push(daysSelectorLayer, {"alarmObject": alarm})
                }
            }
        }
    }
}
