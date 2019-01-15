import QtQuick 2.0
import Sailfish.Silica 1.0
import QtWebKit 3.0
import "Component"
import "Base"
import "../js/main.js" as Script

MyPage {
    id: root
    objectName: "WebLoginPage";
    backNavigation :false;

    function s(){
        loading = false;
        signalCenter.showMessage(qsTr("Login success!"));
        pageStack.pop();
    }
    SilicaWebView {
          id: webview
          anchors.fill: parent
          url: 'https://wappass.baidu.com/passport'

          header: PageHeader {
              title: qsTr('Login')
          }

          onLoadingChanged: {
              if (loadRequest.status === WebView.LoadSucceededStatus){
                  console.log(loadRequest.url.toString())
                  if (loadRequest.url.toString().indexOf('wap.baidu.com/?uid') > 0){
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
})()"

}
