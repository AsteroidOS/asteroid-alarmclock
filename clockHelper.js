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


/*
 * Edits the given digit to include two digts.
 * Example: 5 -> 05
 */
function twoDigits(x) {
    if(x<10) {
        return "0"+x;
    }
    else {
        return x;
    }
}

/*
 * Parses the title to a bit more nicer format.
 */
function parseAlarmTitle(title) {
    var returnString = "";
    if (title === ""){
        returnString = " ";
    }
    else if (title === "mtwTf") {
        returnString = "Weekdays";
    }
    else if (title === "sS") {
        returnString = "Weekends";
    }
    else if (title === "mtwTfsS") {
        returnString = "Every day";
    }
    else {
        if (title.indexOf("m") >= 0) {
            returnString = "Mon, ";
        }
        if (title.indexOf("t") >= 0) {
            returnString = returnString + "Tue, ";
        }
        if (title.indexOf("w") >= 0) {
            returnString = returnString + "Wed, ";
        }
        if (title.indexOf("T") >= 0) {
            returnString = returnString + "Thu, ";
        }
        if (title.indexOf("f") >= 0) {
            returnString = returnString + "Fri, ";
        }
        if (title.indexOf("s") >= 0 ) {
            returnString = returnString + "Sat, ";
        }
        if (title.indexOf("S") >= 0) {
            returnString = returnString + "Sun";
        }
        if ((returnString.indexOf(", ") >= 0) && (returnString.indexOf("Sun") === -1)) {
            returnString = returnString.slice(0, returnString.length-2);
        }
    }
    return returnString;
}

/*
 * Opens the alarm editing and creation view with the set values
 */
function launchDialog(isNewAlarm, newAlarmObject, editingIndex, tDialog) {
    if (isNewAlarm) {
        tDialog.hour = 12;
        tDialog.minute = 0;
        tDialog.enableMonday    = false;
        tDialog.enableTuesday   = false;
        tDialog.enableWednesday = false;
        tDialog.enableThursday  = false;
        tDialog.enableFriday    = false;
        tDialog.enableSaturday  = false;
        tDialog.enableSunday    = false;
        tDialog.editingAlarm    = false;
    }
    else {
        tDialog.hour = newAlarmObject.hour;
        tDialog.minute = newAlarmObject.minute;
        tDialog.enableMonday    = ( newAlarmObject.daysOfWeek.indexOf("m") >= 0 ? true : false );
        tDialog.enableTuesday   = ( newAlarmObject.daysOfWeek.indexOf("t") >= 0 ? true : false );
        tDialog.enableWednesday = ( newAlarmObject.daysOfWeek.indexOf("w") >= 0 ? true : false );
        tDialog.enableThursday  = ( newAlarmObject.daysOfWeek.indexOf("T") >= 0 ? true : false );
        tDialog.enableFriday    = ( newAlarmObject.daysOfWeek.indexOf("f") >= 0 ? true : false );
        tDialog.enableSaturday  = ( newAlarmObject.daysOfWeek.indexOf("s") >= 0 ? true : false );
        tDialog.enableSunday    = ( newAlarmObject.daysOfWeek.indexOf("S") >= 0 ? true : false );
        tDialog.editingAlarm    = true;
    }
    tDialog.visible = true;
    tDialog.editIndexRelay = editingIndex;
}

/*
 * This function parses and saves the given alarm
 */
function callbackFunction(tDialog, alarmModel, systemAlarmModel) {
    var daysString = "";
    if (tDialog.enableMonday) {
        daysString = "m"
    }
    if (tDialog.enableTuesday) {
        daysString = daysString + "t"
    }
    if (tDialog.enableWednesday) {
        daysString = daysString + "w"
    }
    if (tDialog.enableThursday) {
        daysString = daysString + "T"
    }
    if (tDialog.enableFriday) {
        daysString = daysString + "f"
    }
    if (tDialog.enableSaturday) {
        daysString = daysString + "s"
    }
    if (tDialog.enableSunday) {
        daysString = daysString + "S"
    }

    var alarm = systemAlarmModel.createAlarm();
    alarm.hour = tDialog.hour;
    alarm.minute = tDialog.minute;
    alarm.title = daysString;
    alarm.daysOfWeek = daysString;
    alarm.enabled = true;
    alarm.save();
    tDialog.visible = false;

    //Includes this new alarm to visible list
    alarmModel.append(    {"alarmTime": twoDigits(tDialog.hour)+":"+twoDigits(tDialog.minute),
                           "alarmName": daysString,
                           "alarmEnabled": true,
                           "alarmObject": alarm,
                           "markedForDeletion": false});
}



// This function lists all alarms that have gone off, and 'should' have been notified about.
// Can be cleaned
function listAllAlarms(systemAlarmHandler) {
    console.log("-----------Activated-alarms-in-system["+systemAlarmHandler.activeDialogs.length+"]-------------")
    for(var i=0 ; i < systemAlarmHandler.activeDialogs.length ; i++) {
        var pickedAlarm = systemAlarmHandler.activeDialogs[i];
        console.log(i+": "+pickedAlarm.hour+":"+pickedAlarm.minute
                    +" with name '"+pickedAlarm.title+"' and has enabled status of "+pickedAlarm.enabled);
    }
    console.log("--------------------------------------------")
}


/*
 * Deletes all items from alarmModel that have been checked for deletion.
 * AlarmModel is the actual AlarmModel.qml.
 * Alarm is one of the instances AlarmModel contains e.g. AlarmViewRepeater item.
 * AlarmObject is the alarmObject that timed provides.
 */
function deleteSelectedItems(alarmModel) {
    for ( var i = alarmModel.count - 1 ; i >= 0 ; i--) {
        var alarm = alarmModel.get(i);
        if (alarm.markedForDeletion) {
            alarm.alarmObject.deleteAlarm();  //removes from backend (timed)
            alarmModel.remove(i);             //removes form UI
        }
    }
}


/*
 *  Removes markers from deletion selection.
 */
function clearDeletionMarkers(alarmModel) {
    //THIS FEATURES IS NOT WORKING
    console.log("This feature is disabled and doesn't remove checked statuses.")
    return;
    for ( var i = alarmModel.count -1 ; i >= 0 ; i--) {
        alarmModel.get(i).markedForDeletion = false;
    }
}



/*
 * Updates anabled status of the alarm that has been popped.
 * NOTE: If there are two exactly same alarms, there might be a misshap.
 */
function updateAlarmEnabledStatus(alarm, alarmModel) {

    //check is the alarm one shot
    if(alarm.title.length > 0) {
        return;
    }

    //find alarm index
    for(var i = 0; alarmModel.count > i; i++) {
        if (alarmModel.get(i).alarmTime === (+twoDigits(alarm.hour)+":"+twoDigits(alarm.minute))) {
            if (alarmModel.get(i).alarmName === alarm.title) {
                alarmModel.get(i).alarmEnabled = false;
            }
        }
    }
}
