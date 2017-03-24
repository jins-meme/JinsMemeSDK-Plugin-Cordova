# JINS MEME SDK Cordova Plugin

## プラグイン構造 · Plug-in structure

```
├── README.md                              # This document · 本文書 · 
├── hooks
│   ├── android_after_plugin_install.js    # インストール時フックスクリプト(Android)
│   ├── android_before_plugin_uninstall.js # アンインストール時フックスクリプト(Android)
│   └── ios_after_plugin_install.js        # インストール時フックスクリプト(iOS)
├── node_modules                           # 依存するnodejsモジュール群(iOS)
│   └── ...
├── plugin.xml                             # Cordovaプラグイン定義ファイル
├── src
│   ├── android                            # Androidソースコード一式
│   │   ├── JinsMemePlugin.java
│   │   ├── MemeLib.jar
│   │   └── Message.java
│   └── ios                                # iOSソースコード一式
│       ├── JinsMemeMessage.h
│       ├── JinsMemeMessage.m
│       ├── JinsMemePlugin.m
│       └── MEMELib.framework
└── www
    └── jins_meme_plugin.js                # Cordova interface · JavaScriptインタフェース · 
```

## JavaScript API

### エラーオブジェクト · Error codes

#### 構造 · Error structure

* JSONオブジェクトでエラーcodeとmessageを返す · Example JSON error object

```json
    {
        code: -100,
        message: "some message" 
    }
```

#### エラーコード · Error codes

* プラグイン独自 · Connection status

```
初期化失敗 · Initialization failure : -100
未初期化 · Uninitialized            : -101
スキャン中 · Scanning in progress     : -102
未接続  · Disconnected              : -103
```

* MemeStatus

```
OK                   : 0
ERROR                : 1
ERROR_SDK_AUTH       : 2
ERROR_APP_AUTH       : 3
MEME_ERROR_CONNECTION: 4
MEME_ERROR_LOGICAL   : 5  # Android (MEME_DEVICE_INVALIDと同じ意味)
MEME_DEVICE_INVALID  : 5  # iOS (MEME_ERROR_LOGICALと同じ意味)
MEME_CMD_INVALID     : 6
MEME_ERROR_FW_CHECK  : 7
MEME_ERROR_BL_OFF    : 8
その他(UNKNOWN)       :-1
```

### CalibStatus

* isCalibStatusで取得した値を以下の数値に変換して返す · isCalibStatus returns the following codes:

```
CALIB_NOT_FINISHED : 0
CALIB_BODY_FINISHED: 1
CALIB_EYE_FINISHED : 2
CALIB_BOTH_FINISHED: 3
UNKNOWN            :-1  # その他
```

### Reported Data

* JSONオブジェクトでデータを返す · JSON object returned from startDataReport

```json
{
    eyeMoveUp: 0,
    eyeMoveDown: 0,
    eyeMoveLeft: 0,
    eyeMoveRight: 0,
    blinkSpeed: 0,
    blinkStrength: 0,
    walking: 0,
    roll: 0,
    pitch: 0,
    yaw: 0,
    accX: 0,
    accY: 0,
    accZ: 0,
    noiseStatus: 0,
    fitError: 0,
    powerLeft: 0,
}
```

## Android

### SDK

* JINS MEME SDK Android 1.1.4

### アプリ設定 · Application settings

Make sure that Bluetooth is enabled

* 設定 · Settings => Apps => 「該当アプリ」でBluetoothをONにすること · Turn on Bluetooth

### 依存するライブラリ等 · Dependencies

* AndroidプラグインではAndroidManifest.xmlのtargetSdkVersionを変更するために以下のスクリプトを使用している · The plugin uses the following script to change the targetSdkVersion of AndroidManifest.xml

#### android_after_plugin_install.js

* cordovaのフックスクリプト · Cordova hook script
* AndroidManifest.xmlのandroid:targetSdkVersionを22に変更 · Change android: targetSdkVersion in AndroidManifest.xml to 22
	* BluetoothのPermission問題を解決するため · Solves Bluetooth permission problem
	* 23以上だとエラーが発生 · Version 23 and above cause an error
		* ACCESS_COARSE_LOCATIONとACCESS_FINE_LOCATIONを記述していても、エラーとなってしまう · Occurs even if ACCESS_COARSE_LOCATION and ACCESS_FINE_LOCATION are listed as permissions
		* gradleのバージョンを上げれば23以上でも対応可能だが、Cordovaコマンドからの更新は難しい · Upgrading Gradle permits 23 and up, but updating from Cordova cli is difficult
	* 元々のtargetSdkVersionをhooks/original_versionファイルに保存 · Save original targetSdkVersion in hooks / original_version file

#### android_before_plugin_uninstall.js

* JINS MEMEプラグインを取り除く際に、AndroidManifest.xmlのandroid:targetSdkVersionを元に戻す · When removing the JINS MEME plug-in, undo android: targetSdkVersion in AndroidManifest.xml

## iOS

### SDK

* JINS MEME SDK iOS 1.1.2

### 依存するnodejsモジュール · Node.js modules

iOSプラグインではXcodeのEmbedded BinariesにMEMELib.frameworkを追加するためにnode-xcodeを使用している。node-xcodeとその依存ライブラリは基本的にMIT LicenseとUnlicenseで使用可能である。各種詳細と依存関係は以下の通り。 · The iOS plugin uses node-xcode to add MEMELib.framework to Xcode's Embedded Binaries. Basically, node xcode and its dependency library can be used with MIT License and Unlicense. Various details and dependencies are as follows:

#### [node-xcode](https://github.com/kurtisf/node-xcode)

* MIT License
* 依存関係 · Dependency

```
├─ node-uuid                  # Dual License under MIT and GPL
├─ pegjs                      # MIT License
└─ simple-plist               # MIT License
    ├─ bplist-creator         # MIT License
    │   └─ stream-buffers     # Unlicense
    ├─ bplist-parser          # MIT License
    └─ plist                  # MIT License
        ├─ base64-js          # MIT License
        ├─ util-deprecate     # MIT License
        ├─ xmlbuilder         # MIT License
        │   └─ lodash-node    # MIT License
        └─ xmldom             # MIT License
```

#### [node-uuid](https://github.com/broofa/node-uuid)

* node-xcodeで使用
* Dual licensed under the [MIT](http://en.wikipedia.org/wiki/MIT_License) and [GPL](http://en.wikipedia.org/wiki/GNU_General_Public_License) licenses.
* 依存関係なし · No dependencies

#### [pegjs](http://pegjs.org/)

* node-xcodeで使用
* MIT License
* 依存関係なし · No dependencies

#### [simple-plist](https://github.com/wollardj/node-simple-plist)

* node-xcodeで使用
* MIT License
* 依存関係 · 
	* bplist-creator
	* bplist-parser
	* plist

#### [bplist-creator](https://github.com/joeferner/node-bplist-creator)

* simple-plistで使用
* MIT License
* 依存関係 ·  · Dependencies:
	* stream-buffers

#### [stream-parser](https://github.com/samcday/node-stream-buffer)

* bplist-creatorで使用
* [UNLICENSE](http://unlicense.org/)
* 依存関係なし · No dependencies

#### [bplist-creator](https://github.com/joeferner/node-bplist-parser)

* simple-plistで使用
* MIT License
* 依存関係なし · No dependencies

#### [plist](https://github.com/TooTallNate/plist.js)

* bplist-creatorで使用
* MIT License
	* base64-js
	* util-deprecate
	* xmlbuilder
	* xmldom

#### [base64-js](https://github.com/beatgammit/base64-js)

* plistで使用
* MIT License
* 依存関係なし · No dependencies

#### [util-deprecate](https://github.com/TooTallNate/util-deprecate)

* plistで使用
* MIT License
*依存関係なし No dependencies

#### [xmlbuilder](http://github.com/oozcitak/xmlbuilder-js)

* plistで使用
* MIT License
* 依存関係 · Dependencies:
	* lodash-node

#### [lodash-node](http://lodash.com/custom-builds)

* xmlbuilderで使用
* MIT License
*依存関係なし No dependencies

#### [xmldom](https://github.com/jindw/xmldom)

* plistで使用
* MIT License
*依存関係なし No dependencies

### Other notes & instructions · その他流用ライブラリ

In the iOS plugin, the following code is used to add MEMELib.framework to Xcode's Embedded Binaries. · iOSプラグインではXcodeのEmbedded BinariesにMEMELib.frameworkを追加するために以下のコードを使用している。

#### ios_after_plugin_install.js

* Cordova hook script · cordovaのフックスクリプト
* hooks/after_plugin_install.js from: · は以下のコードから流用
	* https://github.com/btafel/cordova-plugin-braintree の hooks/after_plugin_install.js
	* MIT License
