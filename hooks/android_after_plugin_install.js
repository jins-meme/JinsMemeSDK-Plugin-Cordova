var fs = require('fs');
var path = require('path');
var manifestPath = path.resolve(__dirname + '/../../../platforms/android/AndroidManifest.xml');
var saveFilePath = path.resolve(__dirname + '/original_version');

module.exports = function(context) {
    var Q = context.requireCordovaModule("q");
    var deferral = new Q.defer();

    console.log('Read: ' + manifestPath);
    fs.readFile(manifestPath, 'utf8', function (err, text) {
        if (err) {
            console.log('Failed to read: ' + manifestPath);
            deferral.reject("JINS MEME SDK - android_after_plugin_install: " + JSON.stringify(err));
            return;
        }
 
        if (!text) {
            console.log('No content: ' + manifestPath);
            deferral.reject("JINS MEME SDK - android_after_plugin_install: no manifest file");
          return;
        }

        var regex = /android:targetSdkVersion="([0-9]+)"/;
        var matched = regex.exec(text);

        if (!matched) {
            deferral.resolve();
            return;
        }

        fs.writeFile(saveFilePath, matched[1], function() {
            var replaced = text.replace(regex, 'android:targetSdkVersion="22"');

            fs.writeFile(manifestPath, replaced, function (err) {
                if (err) {
                    console.log('Failed to rewrite: ' + manifestPath);
                    deferral.reject("JINS MEME SDK - android_after_plugin_install: " + JSON.stringify(err));
                } else {
                    console.log('Change android:targetSdkVersion');
                    deferral.resolve();
                }
            });
        });
    });
};

