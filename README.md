# JINS MEME SDK Cordova Plugin

## Change Log - 更新履歴

- ver. 1.3.1: Cordova9 complient.
- ver. 1.3.0: Enable background buffering.

## How to use - 使い方

[公式マニュアル](https://jins-meme.github.io/sdkdoc/monaca/)

## Plug-in structure - プラグイン構造

```
├── README.md                              # This document - 本文書
├── hooks
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
    └── jins_meme_plugin.js                # JavaScriptインタフェース

```

## JavaScript API

### Error objects - エラーオブジェクト

#### Error structure - 構造

* Example JSON error object - JSONオブジェクトでエラーcodeとmessageを返す

```
{
    code: -100,
    message: "some message"
}
```

#### Error code - エラーコード

* Connection status - プラグイン独自

```
初期化失敗　: -100
未初期化　　: -101
スキャン中　: -102
未接続　　　: -103
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
その他(UNKNOWN)       : -1
```

### CalibStatus

* isCalibStatusで取得した値を以下の数値に変換して返す

```
CALIB_NOT_FINISHED : 0
CALIB_BODY_FINISHED: 1
CALIB_EYE_FINISHED : 2
CALIB_BOTH_FINISHED: 3
その他(UNKNOWN)     : -1
```

### Reported Data

* JSONオブジェクトでデータを返す

```
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

* JINS MEME SDK Android 1.2.0

### App setting - アプリ設定

* 設定 => Apps => 「該当アプリ」でBluetoothをONにすること

## iOS

### SDK

* JINS MEME SDK iOS 1.2.0

### Dependent noode.js module - 依存するnodejsモジュール

iOSプラグインではXcodeのEmbedded BinariesにMEMELib.frameworkを追加するためにnode-xcodeを使用している。node-xcodeとその依存ライブラリは基本的にMIT LicenseとUnlicenseで使用可能である。各種詳細と依存関係は以下の通り。

#### [node-xcode](https://github.com/kurtisf/node-xcode)

* MIT License
* 依存関係

```
├─ node-uuid                # Dual License under MIT and GPL
├─ pegjs                    # MIT License
└─ simple-plist             # MIT License
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
* 依存関係なし

#### [pegjs](http://pegjs.org/)

* node-xcodeで使用
* MIT License
* 依存関係なし

#### [simple-plist](https://github.com/wollardj/node-simple-plist)

* node-xcodeで使用
* MIT License
* 依存関係
	* bplist-creator
	* bplist-parser
	* plist

#### [bplist-creator](https://github.com/joeferner/node-bplist-creator)

* simple-plistで使用
* MIT License
* 依存関係
	* stream-buffers

#### [stream-parser](https://github.com/samcday/node-stream-buffer)

* bplist-creatorで使用
* [UNLICENSE](http://unlicense.org/)
* 依存関係なし

#### [bplist-creator](https://github.com/joeferner/node-bplist-parser)

* simple-plistで使用
* MIT License
* 依存関係なし

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
* 依存関係なし

#### [util-deprecate](https://github.com/TooTallNate/util-deprecate)

* plistで使用
* MIT License
* 依存関係なし

#### [xmlbuilder](http://github.com/oozcitak/xmlbuilder-js)

* plistで使用
* MIT License
* 依存関係
	* lodash-node

#### [lodash-node](http://lodash.com/custom-builds)

* xmlbuilderで使用
* MIT License
* 依存関係なし

#### [xmldom](https://github.com/jindw/xmldom)

* plistで使用
* MIT License
* 依存関係なし

### その他流用ライブラリ

iOSプラグインではXcodeのEmbedded BinariesにMEMELib.frameworkを追加するために以下のコードを使用している。

#### ios_after_plugin_install.js

* cordovaのフックスクリプト
* hooks/after_plugin_install.js は以下のコードから流用
	* https://github.com/btafel/cordova-plugin-braintree の hooks/after_plugin_install.js
	* MIT License
