cmake_minimum_required(VERSION 3.16)

project(ChatBotDemo VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Network Positioning)
find_package(Qt6 REQUIRED COMPONENTS Core)
find_package(Qt6 REQUIRED COMPONENTS Core)
find_package(Qt6 REQUIRED COMPONENTS Core)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appChatBotDemo
    main.cpp
    ChatController.h
    ChatController.cpp
    ChatModel.h
    ChatModel.cpp
    WeatherController.h 
    WeatherController.cpp
    note.h
    note.cpp
    NoteFilterModel.h 
    NoteFilterModel.cpp
)

qt_add_qml_module(appChatBotDemo
    URI ChatBotDemo
    QML_FILES
        Main.qml
        Chatbot.qml
        Weather.qml
        Map.qml
        Contact.qml
        Music.qml
        Note.qml
        RESOURCES assets/rubbish.png
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appChatBotDemo PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appChatBotDemo
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appChatBotDemo
    PRIVATE Qt6::Quick Qt6::Network Qt6::Positioning
)
target_link_libraries(appChatBotDemo PRIVATE Qt6::Core)
target_link_libraries(appChatBotDemo PRIVATE Qt6::Core)
target_link_libraries(appChatBotDemo PRIVATE Qt6::Core)

include(GNUInstallDirs)
install(TARGETS appChatBotDemo
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
