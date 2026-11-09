## iOS, macOS: Info.plist

```plist
<key>NSBluetoothPeripheralUsageDescription</key>
<string>This app uses bluetooth to communicate with your Progressor.</string>

<key>NSLocationWhenInUseUsageDescription</key>
<string>Scanning for Bluetooth devices can be used to locate you. That's why we ask you to permit Location services. We're only using this permission to scan for your Progressor. We'll never collect your physical location.</string>

<key>UIBackgroundModes</key>
<array>
    <string>bluetooth-central</string>
    <string>fetch</string>
</array>
```

## Android: AndroidMenifest.xml

```xml
<application android:networkSecurityConfig="@xml/network_security_config" />
```

## Android: res/xml/network_security_config.xml

```xml
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <base-config cleartextTrafficPermitted="false" />
    <domain-config cleartextTrafficPermitted="true">
        <domain includeSubdomains="true">localhost</domain>
        <domain includeSubdomains="true">10.0.2.2</domain>
    </domain-config>
</network-security-config>
```

## Android build: app/build.gradle

```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file("keystore.properties")
keystoreProperties.load(new FileInputStream(keystorePropertiesFile))

signingConfigs {
    release {
        keyAlias keystoreProperties['keyAlias']
        keyPassword keystoreProperties['keyPassword']
        storeFile file(keystoreProperties['storeFile'])
        storePassword keystoreProperties['storePassword']
    }
}

buildTypes {
    release {
        signingConfig signingConfigs.release
        proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        shrinkResources true
        minifyEnabled true
    }
}

splits {
    abi {
        enable true
        reset()
        include "arm64-v8a"
        universalApk true
    }
    density {
        enable true
        exclude "ldpi", "xxhdpi", "xxxhdpi"
        compatibleScreens 'small', 'normal', 'large', 'xlarge'
    }
}

dependencies {
    implementation "androidx.multidex:multidex:+"
    implementation "com.google.firebase:firebase-bom:+"
}
```

## Flutter: macOS

```xml
<window title="APP_NAME" allowsToolTipsWhenApplicationIsInactive="NO" autorecalculatesKeyViewLoop="NO" releasedWhenClosed="NO" animationBehavior="default" id="QvC-M9-y7g" customClass="MainFlutterWindow" customModule="Runner" customModuleProvider="target">
    <windowStyleMask key="styleMask" titled="YES" closable="YES" miniaturizable="YES" resizable="YES"/>
    <rect key="contentRect" x="0.0" y="0.0" width="390" height="760"/>
    <rect key="screenRect" x="0.0" y="0.0" width="1920" height="1080"/>
    <view key="contentView" wantsLayer="YES" id="EiT-Mj-1SZ">
        <rect key="frame" x="0.0" y="0.0" width="390" height="760"/>
        <autoresizingMask key="autoresizingMask"/>
    </view>
</window>
```

## Release.entitlements

```plist
<key>com.apple.security.app-sandbox</key>
```

## Debug.entitlements

```plist
<true/>
<key>com.apple.security.cs.allow-jit</key>
<true/>
<key>com.apple.security.network.client</key>
<true/>
<key>com.apple.security.network.server</key>
<true/>
```
