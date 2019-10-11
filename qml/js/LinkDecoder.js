Qt.include("YoukuParser.js");

function linkActivated(link){
    var l = link.split(":");
    switch(l[0]){
    case "at":
        viewProfile(l[1]);
        break;
    case "img":
        viewImage(link.substring(4));
        break;
    case "link":
        decodeLink(link.substring(5));
        break;
    case "video":
        decodeLink(link.substring(6));
        break;
    }
}

function getQueryString(url,name) {
    var reg = new RegExp('(^|&)' + name + '=([^&]*)(&|$)', 'i');
    var r = url.match(reg);
    if (r != null) {
        return unescape(r[2]);
    }
    return null;
}

function decodeLink(url){
    if(url.match(/checkurl\?url\=/g)){
        //console.log("...openBrowser:"+url)
        url=url.replace("https://tieba.baidu.com/mo/q/checkurl?url=","");
        url=decodeURIComponent(url);
        url=url.substring(0,url.indexOf("&meta"))
        openBrowser(url);
    }else{
        var m = url.match(/(?:tieba|wapp).baidu.com\/(?:p\/|f\?.*z=|.*m\?kz=)(\d+)/);
        if (m) return enterThread({"threadId": m[1]});
        m = utility.hasForumName(url);
        if (m) return enterForum(m);

        url = utility.fixUrl(url);
        if (url.indexOf("youku.com") > 0){
            showMessage(qsTr("Loading video..."));
            query(url);
            return;
        }
        openBrowser(url);
    }
}
