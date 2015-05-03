.pragma library

var db;
var DBHelper = {
    initialize: function(openDatabaseSync){
        if (typeof(db) === "undefined"){
            db = openDatabaseSync("tbclient", "", "Tieba Database", 1000000);
        }
    },
    clearTable: function(name){
        db.transaction(function(tx){
            try {
                tx.executeSql('DELETE FROM %1'.arg(name));
            } catch(e){
                console.log(JSON.stringify(e));
            }
        })
    },
    storeLikeForum: function(list){
        this.clearTable("LikeForum");
        list.forEach(function(value){
            var binding = [value.forum_id, value.forum_name, value.level_id];
            db.transaction(function(tx){
                tx.executeSql('INSERT OR REPLACE INTO LikeForum VALUES (?,?,?)',
                              binding);
            })
        })
    }
}

function sendMessage(message){
    var func = message.func;
    var param = message.param;

    if (DBHelper.hasOwnProperty(func)){
        DBHelper[func](param);
    }
}
