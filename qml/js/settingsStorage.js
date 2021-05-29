// settingsStorage.js

// Based on http://developer.nokia.com/community/wiki/How-to_create_a_persistent_settings_database_in_Qt_Quick_(QML)
// Use webarchive if this URL is broken
// Additional pointers here:
// https://fecub.wordpress.com/2016/01/08/save-your-qt-quick-app-settings-easily-with-localstorage/


// ~ Brief ~
// JS helper file to allow reading and writing of settings from a
// local DB. Settings themselves are explored more in SettingsPage.qml
// ````````````````````````


// Necessary import, allows access to openDatabaseSync
.import QtQuick.LocalStorage 2.0 as Storage

// A short helper function to get the database connection
function getDatabase() {
    return Storage.LocalStorage.openDatabaseSync("Neliapila", "1.0", "StorageDatabase", 100000);
}


// At the start of the application, we can initialize the settings table if it hasn't been created yet
function initialize() {
    var db = getDatabase();

    db.transaction(
        function(tx) {
            // Create the settings table if it doesn't already exist
            // If the table exists, this is skipped
            console.log("run initialize")
            tx.executeSql('CREATE TABLE IF NOT EXISTS settings(setting TEXT UNIQUE, value TEXT);');
            // Set default Board view to "All boards"
            tx.executeSql('INSERT OR IGNORE INTO settings VALUES ("ModelToDisplayOnNavipage",0);');
    });
}


// Write a setting into the database
function setSetting(setting, value) {
    // setting: string representing the setting name (eg: “username”)
    // value: string representing the value of the setting (eg: “myUsername”)
    var db = getDatabase();
    var res = "";

    db.transaction(function(tx) {
        var rs = tx.executeSql('INSERT OR REPLACE INTO settings VALUES (?,?);', [setting,value]);
            if (rs.rowsAffected > 0) {
                res = "OK";
            }
            else {
                res = "Error";
            }
        }
    );

    // The function returns “OK” if it was successful, or “Error” if it wasn't
    return res;
}


// Retrieve a setting from the database
function getSetting(setting, defaultValue) {
    var db = getDatabase();
    var res = "";

    try {
        db.transaction(function(tx) {
            var rs = tx.executeSql('SELECT value FROM settings WHERE setting=?;', [setting]);
    
            if (rs.rows.length > 0) {
                res = rs.rows.item(0).value;
            }
            else {
                res = defaultValue || "Unknown";
            }
      });
    } catch(error) {
        res = "error";
    }

  // We return “Unknown” if the setting was not found in the database
  // Handling error codes should be implemented in the future
  console.log(res)
    console.log(typeof(res))
  return res
}

function resetSettingsDB() {
    var db = getDatabase();

    db.transaction(
        function(tx) {
            // Drop the Settings table
            // Used for clearing user settings and testing reasons
            tx.executeSql('DROP TABLE IF EXISTS settings');
    });
}
