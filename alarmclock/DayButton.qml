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

import QtQuick 2.9
import org.asteroid.controls 1.0

Item {
    property int day: 1
    property bool checked: false

    Rectangle {
        anchors.margins: Dims.l(1)
        anchors.fill: parent
        color: checked ? "#d4962c" : "#8c6e39"
        border.width: 1
        border.color: checked ? "#FFFFFF" : "#DDDDDD"
        radius: width/2
    }

    Text {
        text: Qt.locale().dayName(day, Locale.ShortFormat)
        color: checked ? "#FFFFFF" : "#DDDDDD"
        anchors.fill: parent
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }

    MouseArea {
        anchors.fill: parent
        onClicked: checked = !checked
    }
}
