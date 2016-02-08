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
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.0
import "clockHelper.js" as CH

Repeater {
    id: repeaterRoot
    property bool deletionEnabled: false
    signal editClicked (var alarmObject, var index)
    property bool dummyProperty: false

    delegate: Rectangle {
        height: 82
        width: parent.width

        Text {
            id: timeField
            text: alarmTime
            anchors {
                bottom: parent.verticalCenter
                left: parent.left
                leftMargin: 60
                margins: 0
            }
            font.pixelSize: 40
            z: 20
        }

        Text {
            id: nameField
            text: CH.parseAlarmTitle(alarmName);
            anchors {
                top: parent.verticalCenter
                margins: 0
                left: timeField.left
            }
            font.pixelSize: 40
            z: 20
        }

        Switch {
            id: enableSwitch
            z: 30
            anchors {
                right: parent.right
                rightMargin: 30
                verticalCenter: parent.verticalCenter
            }
            checked: repeaterRoot.deletionEnabled ? model.alarmEnabled : model.alarmEnabled
            onCheckedChanged: {
                alarmObject.enabled = checked;
                alarmObject.save();
            }
        }

        CheckBox {
            id: markDeletion
            z: 30
            visible: deletionEnabled
            checked: (repeaterRoot.dummyProperty ? model.markedForDeletion : model.markedForDeletion)
            onClicked: {
                alarmModel.get(index).markedForDeletion = !alarmModel.get(index).markedForDeletion
                console.log("Mark changed to: "+markedForDeletion);
                repeaterRoot.dummyProperty = !repeaterRoot.dummyProperty;
            }
            anchors {
                left: parent.left
                leftMargin: 10
                verticalCenter: parent.verticalCenter
            }
        }

        MouseArea {
            id: editByClick
            z: 20
            anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
                right: enableSwitch.left
            }
            onClicked: if (!markDeletion.visible) {
                editClicked(alarmObject, index);
            }
        }
    }
}
