// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item {
    id:root
    property url source
    property bool loading:false
    property bool error:false
    property string responseText

    onLoadingChanged: console.debug("APICaller loading=" + loading)
    onErrorChanged: console.debug("APICaller error=" + loading)

    function call(){
        error=false
        loading=true
        var file = new XMLHttpRequest();
        file.onreadystatechange = function() {
            if (file.readyState === XMLHttpRequest.DONE) {
                //console.debug("XMLHttpRequest.DONE")
                if(file.status === 200){
                    responseText = file.responseText
                    root.loading=false
                }else{
                    root.error=true;
                    root.loading=false
                }
                //console.debug("file status= " + file.status)
            }
            if (file.readyState === XMLHttpRequest.LOADING) {
                //console.debug("XMLHttpRequest.LOADING")
                root.loading=true
            }
            if (file.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
                //console.debug("XMLHttpRequest.HEADERS_RECEIVED")
                root.loading=true
            }
            if (file.readyState === XMLHttpRequest.UNSENT) {
                //console.debug("XMLHttpRequest.UNSENT")
                root.loading=true
            }
            if (file.readyState === XMLHttpRequest.OPENED) {
                //console.debug("XMLHttpRequest.OPENED")
                root.loading=true
            }
            //console.debug("file readyState= " + file.readyState)


        }
        file.open("GET", source);
        file.send();
    }

    onSourceChanged: {
        console.log(source)
        call()
    }
}
