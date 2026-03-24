import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Window {
    width: 1000
    height: 700
    visible: true
    title: qsTr("ChatBot Demo")

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            Layout.preferredWidth: 250
            Layout.fillHeight: true
            color: chatBackend.isDarkMode ? "#1e293b" : "#f1f5f9"

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 15

                Label {
                    text: "AI Configuration"
                    color: chatBackend.isDarkMode ? "#ffffff" : "#000000"
                    font.bold: true
                    font.pixelSize: 16
                }

                ComboBox {
                    Layout.fillWidth: true
                    model: ["Gemini 2.5 Flash", "Gemini 1.5 Pro", "Gemini 1.0 Pro"]
                    palette.text: chatBackend.isDarkMode ? "#ffffff" : "#000000"
                    palette.buttonText: chatBackend.isDarkMode ? "#ffffff" : "#000000"
                    onActivated: chatBackend.setModel(currentText)
                }

                Switch {
                    id : mode
                    checked: chatBackend.isDarkMode
                    text: checked ? "Dark mode" : "Light mode"
                    onToggled: chatBackend.isDarkMode = checked
                    palette.windowText: chatBackend.isDarkMode ? "#ffffff" : "#000000"
                }

                Label {
                    text: "Temperature"
                    color: chatBackend.isDarkMode ? "#ffffff" : "#000000"
                }

                Slider {
                    Layout.fillWidth: true
                    from: 0
                    to: 1
                    value: 0.7
                }

                Button {
                    text: "New Chat"
                    Layout.fillWidth: true
                    palette.buttonText: chatBackend.isDarkMode ? "#ffffff" : "#000000"
                    onClicked: chatBackend.clearChat()
                }

                Button {
                    text: "Export Log"
                    Layout.fillWidth: true
                    palette.buttonText: chatBackend.isDarkMode ? "#ffffff" : "#000000"
                    onClicked: chatBackend.exportLog()
                }

                Item { Layout.fillHeight: true }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: chatBackend.isDarkMode ? "#0f172a" : "#ffffff"

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 0
                spacing: 0

                ListView {
                    id: chatView
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    model: chatBackend.chatModel
                    delegate: Item {
                        width: chatView.width
                        height: messageText.implicitHeight + 40

                        Rectangle {
                            width: parent.width - 40
                            height: parent.height - 10
                            anchors.centerIn: parent
                            color: model.author === "You" ? (chatBackend.isDarkMode ? "#3b82f6" : "#dbeafe") : (chatBackend.isDarkMode ? "#334155" : "#f1f5f9")
                            radius: 8

                            Text {
                                id: messageText
                                text: "<b>" + model.author + ":</b> " + model.text
                                width: parent.width - 20
                                anchors.centerIn: parent
                                wrapMode: Text.Wrap
                                font.pixelSize: 14
                                color: "#000000"
                            }
                        }
                    }

                    ScrollBar.vertical: ScrollBar {}

                    onCountChanged: chatView.positionViewAtEnd()
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 80
                    color: chatBackend.isDarkMode ? "#1e293b" : "#f8fafc"
                    border.color: chatBackend.isDarkMode ? "#334155" : "#cbd5e1"

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 15
                        spacing: 10

                        TextField {
                            id: messageInput
                            Layout.fillWidth: true
                            placeholderText: "Type your message here..."
                            font.pixelSize: 14
                            color: "#000000"
                            onAccepted: sendButton.clicked()
                        }

                        Button {
                            id: sendButton
                            text: "Send"
                            Layout.preferredHeight: 40
                            palette.buttonText: chatBackend.isDarkMode ? "#ffffff" : "#000000"
                            onClicked: {
                                chatBackend.sendMessage(messageInput.text)
                                messageInput.clear()
                            }
                        }
                    }
                }
            }
        }
    }
}
