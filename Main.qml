import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Window {
    id: root
    width: 1200
    height: 800
    visible: true
    title: qsTr("ChatBot Nav Demo")

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            Layout.preferredWidth: 80
            Layout.fillHeight: true
            color: chatBackend.isDarkMode ? "#1e293b" : "#f1f5f9"

            ColumnLayout {
                anchors.fill: parent
                spacing: 20
                anchors.topMargin: 20

                Button {
                    text: "Chat"
                    Layout.fillWidth: true
                    onClicked: stackLayout.currentIndex = 0
                    palette.buttonText: chatBackend.isDarkMode ? "#ffffff" : "#000000"
                }
                Button {
                    text: "Weather"
                    Layout.fillWidth: true
                    onClicked: stackLayout.currentIndex = 1
                    palette.buttonText: chatBackend.isDarkMode ? "#ffffff" : "#000000"
                }
                Button {
                    text: "Map"
                    Layout.fillWidth: true
                    onClicked: stackLayout.currentIndex = 2
                    palette.buttonText: chatBackend.isDarkMode ? "#ffffff" : "#000000"
                }
                Button {
                    text: "Contact"
                    Layout.fillWidth: true
                    onClicked: stackLayout.currentIndex = 3
                    palette.buttonText: chatBackend.isDarkMode ? "#ffffff" : "#000000"
                }
                Button {
                    text: "Music"
                    Layout.fillWidth: true
                    onClicked: stackLayout.currentIndex = 4
                    palette.buttonText: chatBackend.isDarkMode ? "#ffffff" : "#000000"
                }
                Button {
                    text: "Note"
                    Layout.fillWidth: true
                    onClicked: stackLayout.currentIndex = 5
                    palette.buttonText: chatBackend.isDarkMode ? "#ffffff" : "#000000"
                }
                
                Item { Layout.fillHeight: true }

                Switch {
                    Layout.alignment: Qt.AlignHCenter
                    checked: chatBackend.isDarkMode
                    onToggled: chatBackend.isDarkMode = checked
                }
                
                Item { Layout.preferredHeight: 20 }
            }
        }

        StackLayout {
            id: stackLayout
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: 0

            Chatbot {}
            Weather {}
            Map {}
            Contact {}
            Music {}
            Note {}
        }
    }
}
