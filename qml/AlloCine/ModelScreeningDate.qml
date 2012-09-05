// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
XmlListModel {
    property string theaterCode
    property string movieCode
    property string versionCode
    property string screenFormatCode
    query: "//feed/theaterShowtimes[place/theater/@code/string()=\""+theaterCode+"\"]/movieShowtimesList/movieShowtimes[onShow/movie/@code/string()='"+movieCode+"'and version/@code/string()='"+versionCode+"' and screenFormat/@code/string()='"+screenFormatCode+"']/screenings/scr"
    namespaceDeclarations: "declare default element namespace 'http://www.allocine.net/v6/ns/';"
    XmlRole { name: "date"; query: '@d/string()' }
    Component.onCompleted:
    {
        if(screenFormatCode=="")
            query="//feed/theaterShowtimes[place/theater/@code/string()=\""+theaterCode+"\"]/movieShowtimesList/movieShowtimes[onShow/movie/@code/string()='"+movieCode+"'and version/@code/string()='"+versionCode+"']/screenings/scr"
        console.debug("theaterCode="+theaterCode+" movieCode="+movieCode+ " versionCode="+versionCode+ " screenFormatCode="+screenFormatCode)
    }
}
