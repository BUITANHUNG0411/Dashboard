import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
    id: weatherRoot
    gradient: Gradient {
        GradientStop { position: 0.0; color: "#00b4db" }
        GradientStop { position: 1.0; color: "#0083b0" }
    }

    property string cityName : "--";
    property string temp : "--";
    property string description : "--";
    property string humidity : "--";
    property string windSpeed : "--";
    property string icon : "";

    Connections {
        target: weatherControl

        function onWeatherDataReceived(name, temp, description, humidity, speed, icon){
            weatherRoot.cityName = name;
            weatherRoot.temp = temp.toFixed(1) + "°C";
            weatherRoot.description = description;
            weatherRoot.humidity = humidity + "%";
            weatherRoot.windSpeed = speed + "km/h";
            weatherRoot.icon = icon;
        }
    }

    Rectangle {
        id: glassContainer
        anchors.centerIn: parent
        width: 400
        height: 550
        radius: 40
        color: Qt.rgba(255, 255, 255, 0.15)
        border.color: Qt.rgba(255, 255, 255, 0.3)
        border.width: 1

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 40
            spacing: 0

            Text {
                text: weatherRoot.cityName
                font.pixelSize: 34
                font.weight: Font.Medium
                color: "white"
                Layout.alignment: Qt.AlignHCenter
            }


            Text {
                text: Qt.formatDateTime(new Date(), "dddd, d MMMM")
                font.pixelSize: 16
                color: Qt.rgba(255, 255, 255, 0.7)
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 10
            }


            Image {
                id: weatherIcon
                source: weatherRoot.icon ? "http://openweathermap.org/img/wn/" + weatherRoot.icon + "@2x.png" : ""
                Layout.preferredWidth: 120
                Layout.preferredHeight: 120
                Layout.alignment: Qt.AlignHCenter
                fillMode: Image.PreserveAspectFit
                opacity: 0.9
            }

            Item { Layout.fillHeight: true }

            Text {
                text: weatherRoot.temp
                font.pixelSize: 120
                font.weight: Font.ExtraLight
                color: "white"
                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                text: weatherRoot.description
                font.pixelSize: 22
                font.letterSpacing: 1.1
                color: "white"
                Layout.alignment: Qt.AlignHCenter
                Layout.bottomMargin: 40
            }

            Item { Layout.fillHeight: true }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: Qt.rgba(255, 255, 255, 0.2)
                Layout.bottomMargin: 35
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 20

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 8
                    Text {
                        text: "HUMIDITY"
                        font.pixelSize: 12
                        font.weight: Font.Bold
                        color: Qt.rgba(255, 255, 255, 0.5)
                        Layout.alignment: Qt.AlignHCenter
                    }
                    Text {
                        text: weatherRoot.humidity
                        font.pixelSize: 22
                        font.weight: Font.Medium
                        color: "white"
                        Layout.alignment: Qt.AlignHCenter
                    }
                }

                Rectangle {
                    width: 1
                    Layout.preferredHeight: 50
                    color: Qt.rgba(255, 255, 255, 0.2)
                    Layout.alignment: Qt.AlignVCenter
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 8
                    Text {
                        text: "WIND SPEED"
                        font.pixelSize: 12
                        font.weight: Font.Bold
                        color: Qt.rgba(255, 255, 255, 0.5)
                        Layout.alignment: Qt.AlignHCenter
                    }
                    Text {
                        text: weatherRoot.windSpeed
                        font.pixelSize: 22
                        font.weight: Font.Medium
                        color: "white"
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }
        }
    }
}
