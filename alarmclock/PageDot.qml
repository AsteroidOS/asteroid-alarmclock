/*
 * Copyright (C) 2016 - Florent Revest <revestflo@gmail.com>
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
    width: height*(dotNumber+1)
    visible: dotNumber > 0

    property int currentIndex: 0
    property int dotNumber: 0

    Row {
        anchors.fill: parent
        spacing: height/4

        Repeater {
            model: dotNumber
            Rectangle {
                width: parent.height
                height: parent.height
                radius: parent.height
                color: "white"
                opacity: index == currentIndex ? 1 : 0.5
            }
        }

        Text {
            text: "+"
            width: parent.height
            height: parent.height
            verticalAlignment: Text.AlignVCenter
            color: "white"
            opacity: currentIndex == dotNumber ? 1 : 0.5
        }
    }
}
