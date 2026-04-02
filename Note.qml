import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: noteRoot
    color: chatBackend.isDarkMode ? "#062016" : "#f0fdf4"

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 40
        spacing: 25

        RowLayout {
            Layout.fillWidth: true

            Label {
                text: "My Notes"
                font.pixelSize: 32
                font.weight: Font.DemiBold
                color: chatBackend.isDarkMode ? "#4ade80" : "#166534"
                Layout.fillWidth: true
            }

            Button {
                id: addButton
                text: "＋ Add Note"
                flat: true
                font.weight: Font.Medium
                background: Rectangle {
                    implicitWidth: 120
                    implicitHeight: 40
                    radius: 20
                    color: addButton.pressed ? (chatBackend.isDarkMode ? "#166534" : "#86efac") : (chatBackend.isDarkMode ? "#14532d" : "#bbf7d0")
                    border.color: chatBackend.isDarkMode ? "#4ade80" : "#22c55e"
                    border.width: 1
                }
                contentItem: Text {
                    text: addButton.text
                    font: addButton.font
                    color: chatBackend.isDarkMode ? "#4ade80" : "#166534"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onClicked: {
                    noteControl.addNote();
                }
            }

            Button {
                id: trashButton
                text: "Click to push all notes to trash"
                flat: true
                font.weight: Font.Medium
                background: Rectangle {
                    implicitWidth: 260
                    implicitHeight: 40
                    radius: 20
                    color: trashButton.pressed ? (chatBackend.isDarkMode ? "#166534" : "#86efac") : (chatBackend.isDarkMode ? "#14532d" : "#bbf7d0")
                    border.color: chatBackend.isDarkMode ? "#4ade80" : "#22c55e"
                    border.width: 1
                }
                contentItem: Text {
                    text: trashButton.text
                    font: trashButton.font
                    color: chatBackend.isDarkMode ? "#4ade80" : "#166534"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onClicked: {
                    noteControl.clearAllNote();
                }
            }
        }

        ListView {
            id: notesListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: noteControl
            spacing: 15
            clip: true

            delegate: Rectangle {
                width: notesListView.width
                height: 80
                radius: 12
                color: chatBackend.isDarkMode ? "#0f2f21" : "#ffffff"
                border.color: chatBackend.isDarkMode ? "#14532d" : "#d1fae5"
                border.width: 1

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 15

                    Rectangle {
                        Layout.preferredWidth: 4
                        Layout.fillHeight: true
                        radius: 2
                        color: model.status ? (chatBackend.isDarkMode ? "#14532d" : "#d1fae5") : "#22c55e"

                        Behavior on color {
                            ColorAnimation {
                                duration: 200
                            }
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 0
                        TextField {
                            id: noteInput
                            Layout.fillWidth: true
                            text: model.content
                            placeholderText: "Type note here..."
                            placeholderTextColor: chatBackend.isDarkMode ? "#30624a" : "#a7f3d0"
                            font.pixelSize: 16
                            color: model.status ? (chatBackend.isDarkMode ? "#30624a" : "#94a3b8") : (chatBackend.isDarkMode ? "#ecfdf5" : "#064e3b")
                            font.strikeout: model.status
                            selectByMouse: true
                            background: null
                            onEditingFinished: noteControl.setContent(index, text)
                        }
                        Label {
                            text: model.timeStamp
                            font.pixelSize: 11
                            color: chatBackend.isDarkMode ? "#30624a" : "#6bc091"
                            Layout.leftMargin: 0
                        }
                    }

                    CheckBox {
                        id: doneCheck
                        checked: model.status
                        onClicked: noteControl.setStatus(index, checked)

                        indicator: Rectangle {
                            implicitWidth: 24
                            implicitHeight: 24
                            radius: 6
                            color: "transparent"
                            border.color: doneCheck.checked ? "#22c55e" : (chatBackend.isDarkMode ? "#30624a" : "#cbd5e1")
                            border.width: 2

                            Text {
                                text: "✔"
                                font.pixelSize: 16
                                color: "#22c55e"
                                anchors.centerIn: parent
                                visible: doneCheck.checked
                            }
                        }
                    }

                    Button {
                        id: removeButton
                        text: "✕"
                        Layout.preferredWidth: 36
                        Layout.preferredHeight: 36
                        flat: true

                        background: Rectangle {
                            radius: 18
                            color: removeButton.hovered ? (chatBackend.isDarkMode ? "#7f1d1d" : "#fee2e2") : "transparent"
                        }

                        contentItem: Text {
                            text: removeButton.text
                            font.pixelSize: 18
                            color: removeButton.hovered ? (chatBackend.isDarkMode ? "#fecaca" : "#ef4444") : (chatBackend.isDarkMode ? "#30624a" : "#6bc091")
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        onClicked: noteControl.removeNote(index)
                    }
                }

                Behavior on color {
                    ColorAnimation {
                        duration: 200
                    }
                }
            }

            add: Transition {
                NumberAnimation {
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 400
                }
                NumberAnimation {
                    property: "scale"
                    from: 0.9
                    to: 1.0
                    duration: 400
                }
            }

            remove: Transition {
                NumberAnimation {
                    property: "opacity"
                    to: 0
                    duration: 200
                }
                NumberAnimation {
                    property: "scale"
                    to: 0.9
                    duration: 200
                }
            }

            displaced: Transition {
                NumberAnimation {
                    properties: "y"
                    duration: 400
                    easing.type: Easing.OutBounce
                }
            }
        }
    }
}
