import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: noteRoot
    color: chatBackend.isDarkMode ? "#062016" : "#f0fdf4"

    Item{
        id : status
        property int todo : 0;
        property int done : 1;
        property int all  : 2;
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 40
        spacing: 25

        RowLayout {
            Layout.fillWidth: true
            spacing: 15

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
                    implicitWidth: 150
                    implicitHeight: 32
                    radius: 16
                    color: chatBackend.isDarkMode ? "#14532d" : "#bbf7d0"
                    border.color: chatBackend.isDarkMode ? "#4ade80" : "#22c55e"
                    border.width: 1
                }
                contentItem: Text {
                    text: addButton.text
                    font {
                        weight: addButton.font.weight
                        pixelSize: 14
                    }
                    color: chatBackend.isDarkMode ? "#4ade80" : "#166534"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onClicked: {
                    noteControl.addNote();
                    noteFilterControl.setCondition(status.todo);
                    noteFilterControl.invalidateFilter();
                }
            }

            Button {
                id: trashButton
                text: "Push all to trash"
                flat: true
                font.weight: Font.Medium
                background: Rectangle {
                    implicitWidth: 150
                    implicitHeight: 32
                    radius: 16
                    color: chatBackend.isDarkMode ? "#14532d" : "#bbf7d0"
                    border.color: chatBackend.isDarkMode ? "#4ade80" : "#22c55e"
                    border.width: 1
                }
                contentItem: Row {
                    spacing: 6
                    anchors.centerIn: parent
                    Image {
                        source: "assets/rubbish.png"
                        width: 16
                        height: 16
                        fillMode: Image.PreserveAspectFit
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Text {
                        text: trashButton.text
                        font {
                            weight: trashButton.font.weight
                            pixelSize: 14
                        }
                        color: chatBackend.isDarkMode ? "#4ade80" : "#166534"
                        verticalAlignment: Text.AlignVCenter
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                onClicked: {
                    noteControl.clearAllNote();
                    noteFilterControl.invalidateFilter();
                }
            }

            ComboBox {
                id: filterCombo
                model: ["To do", "Done", "All Notes"]
                implicitWidth: 150
                implicitHeight: 32
                font.weight: Font.Medium

                onActivated: {
                    noteFilterControl.setCondition(index);
                }

                background: Rectangle {
                    radius: 16
                    color: (filterCombo.pressed || filterCombo.hovered || filterCombo.down) ? (chatBackend.isDarkMode ? "#166534" : "#86efac") : (chatBackend.isDarkMode ? "#14532d" : "#bbf7d0")
                    border.color: chatBackend.isDarkMode ? "#4ade80" : "#22c55e"
                    border.width: 1

                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
                }


                
                contentItem: Text {
                    text: filterCombo.currentText
                    font {
                        weight: filterCombo.font.weight
                        pixelSize: 14
                    }
                    color: chatBackend.isDarkMode ? "#4ade80" : "#166534"
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: 15
                    rightPadding: 30
                    elide: Text.ElideRight
                }

                indicator: Canvas {
                    x: filterCombo.width - 25
                    y: filterCombo.height / 2 - 3
                    width: 10
                    height: 5
                    onPaint: {
                        var context = getContext("2d");
                        context.reset();
                        context.moveTo(0, 0);
                        context.lineTo(width, 0);
                        context.lineTo(width / 2, height);
                        context.closePath();
                        context.fillStyle = chatBackend.isDarkMode ? "#4ade80" : "#166534"
                        context.fill();
                    }
                }

                delegate: ItemDelegate {
                    width: filterCombo.width
                    height: 32
                    contentItem: Text {
                        text: modelData
                        color: chatBackend.isDarkMode ? "#4ade80" : "#166534"
                        font {
                            weight: filterCombo.font.weight
                            pixelSize: 13
                        }
                        verticalAlignment: Text.AlignVCenter
                        leftPadding: 15
                    }
                    background: Rectangle {
                        color: (highlighted || index === filterCombo.currentIndex) ? (chatBackend.isDarkMode ? "#14532d" : "#bbf7d0") : (chatBackend.isDarkMode ? "#0f2f21" : "#ffffff")
                        Behavior on color { ColorAnimation { duration: 150 } }
                    }
                }

                popup: Popup {
                    y: filterCombo.height + 5
                    width: filterCombo.width
                    implicitHeight: contentItem.implicitHeight
                    padding: 1

                    contentItem: ListView {
                        clip: true
                        implicitHeight: contentHeight
                        model: filterCombo.popup.visible ? filterCombo.delegateModel : null
                        ScrollIndicator.vertical: ScrollIndicator { }
                    }

                    background: Rectangle {
                        radius: 12
                        border.color: chatBackend.isDarkMode ? "#4ade80" : "#22c55e"
                        color: chatBackend.isDarkMode ? "#0f2f21" : "#f0fdf4"
                    }
                }
            }
        }

        ListView {
            id: notesListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: noteFilterControl
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
                        onClicked: {
                            noteControl.setStatus(index, checked);
                            noteFilterControl.invalidateFilter();
                        }

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
