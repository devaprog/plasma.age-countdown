import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasmoid
import org.kde.plasma.components as PlasmaComponents

PlasmoidItem {
    id: root
    preferredRepresentation: Plasmoid.fullRepresentation

    // Configuration properties with proper defaults
    property int  birthYear:   plasmoid.configuration.birthYear   || 2000
    property int  birthMonth:  plasmoid.configuration.birthMonth  || 1
    property int  birthDay:    plasmoid.configuration.birthDay    || 1
    property int  birthHour:   plasmoid.configuration.birthHour   || 0
    property int  birthMinute: plasmoid.configuration.birthMinute || 0
    property int  birthSecond: plasmoid.configuration.birthSecond || 0

    property string textColor:       plasmoid.configuration.textColor       || "#ffffff"
    property string backgroundColor: plasmoid.configuration.backgroundColor || "#33000000"
    property bool   useThemeColors:  (plasmoid.configuration.useThemeColors !== undefined)
    ? plasmoid.configuration.useThemeColors
    : true

    // Derived property with validation
    property date dob: {
        if (birthYear >= 1900 && birthMonth >= 1 && birthMonth <= 12 && birthDay >= 1 && birthDay <= 31) {
            return new Date(birthYear, birthMonth - 1, birthDay, birthHour, birthMinute, birthSecond)
        } else {
            // Default to current date if configuration is invalid
            var now = new Date()
            return new Date(now.getFullYear() - 21, now.getMonth(), now.getDate(), now.getHours(), now.getMinutes(), now.getSeconds())
        }
    }

    // Live age breakdown
    property int years: 0
    property int months: 0
    property int days: 0
    property int hours: 0
    property int minutes: 0
    property int seconds: 0

    // Helper functions to get actual colors
    function getTextColor() {
        if (useThemeColors) { return Kirigami.Theme.textColor; }
        return textColor;
    }

    function getBackgroundColor() {
        if (useThemeColors) { return Kirigami.Theme.backgroundColor; }
        return backgroundColor;
    }

    QQC2.Label {
        text: "Preview: " + new Date(
            yearSpin.value, monthSpin.value-1, daySpin.value,
            hourSpin.value, minuteSpin.value, secondSpin.value
        ).toLocaleString()
        wrapMode: Text.Wrap
        Layout.fillWidth: true
    }

    function updateAge() {
        if (!dob || isNaN(dob.getTime())) return

            var now = new Date()

            // Years/Months/Days (calendar-accurate)
            var y = now.getFullYear() - dob.getFullYear()
            var m = now.getMonth() - dob.getMonth()
            var d = now.getDate() - dob.getDate()

            if (d < 0) {
                // borrow days from previous month
                var prevMonthDays = new Date(now.getFullYear(), now.getMonth(), 0).getDate()
                d += prevMonthDays
                m -= 1
            }
            if (m < 0) {
                m += 12
                y -= 1
            }

            // Time-of-day
            var nowSec = now.getHours()*3600 + now.getMinutes()*60 + now.getSeconds()
            var dobSec = dob.getHours()*3600 + dob.getMinutes()*60 + dob.getSeconds()
            var secDiff = nowSec - dobSec
            if (secDiff < 0) {
                secDiff += 86400
                d -= 1
                if (d < 0) {
                    // borrow from previous month again
                    var prevMonthDays2 = new Date(now.getFullYear(), now.getMonth(), 0).getDate()
                    d += prevMonthDays2
                    m -= 1
                    if (m < 0) {
                        m += 12
                        y -= 1
                    }
                }
            }

            var hh = Math.floor(secDiff / 3600)
            secDiff -= hh * 3600
            var mm = Math.floor(secDiff / 60)
            var ss = secDiff - mm * 60
            years = y; months = m; days = d
            hours = hh; minutes = mm; seconds = ss
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.updateAge()
    }

    Component.onCompleted: updateAge()

    Connections {
        target: plasmoid
        function onConfigurationChanged() {
            // re-read bound properties & refresh
            dob = new Date(birthYear, Math.max(0, birthMonth - 1), birthDay, birthHour, birthMinute, birthSecond)
            updateAge()
        }
    }

    // Compact view
    compactRepresentation: PlasmaComponents.Label {
        text: years + "y " + months + "m"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.bold: true
        font.pointSize: Kirigami.Theme.defaultFont.pointSize + 1
        color: getTextColor()
    }

    // Full view
    fullRepresentation: Item {
        implicitWidth: 360
        implicitHeight: 180

        Rectangle {
            anchors.fill: parent
            color: getBackgroundColor()
            radius: 5
            border.color: Kirigami.Theme.textColor
            border.width: 1
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Kirigami.Units.largeSpacing
            spacing: Kirigami.Units.smallSpacing

            PlasmaComponents.Label {
                Layout.fillWidth: true
                text: "Since " + dob.toLocaleDateString(Qt.locale(), Locale.LongFormat) + " " +
                dob.toLocaleTimeString(Qt.locale(), Locale.ShortFormat)
                wrapMode: Text.Wrap
                opacity: 0.8
                color: getTextColor()
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Kirigami.Units.largeSpacing

                ColumnLayout {
                    PlasmaComponents.Label {
                        text: years;
                        font.pixelSize: 42;
                        font.bold: true;
                        color: getTextColor();
                    }
                    PlasmaComponents.Label {
                        text: "Years";
                        color: getTextColor();
                    }
                }
                ColumnLayout {
                    PlasmaComponents.Label {
                        text: months;
                        font.pixelSize: 42;
                        font.bold: true;
                        color: getTextColor();
                    }
                    PlasmaComponents.Label {
                        text: "Months";
                        color: getTextColor();
                    }
                }
                ColumnLayout {
                    PlasmaComponents.Label {
                        text: days;
                        font.pixelSize: 42;
                        font.bold: true;
                        color: getTextColor();
                    }
                    PlasmaComponents.Label {
                        text: "Days";
                        color: getTextColor();
                    }
                }
            }

            PlasmaComponents.Label {
                Layout.fillWidth: true
                font.pixelSize: 28
                font.bold: true
                text: (hours<10?"0":"")+hours + ":" + (minutes<10?"0":"")+minutes + ":" + (seconds<10?"0":"")+seconds
                horizontalAlignment: Text.AlignHCenter
                color: getTextColor()
            }

            Item { Layout.fillHeight: true }
        }
    }
}
