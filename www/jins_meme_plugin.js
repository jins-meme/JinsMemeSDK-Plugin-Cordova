var argscheck = require('cordova/argscheck'),
    exec = require('cordova/exec');
var JinsMemePlugin = {};

/**
 * Error code.
 */
JinsMemePlugin.ERROR = {
    INIT_FAIL: -100,
    NOT_INIT: -101,
    SCANNING: -102,
    NOT_CONNECTED: -103
};

/**
 * MemeStatus code.
 */
JinsMemePlugin.STATUS = {
    OK              : 0,
    ERROR           : 1,
    ERROR_SDK_AUTH  : 2,
    ERROR_APP_AUTH  : 3,
    ERROR_CONNECTION: 4,
    DEVICE_INVALID  : 5,
    CWD_INVALID     : 6,
    ERROR_FW_CHECK  : 7,
    ERROR_BL_OFF    : 8,
    UNKNOWN         : -1
};

/**
 * MemeCalibStatus code.
 */
JinsMemePlugin.CALIB = {
    NOT_FINISHED : 0,
    BODY_FINISHED: 1,
    EYE_FINISHED : 2,
    BOTH_FINISHED: 3,
    UNKNOWN      : -1 
};

/**
 * Authentication and authorization of App and SDK.
 * Must call this method at first.
 *
 * @param {String} appClientId
 * @param {String} clientSecret
 * @param {Function} success
 * @param {Function} error 
 * @example
 *    JinsMemePlugin.setAppClientID('...', '...', function() {
 *        // do some actions.
 *    }, function(error) {
 *        // handle error
 *    });
 */
JinsMemePlugin.setAppClientID = function(appClientId, clientSecret, success, error) {
    argscheck.checkArgs('ssff', 'JinsMemePlugin.setAppClientID', arguments);
    exec(success, error, 'JinsMemePlugin', 'setAppClientID', [appClientId, clientSecret]);
};

/**
 * Starts scanning JINS MEME.
 *
 * @param {Function} success function(String) {}
 * @param {Function} error
 * @example
 *    JinsMemePlugin.startScan(function(foundItem) {
 *        // this method is always called when a device is found
 *    }, function(error) {
 *        // error.code
 *        // error.message
 *    });
 */
JinsMemePlugin.startScan = function(success, error) {
    argscheck.checkArgs('ff', 'JinsMemePlugin.startScan', arguments);
    exec(success, error, 'JinsMemePlugin', 'startScan', []);
};

/**
 * Stops scanning JINS MEME.
 *
 * @param {Function} success
 * @param {Function} error function(Object) {}
 * @example
 *    JinsMemePlugin.stopScan(function() {
 *        // do some actions.
 *    }, function(error) {
 *        // error.code
 *        // error.message
 *    });
 */
JinsMemePlugin.stopScan = function(success, error) {
    argscheck.checkArgs('ff', 'JinsMemePlugin.stopScan', arguments);
    exec(success, error, 'JinsMemePlugin', 'stopScan', []);
};

/**
 * Establishes connection to JINS MEME.
 *
 * @param {String} target Android=MAC address, iOS=UUID 
 * @param {Function} connectCallback 
 * @param {Function} disconnectCallback 
 * @param {Function} error function(Object) {}
 * @example
 *    JinsMemePlugin.connect('1.1.1.1', function() {
 *        // called when connected
 *    }, function() {
 *        // called when disconnected
 *    }, function(error) {
 *        // error.code
 *        // error.message
 *    });
 */
JinsMemePlugin.connect = function(target, connectCallback, disconnectCallback, error) {
    argscheck.checkArgs('sfff', 'JinsMemePlugin.connect', arguments);
    exec(function(data) {
        if ('undefined' === typeof data) {
            return;
        }

        if (target !== data.target) {
            return;
        }

        var status = Number(data.status);

        if (1 === status) {
            connectCallback.apply(null, []);
        } else if (0 === status) {
            disconnectCallback.apply(null, []);
        }
    }, error, 'JinsMemePlugin', 'connect', [target]);
};

/**
 * Set auto connection. 
 *
 * @param {Boolean} flag
 * @param {Function} success (OPTIONAL)
 * @param {Function} error function(error) {} (OPTIONAL)
 */
JinsMemePlugin.setAutoConnect = function(flag, success, error) {
    argscheck.checkArgs('*FF', 'JinsMemePlugin.setAutoConnect', arguments);
    exec(success, error, 'JinsMemePlugin', 'setAutoConnect', [flag ? true : false]);
};

/**
 * Returns whether a connection to JINS MEME has been established.
 *
 * @param {Function} success function(Boolean) {}
 * @param {Function} error function(error) {} (OPTIONAL)
 */
JinsMemePlugin.isConnected = function(success, error) {
    argscheck.checkArgs('fF', 'JinsMemePlugin.isConnected', arguments);
    exec(function(data) {
        success.apply(null, [!!data])
    }, error, 'JinsMemePlugin', 'isConnected', []);
};

/**
 * Disconnects from JINS MEME.
 *
 * @param {Function} success (OPTIONAL)
 * @param {Function} error function(error) {} (OPTIONAL)
 */
JinsMemePlugin.disconnect = function(success, error) {
    argscheck.checkArgs('FF', 'JinsMemePlugin.disconnect', arguments);
    exec(success, error, 'JinsMemePlugin', 'disconnect', []);
};

/**
 * Starts receiving realtime data.
 *
 * @param {Function} success function(Object) {}
 * @param {Function} error function(error) {} (OPTIONAL)
 * @example
 *    JinsMemePlugin.startDataReport(function(data) {
 *        // this method is called some times.
 *        // data = MemeRealtimeData
 *    });
 */
JinsMemePlugin.startDataReport = function(success, error) {
    argscheck.checkArgs('fF', 'JinsMemePlugin.startDataReport', arguments);
    exec(success, error, 'JinsMemePlugin', 'startDataReport', []);
};

/**
 * Stops receiving data.
 *
 * @param {Function} success (OPTIONAL)
 * @param {Function} error function(error) {} (OPTIONAL)
 */
JinsMemePlugin.stopDataReport = function(success, error) {
    argscheck.checkArgs('FF', 'JinsMemePlugin.stopDataReport', arguments);
    exec(success, error, 'JinsMemePlugin', 'stopDataReport', []);
};

/**
 * Returns SDK version.
 *
 * @param {Function} success function(String) {}
 * @param {Function} error function(error) {} (OPTIONAL)
 */
JinsMemePlugin.getSDKVersion = function(success, error) {
    argscheck.checkArgs('fF', 'JinsMemePlugin.getSDKVersion', arguments);
    exec(success, error, 'JinsMemePlugin', 'getSDKVersion', []);
};

/**
 * Returns JINS MEME connected with other apps.
 *
 * @param {Function} success function(Array) {}
 * @param {Function} error function(error) {} (OPTIONAL)
 * @example
 *    JinsMemePlugin.startDataReport(function(items) {
 *        // items = ['found1', 'found2', ...]
 *    });
 */
JinsMemePlugin.getConnectedByOthers = function(success, error) {
    argscheck.checkArgs('fF', 'JinsMemePlugin.getConnectedByOthers', arguments);
    exec(success, error, 'JinsMemePlugin', 'getConnectedByOthers', []);
};

/**
 * Returns calibration status.
 *
 * @param {Function} success function(Number) {}
 * @param {Function} error function(error) {} (OPTIONAL)
 */
JinsMemePlugin.isCalibrated = function(success, error) {
    argscheck.checkArgs('fF', 'JinsMemePlugin.isCalibrated', arguments);
    exec(success, error, 'JinsMemePlugin', 'isCalibrated', []);
};

/**
 * Returns device type.
 *
 * @param {Function} success function(Number) {}
 * @param {Function} error function(error) {} (OPTIONAL)
 */
JinsMemePlugin.getConnectedDeviceType = function(success, error) {
    argscheck.checkArgs('fF', 'JinsMemePlugin.getConnectedDeviceType', arguments);
    exec(success, error, 'JinsMemePlugin', 'getConnectedDeviceType', []);
};

/**
 * Returns hardware version.
 *
 * @param {Function} success function(Number) {}
 * @param {Function} error function(error) {} (OPTIONAL)
 */
JinsMemePlugin.getConnectedDeviceSubType = function(success, error) {
    argscheck.checkArgs('fF', 'JinsMemePlugin.getConnectedDeviceSubType', arguments);
    exec(success, error, 'JinsMemePlugin', 'getConnectedDeviceSubType', []);
};

/**
 * Returns FW Version.
 *
 * @param {Function} success function(String) {}
 * @param {Function} error function(error) {} (OPTIONAL)
 */
JinsMemePlugin.getFWVersion = function(success, error) {
    argscheck.checkArgs('fF', 'JinsMemePlugin.getFWVersion', arguments);
    exec(success, error, 'JinsMemePlugin', 'getFWVersion', []);
};

/**
 * Returns HW Version.
 *
 * @param {Function} success function(Number) {}
 * @param {Function} error function(error) {} (OPTIONAL)
 */
JinsMemePlugin.getHWVersion = function(success, error) {
    argscheck.checkArgs('fF', 'JinsMemePlugin.getHWVersion', arguments);
    exec(success, error, 'JinsMemePlugin', 'getHWVersion', []);
};

/**
 * Returns response about whether data was received or not.
 *
 * @param {Function} success function(Boolean) {}
 * @param {Function} error function(error) {} (OPTIONAL)
 */
JinsMemePlugin.isDataReceiving = function(success, error) {
    argscheck.checkArgs('fF', 'JinsMemePlugin.isDataReceiving', arguments);
    exec(function(data) {
         success.apply(null, [!!data])
     }, error, 'JinsMemePlugin', 'isDataReceiving', []);
};

module.exports = JinsMemePlugin;
