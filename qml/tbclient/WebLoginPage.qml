import QtQuick 2.0
import Sailfish.Silica 1.0
import QtWebKit.experimental 1.0
import QtWebKit 3.0
import "Component"
import "Base"
import "../js/main.js" as Script

MyPage {
    id: root
    property bool forceLogin: false;
    objectName: "WebLoginPage";
    backNavigation: false;
    property alias userAgent: webview.userAgent

    function s(){
        loading = false;
        signalCenter.showMessage(qsTr("Login success!"));
        pageStack.pop();
    }
    SilicaWebView {
          id: webview
          anchors.fill: parent
          url: 'https://wappass.baidu.com/passport'
          overridePageStackNavigation: true
          property string userAgent: "Mozilla/5.0 (Mobile Linux; U; like Android 4.4.3; Sailfish OS/2.0) AppleWebkit/535.19 (KHTML, like Gecko) Version/4.0 Mobile Safari/535.19"
          property bool _isScrolledToEnd: (webview.contentY + webview.height + 2) >= webview.contentHeight
          property bool _isScrolledToBeginning: webview.contentY <= 2
          property bool _isFinishedPanning: webview.atXBeginning && webview.atXEnd && !webview.moving
          experimental.temporaryCookies: true
          experimental.deviceWidth: webview.width
          experimental.deviceHeight: webview.height
          experimental.userAgent: userAgent
          anchors {
            topMargin: -Theme.paddingLarge
            top: root.top
            bottom: root.bottom
            left: root.left
            right: root.right
          }
          experimental.customLayoutWidth: {
            return root.width * Theme._webviewCustomLayoutWidthScalingFactor
            // // VK's Terms Of Service page doesn't render the same
            // // way as Facebook/Google/Twitter/OneDrive etc, because
            // // it doesn't respect the deviceWidth setting.
            // var urlStr = "" + url
            // if (urlStr.indexOf("vk.com/terms") > 0) {
            //     return root.width * Theme._webviewCustomLayoutWidthScalingFactor
            // }

            // // For other services, zoom in a bit to make things more readable
            // return root.width * 0.6
        }
          onLoadingChanged: {
              if (loadRequest.status === WebView.LoadSucceededStatus){
                  console.log(loadRequest.url.toString());
                  webview.experimental.evaluateJavaScript(root.setAgree, function(rs){});
                  // TODO
                  // http://tieba.baidu.com/f/user/json_userinfo
                  if (loadRequest.url.toString().indexOf('m.baidu.com/?uid') > 0 ||
                          loadRequest.url.toString().indexOf('wap.baidu.com/?uid') > 0
                          ){
                      webview.experimental.evaluateJavaScript(root.getUserInfoScript, function(rs){
                          if (rs && rs.name){
                              py.call('app.api.get_other_param', [rs.name], function(ret){
                                  if (ret){
                                      rs.BDUSS = ret.bduss;
                                      rs.id = ret.uid;
                                      rs.passwd = "";
                                      Script.weblogin(rs, s);
                                  }
                              })
                          }else{
                              notification.error(qsTr("Could not login. Please try again."))
                              pageStack.pop()
                          }
                      })
                  }else{
                      py.call('app.api.get_session_id_from_cookie', [], function(ret){
                            // 获取到bduss，重定向到用户界面
                            if(ret && webview.url != "https://m.baidu.com/?uid" ){
                                webview.url = "https://m.baidu.com/?uid";
                            }
                      })
                  }
              }
          }
      }

    property string getUserInfoScript: "(function(){
var userName = document.getElementsByClassName('login')[0].innerText;
var avatar = document.getElementsByClassName('head-icon')[0].src;
avatar = avatar.split('/')[1]
var res = {avatar: avatar, name: userName};
return res;
})()";

  property string setAgree: "(function(){
  document.getElementsByClassName('not-agree-icon')[0].click();
})()"

}
