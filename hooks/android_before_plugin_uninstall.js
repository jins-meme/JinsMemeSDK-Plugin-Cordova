var fs = require('fs');
var path = require('path');
var manifestPath = path.resolve(__dirname + '/../../../platforms/android/AndroidManifest.xml');
var saveFilePath = path.resolve(__dirname + '/original_version');
var sdkVersion = 23;

module.exports = function(context) {
    var Q = context.requireCordovaModule("q");
    var deferral = new Q.defer();

    console.log('Read: ' + saveFilePath);
    fs.readFile(saveFilePath, 'utf8', function (err, text) {
        if (err) {
            console.log('No original version');
        } else {
            console.log('Detect original version: ' + text);
            sdkVersion = Number(text);

            if (!sdkVersion) {
                sdkVersion = 23;
            }
        }

        console.log('Read: ' + manifestPath);
        fs.readFile(manifestPath, 'utf8', function (err, text) {
            if (err || !text) {
                console.log('No AndroidManifext.xml');
                deferral.resolve();
                return;
            }
     
            var regex = /android:targetSdkVersion="([0-9]+)"/;
            var replaced = text.replace(regex, 'android:targetSdkVersion="' + sdkVersion + '"');
        
            fs.writeFile(manifestPath, replaced, function (err) {
                if (err) {
                    console.log('Failed to rewrite: ' + manifestPath);
                } else {
                    console.log('Change android:targetSdkVersion');
                }

                deferral.resolve();
            });
        });
    });
};

