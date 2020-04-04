import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQuick 2.12
import QtQuick.Controls 2.14
import QtQuick.Controls 1.4 as C
import QtQuick.XmlListModel 2.0
Window {
    id:rootWindow
    visible: true
    width: 800
    minimumWidth:menuToolbar.implicitWidth
    height: 600
    title: qsTr("rssNewsPeeks")

    function bringDarkness(){


    }


    ToolBar{
        width: parent.width
        id:menuToolbar
        RowLayout{
            width: parent.width
            ToolButton{

                text: "Dark Mode"
                icon.source:"delete-black-18dp.svg"
                onClicked:bringDarkness()
            }

            ToolSeparator {
                padding: vertical ? 10 : 2
                topPadding: vertical ? 2 : 10
                bottomPadding: vertical ? 2 : 10

                contentItem: Rectangle {
                    implicitWidth: parent.vertical ? 1 : 24
                    implicitHeight: parent.vertical ? 24 : 1
                    color: "#c3c3c3"
                }
            }

            ToolSeparator {
                padding: vertical ? 10 : 2
                topPadding: vertical ? 2 : 10
                bottomPadding: vertical ? 2 : 10

            }
            Slider{
                Layout.fillWidth: true
            }
            TextField{
                text: "news"
                placeholderText: "Search..."
                id:txtSearch
            }
        }
    }

    SplitView{
        anchors.topMargin: 40
        anchors.bottom: menuToolbar
        id:splitviewParent
        anchors.bottomMargin: 19
        anchors.fill: parent
        C.TableView {
            id:tableOk
            x: 3
            width: 200
            height:parent
            visible: true
            clip: false
            verticalScrollBarPolicy: 0
            C.TableViewColumn
            {
                title:"Top News For You"
                role:"title"

            }
            model: flickerModel
        }

        SplitView{
            orientation: Qt.Vertical
            anchors.fill: splitviewParent
            Image{
                id:imageText
                fillMode: Image.PreserveAspectFit
                source: flickerModel.get(tableOk.currentRow).url;
            }
            Text {
                id: name
                text: flickerModel.get(tableOk.currentRow).description
                styleColor: "#e93d3d"
                padding: 3
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideNone
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
            }
        }
    }


    C.StatusBar{
        x: 0
        width: parent.width
        anchors.top: splitviewParent.bottom
        anchors.topMargin: -2
        anchors.bottomMargin: 0
        transformOrigin: Item.Center
        anchors.bottom:parent.bottom
        RowLayout {
            id: rowLayout
            anchors.fill: parent

            Label{
                text: imageText.source
                fontSizeMode: Text.HorizontalFit
                Layout.fillWidth: true
                wrapMode: Text.NoWrap
                width:300
                elide: "ElideMiddle"
                id:lblDesc
            }

            ProgressBar {
                id: progressBar
                Layout.fillHeight: true
                Layout.fillWidth: false
                value: imageText.progress
            }
        }
    }

    //namespaces are very important here i spent 4 hrs because of invalid namespace so please be careful

    XmlListModel{
        id:flickerModel
        source: "https://www.cnet.com/rss/"+txtSearch.text+"/"
        query: "/rss/channel/item"
        namespaceDeclarations: "declare namespace media = 'http://search.yahoo.com/mrss/';"
        XmlRole {name:"title" ; query:"title/string()"}
        XmlRole {name:"date" ; query:"pubDate/string()"}
        XmlRole {name:"url" ; query:"media:thumbnail/@url/string()"}
        XmlRole {name:"description" ; query:"description/string()" }

        // media:content/@url/string()
    }
}
