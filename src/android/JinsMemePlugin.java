package com.jins_jp.meme.plugin;

import android.content.Context;
import android.os.AsyncTask;

import com.jins_jp.meme.MemeConnectListener;
import com.jins_jp.meme.MemeLib;
import com.jins_jp.meme.MemeRealtimeData;
import com.jins_jp.meme.MemeRealtimeListener;
import com.jins_jp.meme.MemeScanListener;
import com.jins_jp.meme.MemeStatus;

import org.apache.cordova.BuildConfig;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.PluginResult;

import org.json.JSONArray;
import org.json.JSONException;

import java.util.List;

/**
 * JINS MEME cordova plugin.
 */
public class JinsMemePlugin extends CordovaPlugin {
    /**
     * Error codes.
     */
    private static final int ERROR_INIT_FAIL = -100;
    private static final int ERROR_NOT_INIT = -101;
    private static final int ERROR_IS_SCANNING = -102;
    private static final int ERROR_NOT_CONNECTED = -103;

    /**
     * Is running on foreground.
     */
    private boolean mIsRunning = true;

    /**
     * Meme lib.
     */
    private MemeLib mMemeLib;

    /**
     * Scan listener.
     */
    private CallbackContext mScanCallback;

    /**
     * Data report listener.
     */
    private CallbackContext mDataReportCallback;

    /**
     * Connection handler.
     */
    private ConnectionHandler mConnectionHandler = new ConnectionHandler();

    /**
     * Main method called by JavaScript.
     *
     * @param action          The action to execute.
     * @param args            The exec() arguments.
     * @param callbackContext The callback context used when calling back into JavaScript.
     * @return
     * @throws JSONException
     */
    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        debug("execute " + action + ", " + args.toString());

        if (action.equals("setAppClientID")) {
            setAppClientId(cordova.getActivity().getApplicationContext(), args.getString(0), args.getString(1), callbackContext);
            return true;
        }

        // Check initialization of SDK.
        if (null == mMemeLib) {
            debug("no memeLib");
            callbackContext.error(Message.getError(ERROR_NOT_INIT, "Execute setAppClientId before calling " + action + "."));
            return true;
        }

        if (action.equals("startScan")) {
            startScan(mMemeLib, callbackContext);
            return true;
        } else if (action.equals("stopScan")) {
            stopScan(mMemeLib, callbackContext);
            return true;
        } else if (action.equals("connect")) {
            mConnectionHandler.connect(mMemeLib, args.getString(0), callbackContext);
            return true;
        } else if (action.equals("isConnected")) {
            callbackContext.success(Message.covertToInt(mMemeLib.isConnected()));
            return true;
        } else if (action.equals("disconnect")) {
            mConnectionHandler.disconnect(mMemeLib);
            callbackContext.success();
            return true;
        } else if (action.equals("setAutoConnect")) {
            mMemeLib.setAutoConnect(args.getBoolean(0));
            callbackContext.success();
            return true;
        } else if (action.equals("getSDKVersion")) {
            callbackContext.success(mMemeLib.getSDKVersion());
            return true;
        } else if (action.equals("isDataReceiving")) {
            callbackContext.success(Message.covertToInt(mMemeLib.isDataReceiving()));
            return true;
        }

        // Check connection to device.
        if (!mMemeLib.isConnected()) {
            debug("not connected");
            callbackContext.error(Message.getError(ERROR_NOT_CONNECTED, "Connect to device before calling " + action + "."));
            return true;
        }

        if (action.equals("startDataReport")) {
            startDataReport(mMemeLib, callbackContext);
            return true;
        } else if (action.equals("stopDataReport")) {
            stopDataReport(mMemeLib);
            callbackContext.success();
            return true;
        } else if (action.equals("getConnectedByOthers")) {
            getConnectedByOthers(mMemeLib, callbackContext);
            return true;
        } else if (action.equals("isCalibrated")) {
            callbackContext.success(Message.getMemeCalibStatusCode(mMemeLib.isCalibrated()));
            return true;
        } else if (action.equals("getConnectedDeviceType")) {
            callbackContext.success(mMemeLib.getConnectedDeviceType());
            return true;
        } else if (action.equals("getConnectedDeviceSubType")) {
            callbackContext.success(mMemeLib.getConnectedDeviceSubType());
            return true;
        } else if (action.equals("getFWVersion")) {
            callbackContext.success(mMemeLib.getFWVersion());
            return true;
        } else if (action.equals("getHWVersion")) {
            callbackContext.success(mMemeLib.getHWVersion());
            return true;
        }

        debug("no such a method");

        return false;
    }

    /**
     * Called when the activity will start interacting with the user.
     *
     * @param multitasking Flag indicating if multitasking is turned on for app
     */
    @Override
    public void onResume(boolean multitasking) {
        debug("onResume");
        mIsRunning = true;
        mConnectionHandler.onResume(mMemeLib);
    }

    /**
     * Called when the system is about to start resuming a previous activity.
     *
     * @param multitasking lag indicating if multitasking is turned on for app
     */
    @Override
    public void onPause(boolean multitasking) {
        debug("onPause");
        mIsRunning = false;
        mConnectionHandler.onPause(mMemeLib);
    }

    /**
     * Authentication and authorization of App and SDK.
     *
     * @param context
     * @param appClientId
     * @param clientSecret
     */
    private void setAppClientId(final Context context, final String appClientId, final String clientSecret, final CallbackContext callbackContext) {
        clearMemeLib();

        // MemeLib.setAppClientID() could communicate on the Internet.
        AsyncTask<Void, Void, Boolean> task = new AsyncTask<Void, Void, Boolean>() {
            @Override
            protected Boolean doInBackground(Void... params) {
                try {
                    MemeLib.setAppClientID(context, appClientId, clientSecret);
                    return true;
                } catch (Exception e) {
                    e.printStackTrace();
                    return false;
                }
            }

            @Override
            protected void onPostExecute(Boolean result) {
                if (result) {
                    mMemeLib = MemeLib.getInstance();
                    callbackContext.success();
                } else {
                    callbackContext.error(Message.getError(ERROR_INIT_FAIL, "Fail"));
                }
            }
        };
        task.execute();
    }

    /**
     * Clear mMemeLib.
     */
    private void clearMemeLib() {
        mConnectionHandler.clear();

        if (null == mMemeLib) {
            return;
        }

        stopScan(mMemeLib);
        stopDataReport(mMemeLib);
        mMemeLib.setMemeConnectListener(null);
        mMemeLib = null;
    }

    /**
     * Is available callback context.
     *
     * @param callbackContext
     * @return
     */
    private boolean isAvailable(final CallbackContext callbackContext) {
        return null != callbackContext && !callbackContext.isFinished();
    }

    /**
     * Starts scanning JINS MEME.
     *
     * @param memeLib
     * @param callbackContext
     */
    private void startScan(final MemeLib memeLib, final CallbackContext callbackContext) {
        if (memeLib.isScanning()) {
            callbackContext.error(Message.getError(ERROR_IS_SCANNING, "Now scanning."));
            return;
        }

        mScanCallback = callbackContext;
        MemeStatus status = memeLib.startScan(new MemeScanListener() {
            @Override
            public void memeFoundCallback(final String address) {
                cordova.getActivity().runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        if (mIsRunning && isAvailable(mScanCallback)) {
                            debug("Found " + address + ", and send it to JavaScript");
                            PluginResult result = new PluginResult(PluginResult.Status.OK, address);
                            result.setKeepCallback(true);
                            mScanCallback.sendPluginResult(result);
                        } else {
                            debug("Found " + address + ", running = " + mIsRunning + ", callback = " + isAvailable(mScanCallback));
                        }
                    }
                });
            }
        });

        if (MemeStatus.MEME_OK != status) {
            debug("Failed to start scan: " + status);
            mScanCallback = null;
            callbackContext.error(Message.getError(status));
        }
    }
    /**
     * Stops scanning JINS MEME.
     *
     * @param memeLib
     */
    private MemeStatus stopScan(final MemeLib memeLib) {
        mScanCallback = null;

        if (!memeLib.isScanning()) {
            return MemeStatus.MEME_OK;
        }

        return memeLib.stopScan();
    }

    /**
     * Stops scanning JINS MEME.
     *
     * @param memeLib
     * @param callbackContext
     */
    private void stopScan(final MemeLib memeLib, final CallbackContext callbackContext) {
        MemeStatus status = stopScan(memeLib);

        if (MemeStatus.MEME_OK == status) {
            callbackContext.success();
        } else {
            callbackContext.error(Message.getError(status));
        }
    }

    /**
     * Starts receiving realtime data.
     *
     * @param memeLib
     * @param callbackContext
     */
    private void startDataReport(final MemeLib memeLib, final CallbackContext callbackContext) {
        mDataReportCallback = callbackContext;

        MemeStatus status = memeLib.startDataReport(new MemeRealtimeListener() {
            @Override
            public void memeRealtimeCallback(final MemeRealtimeData memeRealtimeData) {
                cordova.getActivity().runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        if (mIsRunning && isAvailable(mDataReportCallback)) {
                            try {
                                PluginResult result = new PluginResult(PluginResult.Status.OK, Message.covertToJSONObject(memeRealtimeData));
                                result.setKeepCallback(true);
                                mDataReportCallback.sendPluginResult(result);
                            } catch (JSONException e) {
                                e.printStackTrace();
                            }
                        }
                    }
                });
            }
        });

        if (MemeStatus.MEME_OK != status) {
            debug("Failed to start data report: " + status);
            mDataReportCallback = null;
            callbackContext.error(Message.getError(status));
        }
    }

    /**
     * Stops receiving data.
     *
     * @param memeLib
     */
    private void stopDataReport(final MemeLib memeLib) {
        mDataReportCallback = null;

        if (memeLib.isDataReceiving()) {
            memeLib.stopDataReport();
        }
    }

    /**
     * Returns JINS MEME connected with other apps.
     *
     * @param memeLib
     * @param callbackContext
     */
    private void getConnectedByOthers(final MemeLib memeLib, final CallbackContext callbackContext) {
        // MemeLib.getConnectedByOthers uses BluetoothDeviceManager.
        AsyncTask<Void, Void, List<String>> task = new AsyncTask<Void, Void, List<String>>() {
            @Override
            protected List<String> doInBackground(Void... params) {
                return memeLib.getConnectedByOthers();
            }

            @Override
            protected void onPostExecute(List<String> data) {
                callbackContext.success(new JSONArray(data));
            }
        };
        task.execute();
    }

    /**
     * Debug.
     *
     * @param message
     */
    private void debug(final String message) {
        if (BuildConfig.DEBUG) {
            android.util.Log.d("JinsMemePlugin", message);
        }
    }

    /**
     *
     */
    private class ConnectionHandler {
        /**
         * Connection status codes.
         */
        private static final int CONNECTION_STATUS_DISCONNECT = 0;
        private static final int CONNECTION_STATUS_CONNECT = 1;

        /**
         * Is running on foreground.
         */
        private boolean mIsRunning = true;

        /**
         * Connection listener.
         */
        private CallbackContext mConnectCallback;

        /**
         * Connection address.
         */
        private String mAddress = null;

        /**
         * Previous connection status.
         */
        private boolean mPrevIsConnected = false;

        /**
         * onResume.
         */
        private synchronized void onResume(final MemeLib memeLib) {
            mIsRunning = true;

            if (null == memeLib) {
                return;
            } else if (!isAvailable(mConnectCallback)) {
                return;
            } else if (mPrevIsConnected == memeLib.isConnected()) {
                return;
            }

            sendConnectionData(
                    mAddress,
                    memeLib.isConnected() ? CONNECTION_STATUS_CONNECT : CONNECTION_STATUS_DISCONNECT,
                    mConnectCallback
            );
        }

        /**
         * onPause.
         */
        private synchronized void onPause(final MemeLib memeLib) {
            mIsRunning = false;

            if (null != memeLib) {
                mPrevIsConnected = memeLib.isConnected();
            }
        }

        /**
         * Establishes connection to JINS MEME.
         *
         * @param memeLib
         * @param address
         * @param callbackContext
         */
        private void connect(final MemeLib memeLib, final String address, final CallbackContext callbackContext) {
            if (null == memeLib) {
                return;
            }

            mAddress = address;
            mConnectCallback = callbackContext;
            mPrevIsConnected = false;

            memeLib.setMemeConnectListener(new MemeConnectListener() {
                @Override
                public void memeConnectCallback(boolean status) {
                    cordova.getActivity().runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            debug("Connected to " + address + ", isConnected = " + mMemeLib.isConnected());
                            sendConnectionData(address, CONNECTION_STATUS_CONNECT, callbackContext);
                        }
                    });
                }

                @Override
                public void memeDisconnectCallback() {
                    cordova.getActivity().runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            debug("Disconnected from " + address + ", isConnected = " + mMemeLib.isConnected());
                            sendConnectionData(address, CONNECTION_STATUS_DISCONNECT, callbackContext);
                        }
                    });
                }
            });
            MemeStatus status =  memeLib.connect(address);

            if (MemeStatus.MEME_OK != status) {
                debug("Failed to connect: " + status);
                mAddress = null;
                mConnectCallback = null;
                callbackContext.error(Message.getError(status));
                memeLib.setMemeConnectListener(null);
            }
        }

        /**
         * Disconnect.
         *
         * @param memeLib
         */
        private void disconnect(final MemeLib memeLib) {
            clear();

            if (null == memeLib) {
                return;
            }

            memeLib.disconnect();
        }

        /**
         * Clear data.
         */
        private void clear() {
            mAddress = null;
            mConnectCallback = null;
            mPrevIsConnected = false;
        }

        /**
         * Send connection data into JavaScript.
         *
         * @param address
         * @param status
         * @param callbackContext
         */
        private synchronized void sendConnectionData(final String address, final int status, final CallbackContext callbackContext)
        {
            if (!mIsRunning) {
                return;
            } else if (!isAvailable(callbackContext)) {
                return;
            }

            PluginResult result = new PluginResult(PluginResult.Status.OK, Message.getConnectionData(address, status));
            result.setKeepCallback(true);
            callbackContext.sendPluginResult(result);
        }
    }
}
