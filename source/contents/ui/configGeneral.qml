import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import QtQml
import org.kde.kirigami as Kirigami

Item {
    id: page
    implicitWidth: 400
    implicitHeight: 500

    // Backing values (connected to KConfig)
    property alias cfg_birthYear: yearSpin.value
    property alias cfg_birthMonth: monthSpin.value
    property alias cfg_birthDay: daySpin.value
    property alias cfg_birthHour: hourSpin.value
    property alias cfg_birthMinute: minuteSpin.value
    property alias cfg_birthSecond: secondSpin.value
    property alias cfg_textColor: textColorField.text
    property alias cfg_backgroundColor: backgroundColorField.text
    property alias cfg_useThemeColors: useThemeColorsCheck.checked

    function daysInMonth(y, m) {
        return new Date(y, m, 0).getDate()
    }

    Kirigami.FormLayout {
        anchors.fill: parent
        anchors.margins: Kirigami.Units.largeSpacing

        // Date of birth
        RowLayout {
            Kirigami.FormData.label: "Date of birth:"
            QQC2.SpinBox {
                id: yearSpin
                from: 1900
                to: new Date().getFullYear()
                value: 2000
                Layout.preferredWidth: 80
            }
            QQC2.Label { text: "-" }
            QQC2.SpinBox {
                id: monthSpin
                from: 1
                to: 12
                value: 1
                Layout.preferredWidth: 60
                onValueChanged: {
                    var dim = daysInMonth(yearSpin.value, value)
                    daySpin.to = dim
                    if (daySpin.value > dim) {
                        daySpin.value = dim
                    }
                }
            }
            QQC2.Label { text: "-" }
            QQC2.SpinBox {
                id: daySpin
                from: 1
                to: 31
                value: 1
                Layout.preferredWidth: 60
            }
        }

        // Time of birth
        RowLayout {
            Kirigami.FormData.label: "Time of birth:"
            QQC2.SpinBox {
                id: hourSpin
                from: 0
                to: 23
                value: 0
                Layout.preferredWidth: 60
            }
            QQC2.Label { text: ":" }
            QQC2.SpinBox {
                id: minuteSpin
                from: 0
                to: 59
                value: 0
                Layout.preferredWidth: 60
            }
            QQC2.Label { text: ":" }
            QQC2.SpinBox {
                id: secondSpin
                from: 0
                to: 59
                value: 0
                Layout.preferredWidth: 60
            }
        }

        QQC2.Button {
            text: "Set to current time"
            onClicked: {
                var now = new Date()
                hourSpin.value = now.getHours()
                minuteSpin.value = now.getMinutes()
                secondSpin.value = now.getSeconds()
            }
        }

        Kirigami.Separator {
            Layout.fillWidth: true
        }

        // Color settings
        QQC2.CheckBox {
            id: useThemeColorsCheck
            text: "Use system theme colors"
            checked: true
        }

        RowLayout {
            Kirigami.FormData.label: "Text Color:"
            enabled: !useThemeColorsCheck.checked
            QQC2.TextField {
                id: textColorField
                text: "#ffffff"
                placeholderText: "#ffffff"
                Layout.fillWidth: true
            }
        }

        RowLayout {
            Kirigami.FormData.label: "Background Color:"
            enabled: !useThemeColorsCheck.checked
            QQC2.TextField {
                id: backgroundColorField
                text: "#33000000"
                placeholderText: "#33000000"
                Layout.fillWidth: true
            }
        }

        QQC2.Label {
            text: "Tip: Use #00000000 for transparent background"
            font.italic: true
            opacity: 0.7
            enabled: !useThemeColorsCheck.checked
        }

        Kirigami.Separator {
            Layout.fillWidth: true
        }

        QQC2.Label {
            text: "Preview: " + new Date(yearSpin.value, monthSpin.value-1, daySpin.value,
                                         hourSpin.value, minuteSpin.value, secondSpin.value).toLocaleString()
                                         wrapMode: Text.Wrap
                                         Layout.fillWidth: true
        }
    }
}
