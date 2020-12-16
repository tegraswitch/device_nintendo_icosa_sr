/*
 * Copyright (C) 2020 The LineageOS Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.lineageos.settings.device;

import android.app.Service;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.graphics.Point;
import android.os.IBinder;
import android.os.Parcel;
import android.os.RemoteException;
import android.os.ServiceManager;
import android.util.Log;
import android.view.IWindowManager;
import android.view.WindowManagerPolicyConstants;

import com.nvidia.NvAppProfiles;
import com.nvidia.NvConstants;

public class DockService extends Service {
    private static final String TAG = DockService.class.getSimpleName();
    private static final String SURFACE_COMPOSER_INTERFACE_KEY = "android.ui.ISurfaceComposer";
    private static final String SURFACE_FLINGER_SERVICE_KEY = "SurfaceFlinger";
    private static final String NVCPL_SERVICE_KEY = "nvcpl";
    private static final int SURFACE_FLINGER_READ_CODE = 1010;
    private static final int SURFACE_FLINGER_DISABLE_OVERLAYS_CODE = 1008;

    final private Receiver mReceiver = new Receiver();
    final private NvAppProfiles mAppProfiles = new NvAppProfiles(this);
    private IBinder mSurfaceFlinger;
    private IWindowManager mWindowManager;

    @Override
    public IBinder onBind(Intent intent) {
        // We don't provide binding, so return null
        return null;
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        mSurfaceFlinger = ServiceManager.getService(SURFACE_FLINGER_SERVICE_KEY);
        mWindowManager = IWindowManager.Stub.asInterface(ServiceManager.getService(Context.WINDOW_SERVICE));
        mReceiver.init();

        return super.onStartCommand(intent, flags, startId);
    }

    final class Receiver extends BroadcastReceiver {
        private boolean mExternalDisplayConnected = false;
        private boolean mPreviousOverlayDisabled = false;

        private void updatePowerState(Context context, boolean connected) {
            SharedPreferences sharedPrefs = context.getSharedPreferences("org.lineageos.settings.device_preferences", context.MODE_PRIVATE);
            final boolean perfMode = sharedPrefs.getBoolean("perf_mode", false);

            if (perfMode) {
                if (connected) {
                    mAppProfiles.setPowerMode(NvConstants.NV_POWER_MODE_MAX_PERF);
                    Log.i(TAG, "HDMI state update3");
                } else {
                    mAppProfiles.setPowerMode(NvConstants.NV_POWER_MODE_OPTIMIZED);
                    Log.i(TAG, "HDMI state update2");
                }
            } else {
                if (connected) {
                    mAppProfiles.setPowerMode(NvConstants.NV_POWER_MODE_OPTIMIZED);
                    Log.i(TAG, "HDMI state update1");
                } else {
                    mAppProfiles.setPowerMode(NvConstants.NV_POWER_MODE_BATTERY_SAVER);
                    Log.i(TAG, "HDMI state update");
                }
            }
        }

        private void updateOverlayState(boolean connected) {
            final boolean desiredOverlayState = connected || mPreviousOverlayDisabled;

            try {
                if (connected) {
                    // Save old state if newly docked
                    final Parcel data = Parcel.obtain();
                    final Parcel reply = Parcel.obtain();
                    data.writeInterfaceToken(SURFACE_COMPOSER_INTERFACE_KEY);
                    mSurfaceFlinger.transact(SURFACE_FLINGER_READ_CODE, data, reply, 0);
                    @SuppressWarnings("unused") final int showCpu = reply.readInt();
                    @SuppressWarnings("unused") final int enableGL = reply.readInt();
                    @SuppressWarnings("unused") final int showUpdates = reply.readInt();
                    @SuppressWarnings("unused") final int showBackground = reply.readInt();
                    mPreviousOverlayDisabled = (reply.readInt() == 1);
                    reply.recycle();
                    data.recycle();
                }

                final Parcel sendData = Parcel.obtain();
                sendData.writeInterfaceToken(SURFACE_COMPOSER_INTERFACE_KEY);
                sendData.writeInt(desiredOverlayState ? 1 : 0);
                mSurfaceFlinger.transact(SURFACE_FLINGER_DISABLE_OVERLAYS_CODE, sendData, null, 0);
                sendData.recycle();
            } catch (RemoteException ex) {
                Log.w(TAG, "Failed to update HW overlay state");
            }
        }

        public void init() {
            IntentFilter filter = new IntentFilter();

            filter.addAction(WindowManagerPolicyConstants.ACTION_HDMI_PLUGGED);
            filter.addAction(Intent.ACTION_SCREEN_ON);
            filter.addAction(DisplayUtils.POWER_UPDATE_INTENT);

            registerReceiver(this, filter);
        }

        @Override
        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction();

            switch (action) {
                case WindowManagerPolicyConstants.ACTION_HDMI_PLUGGED:
                    Log.i(TAG, "HDMI state update");

                    mExternalDisplayConnected = intent.getBooleanExtra(WindowManagerPolicyConstants.EXTRA_HDMI_PLUGGED_STATE, false);

                    // Force docked display size to avoid apps being forced to the resolution of the internal panel
                    try {
						if (mExternalDisplayConnected) {
							Point displaySize = new Point();
							mWindowManager.getBaseDisplaySize(1, displaySize);
							mWindowManager.setForcedDisplaySize(0, displaySize.y, displaySize.x);
						} else {
							mWindowManager.clearForcedDisplaySize(0);
						}
                    } catch (RemoteException ex) {
                        Log.w(TAG, "Failed to set display resolution");
                    }

                    // Disable HW overlays on dock as they are broken in HWC
                    updateOverlayState(mExternalDisplayConnected);

                    updatePowerState(context, mExternalDisplayConnected);

                case Intent.ACTION_SCREEN_ON:
                    Log.i(TAG, "Screen on");
                    DisplayUtils.setInternalDisplayState(!mExternalDisplayConnected);

                    // Unlock device automatically if docked
                    try {
                        if (mExternalDisplayConnected) {
                            mWindowManager.dismissKeyguard(null, null);
                        }
                    } catch (Exception ex) {
                        Log.w(TAG, "Failed to dismiss keyguard");
                    }
                    break;
                case DisplayUtils.POWER_UPDATE_INTENT:
                    updatePowerState(context, mExternalDisplayConnected);
                    break;
                default:
                    break;
            }
        }
    }
}
