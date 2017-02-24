package com.jins_jp.meme.plugin;

import com.jins_jp.meme.MemeCalibStatus;
import com.jins_jp.meme.MemeRealtimeData;
import com.jins_jp.meme.MemeStatus;

import org.json.JSONException;
import org.json.JSONObject;

/**
 * JINS MEME SDK Plugin util.
 */
class Message {
    /**
     * Get error object.
     *
     * @param code error code
     * @param message error message
     * @return error json object
     */
    static JSONObject getError(final int code, final String message) {
        JSONObject error = new JSONObject();

        try {
            error.put("code", code);
            error.put("message", message);
        } catch (JSONException e) {
            e.printStackTrace(); // Never come here.
        }

        return error;
    }

    /**
     * Get error object.
     *
     * @param status MemeStatus
     * @return error json object
     */
    static JSONObject getError(final MemeStatus status) {
        return getError(getMemeStatusCode(status), getMemeStatusMessage(status));
    }

    /**
     * Convert boolean into integer.
     *
     * @param data some boolean value
     * @return 1: true, 0: false
     */
    static int covertToInt(final boolean data) {
        return data ? 1 : 0;
    }

    /**
     * Convert MemeRealtimeData into JSON object.
     *
     * @param memeRealtimeData JINS MEME real time data
     * @return json object
     */
    static JSONObject covertToJSONObject(final MemeRealtimeData memeRealtimeData) throws JSONException {
        JSONObject data = new JSONObject();

        data.put("eyeMoveUp", memeRealtimeData.getEyeMoveUp());
        data.put("eyeMoveDown", memeRealtimeData.getEyeMoveDown());
        data.put("eyeMoveLeft", memeRealtimeData.getEyeMoveLeft());
        data.put("eyeMoveRight", memeRealtimeData.getEyeMoveRight());
        data.put("blinkSpeed", memeRealtimeData.getBlinkSpeed());
        data.put("blinkStrength", memeRealtimeData.getBlinkStrength());
        data.put("walking", memeRealtimeData.isWalking());
        data.put("roll", memeRealtimeData.getRoll());
        data.put("pitch", memeRealtimeData.getPitch());
        data.put("yaw", memeRealtimeData.getYaw());
        data.put("accX", memeRealtimeData.getAccX());
        data.put("accY", memeRealtimeData.getAccY());
        data.put("accZ", memeRealtimeData.getAccZ());
        data.put("noiseStatus", memeRealtimeData.isNoiseStatus());
        data.put("fitError", memeRealtimeData.getFitError());
        data.put("powerLeft", memeRealtimeData.getPowerLeft());

        return data;
    }

    /**
     * Get MemeStatus code as integer.
     * The codes must be as same as ones used in iOS plugin.
     *
     * @param status MemeStatus
     * @return error code
     */
    private static int getMemeStatusCode(final MemeStatus status) {
        if (MemeStatus.MEME_OK == status) {
            return 0;
        } else if (MemeStatus.MEME_ERROR == status) {
            return 1;
        } else if (MemeStatus.MEME_ERROR_SDK_AUTH == status) {
            return 2;
        } else if (MemeStatus.MEME_ERROR_APP_AUTH == status) {
            return 3;
        } else if (MemeStatus.MEME_ERROR_CONNECTION == status) {
            return 4;
        } else if (MemeStatus.MEME_DEVICE_INVALID == status) {
            return 5;
        } else if (MemeStatus.MEME_CMD_INVALID == status) {
            return 6;
        } else if (MemeStatus.MEME_ERROR_FW_CHECK == status) {
            return 7;
        } else if (MemeStatus.MEME_ERROR_BL_OFF == status) {
            return 8;
        } else {
            return -1; // Never come here.
        }
    }

    /**
     * Get MemeStatus message.
     *
     * @param status MemeStatus
     * @return error message
     */
    private static String getMemeStatusMessage(final MemeStatus status) {
        if (MemeStatus.MEME_OK == status) {
            return "App successfully authenticated, connection to JINS MEME established";
        } else if (MemeStatus.MEME_ERROR == status) {
            return "Error issuing command to JINS MEME";
        } else if (MemeStatus.MEME_ERROR_SDK_AUTH == status) {
            return "SDK authentication error";
        } else if (MemeStatus.MEME_ERROR_APP_AUTH == status) {
            return "App authentication error";
        } else if (MemeStatus.MEME_ERROR_CONNECTION == status) {
            return "Failure establishing connection to JINS MEME";
        } else if (MemeStatus.MEME_DEVICE_INVALID == status) {
            return "Error logical";
        } else if (MemeStatus.MEME_CMD_INVALID == status) {
            return "Not permitted to run command";
        } else if (MemeStatus.MEME_ERROR_FW_CHECK == status) {
            return "MEME firmware is not up to date";
        } else if (MemeStatus.MEME_ERROR_BL_OFF == status) {
            return "Bluetooth is not enabled";
        } else {
            return "Unknown"; // Never come here.
        }
    }

    /**
     * Get MemeCalibStatus code as integer.
     * The codes must be as same as ones used in iOS plugin.
     *
     * @param status MemeCalibStatus
     * @return calib status code
     */
    static int getMemeCalibStatusCode(final MemeCalibStatus status) {
        if (MemeCalibStatus.CALIB_NOT_FINISHED == status) {
            return 0;
        } else if (MemeCalibStatus.CALIB_BODY_FINISHED == status) {
            return 1;
        } else if (MemeCalibStatus.CALIB_EYE_FINISHED == status) {
            return 2;
        } else if (MemeCalibStatus.CALIB_BOTH_FINISHED == status) {
            return 3;
        } else {
            return -1; // Never come here.
        }
    }

    /**
     * Get connection status JSON object.
     *
     * @param address
     * @param connectionStatus
     * @return connection json object
     */
    static JSONObject getConnectionData(final String address, final int connectionStatus) {
        JSONObject data = new JSONObject();

        try {
            data.put("target", address);
            data.put("status", connectionStatus);
        } catch (JSONException e) {
            e.printStackTrace();
        }

        return data;
    }
}
