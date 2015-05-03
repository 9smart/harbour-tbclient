# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-tbclient

CONFIG += sailfishapp c++11


DEFINES += Q_OS_SAILFISH
QT += webkit multimedia sql dbus

include(notifications/notification.pri)

HEADERS += \
    src/utility.h \
    src/tbnetworkaccessmanagerfactory.h \
    src/downloader.h \
    src/httpuploader.h \
    src/audiorecorder.h \
    src/imageuploader.h \
    src/dbusservice.h

SOURCES += \
    src/main.cpp \
    src/utility.cpp \
    src/tbnetworkaccessmanagerfactory.cpp \
    src/downloader.cpp \
    src/httpuploader.cpp \
    src/audiorecorder.cpp \
    src/imageuploader.cpp \
    src/dbusservice.cpp

OTHER_FILES += \
    qml/CoverPage.qml \
    rpm/harbour-tbclient.changes.in \
    rpm/harbour-tbclient.spec \
    rpm/harbour-tbclient.yaml \
    translations/*.ts \
    harbour-tbclient.desktop \
    qml/js/BaiduParser.js \
    qml/js/BaiduService.js \
    qml/js/LinkDecoder.js \
    qml/js/main.js \
    qml/js/storage.js \
    qml/js/Utils.js \
    qml/js/WorkerScript.js \
    qml/js/YoukuParser.js \
    qml/js/default_theme.css \
    qml/js/TabGroup.js \
    qml/tbclient/AboutPage.qml \
    qml/tbclient/AccountPage.qml \
    qml/tbclient/BatchSignPage.qml \
    qml/tbclient/Constant.qml \
    qml/tbclient/CoverPage.qml \
    qml/tbclient/ImageViewer.qml \
    qml/tbclient/InfoCenter.qml \
    qml/tbclient/LoginPage.qml \
    qml/tbclient/main.qml \
    qml/tbclient/MainPage.qml \
    qml/tbclient/MorePage.qml \
    qml/tbclient/ProfilePage.qml \
    qml/tbclient/SearchPage.qml \
    qml/tbclient/SettingsPage.qml \
    qml/tbclient/SignalCenter.qml \
    qml/tbclient/TBSettings.qml \
    qml/tbclient/Browser/WebDownloadInfo.qml \
    qml/tbclient/Browser/WebHomeDelegate.qml \
    qml/tbclient/Browser/WebHomeMenu.qml \
    qml/tbclient/Browser/WebMainMenu.qml \
    qml/tbclient/Browser/WebPage.qml \
    qml/tbclient/Browser/WebViewPage.qml \
    qml/tbclient/Component/AbstractItem.qml \
    qml/tbclient/Component/AudioWrapper.qml \
    qml/tbclient/Component/Bubble.qml \
    qml/tbclient/Component/FooterItem.qml \
    qml/tbclient/Component/MyPage.qml \
    qml/tbclient/Component/PullToActivate.qml \
    qml/tbclient/Component/Sheet.qml \
    qml/tbclient/Component/StatusPaneText.qml \
    qml/tbclient/Component/ToolButtonWithTip.qml \
    qml/tbclient/Component/ViewHeader.qml \
    qml/tbclient/Dialog/CommitDialog.qml \
    qml/tbclient/Dialog/CopyDialog.qml \
    qml/tbclient/Dialog/DynamicQueryDialog.qml \
    qml/tbclient/Dialog/EmoticonSelector.qml \
    qml/tbclient/Dialog/EnterThreadDialog.qml \
    qml/tbclient/Dialog/GoodListDialog.qml \
    qml/tbclient/Dialog/NewVCodeDialog.qml \
    qml/tbclient/Dialog/PageJumper.qml \
    qml/tbclient/Dialog/RemindSettingDialog.qml \
    qml/tbclient/Dialog/SignatureDialog.qml \
    qml/tbclient/Dialog/VCodeDialog.qml \
    qml/tbclient/Explore/FeedDelegate.qml \
    qml/tbclient/Explore/FeedPage.qml \
    qml/tbclient/Explore/ForumDirPage.qml \
    qml/tbclient/Explore/ForumRankDelegate.qml \
    qml/tbclient/Explore/ForumRankPage.qml \
    qml/tbclient/Explore/SquareListPage.qml \
    qml/tbclient/Explore/SquarePage.qml \
    qml/tbclient/Floor/FloorDelegate.qml \
    qml/tbclient/Floor/FloorHeader.qml \
    qml/tbclient/Floor/FloorMenu.qml \
    qml/tbclient/Floor/FloorPage.qml \
    qml/tbclient/Floor/ToolsArea.qml \
    qml/tbclient/Forum/ForumDelegate.qml \
    qml/tbclient/Forum/ForumHeader.qml \
    qml/tbclient/Forum/ForumPage.qml \
    qml/tbclient/Forum/ForumPicture.qml \
    qml/tbclient/Forum/ForumPictureDelegate.qml \
    qml/tbclient/Message/AtmePage.qml \
    qml/tbclient/Message/ChatPage.qml \
    qml/tbclient/Message/MessagePage.qml \
    qml/tbclient/Message/PletterPage.qml \
    qml/tbclient/Message/ReplyPage.qml \
    qml/tbclient/Post/PostPage.js \
    qml/tbclient/Post/AttachedArea.qml \
    qml/tbclient/Post/ImageArea.qml \
    qml/tbclient/Post/PostPage.qml \
    qml/tbclient/Post/ScribblePage.qml \
    qml/tbclient/Post/SelectionMethodMenu.qml \
    qml/tbclient/Post/VoiceArea.qml \
    qml/tbclient/Profile/AvatarEditPage.qml \
    qml/tbclient/Profile/BookmarkPage.qml \
    qml/tbclient/Profile/FriendsPage.qml \
    qml/tbclient/Profile/ProfileCell.qml \
    qml/tbclient/Profile/ProfileEditPage.qml \
    qml/tbclient/Profile/ProfileForumList.qml \
    qml/tbclient/Profile/ProfilePost.qml \
    qml/tbclient/Profile/SelectFriendPage.qml \
    qml/tbclient/Thread/AudioDelegate.qml \
    qml/tbclient/Thread/ImageDelegate.qml \
    qml/tbclient/Thread/ReaderPage.qml \
    qml/tbclient/Thread/TabHeader.qml \
    qml/tbclient/Thread/TextDelegate.qml \
    qml/tbclient/Thread/ThreadButton.qml \
    qml/tbclient/Thread/ThreadDelegate.qml \
    qml/tbclient/Thread/ThreadHeader.qml \
    qml/tbclient/Thread/ThreadManageMenu.qml \
    qml/tbclient/Thread/ThreadMenu.qml \
    qml/tbclient/Thread/ThreadPage.qml \
    qml/tbclient/Thread/ThreadPicture.qml \
    qml/tbclient/Thread/ThreadPictureDelegate.qml \
    qml/tbclient/Thread/ThreadView.qml \
    qml/tbclient/InfoBanner.qml \
    qml/tbclient/MyButton.qml \
    qml/tbclient/SettingsItem.qml \
    qml/tbclient/Thread/TabPanel.qml \
    qml/tbclient/Thread/TabGroup.qml \
    qml/tbclient/Component/BerthMenu.qml \
    qml/tbclient/Component/HeaderBtn.qml \
    qml/tbclient/Component/MainBtnMenu.qml \
    qml/tbclient/Component/TabView.qml \
    qml/tbclient/Component/EnterThreadMenu.qml \
    qml/tbclient/Component/EnterThreadSearchMenu.qml

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n
TRANSLATIONS += translations/harbour-tbclient-de.ts \
                 translations/harbour-tbclient-zh_CN.ts

