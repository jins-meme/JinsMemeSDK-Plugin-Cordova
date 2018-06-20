package com.jins_jp.meme.plugin;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.concurrent.LinkedBlockingQueue;

/**
 * JINS MEME Real time mode Data Buffer
 */
class RtDataBuffer {
    /**
     * Buffer default size.
     */
    public static final int DEFAULT_SIZE = 12000;

    /**
     * Buffer min size.
     */
    private static final int MIN_SIZE = 0;

    /**
     * Buffer max size.
     */
    private static final int MAX_SIZE = 72000;

    /**
     * Buffer size.
     */
    private int mSize = DEFAULT_SIZE;

    /**
     * Buffer.
     */
    private LinkedBlockingQueue<JSONObject> mBuffer = new LinkedBlockingQueue<JSONObject>();

    /**
     * Available or not.
     */
    private boolean mAvailable = false;

    /**
     * Set availability.
     *
     * @param available
     */
    public synchronized void setAvailable(final boolean available) {
        mAvailable = available;

        if (!mAvailable) {
            this.clear();
        }
    }

    /**
     * Set buffer size.
     *
     * @param size
     */
    public synchronized void setSize(final int size) {
        mSize = this.formatSize(size);

        if (mBuffer.size() > 0) {
            mBuffer.clear();
        }
    }

    /**
     * Get buffer size.
     *
     * @return
     */
    public synchronized int getSize() {
        return mBuffer.size();
    }

    /**
     * Format size.
     *
     * @param size raw size
     * @return formatted size
     */
    private int formatSize(final int size) {
        if (size < MIN_SIZE) {
            return MIN_SIZE;
        } else if (size > MAX_SIZE) {
            return MAX_SIZE;
        }

        return size;
    }

    /**
     * Put data.
     *
     * @param data
     * @return
     */
    public JSONObject put(final JSONObject data) throws InterruptedException, JSONException {
        if (!this.mAvailable) {
            return null;
        }

        JSONObject polledData = null;

        if (mBuffer.size() >= mSize) {
            polledData = mBuffer.poll();
        }

        data.put("isBackground", true);
        mBuffer.put(data);

        return polledData;
    }

    /**
     * Take data.
     *
     * @return
     */
    public JSONObject poll() throws InterruptedException {
        return mBuffer.poll();
    }

    /**
     * Clear data.
     */
    public void clear() {
        mBuffer.clear();
    }
}
