import QtQuick
import QtQuick.Controls

Rectangle {
    color: chatBackend.isDarkMode ? "#0f172a" : "#ffffff"
    Text {
        anchors.centerIn: parent
        text: "Contact View"
        font.pixelSize: 24
        color: chatBackend.isDarkMode ? "#ffffff" : "#000000"
    }
}
