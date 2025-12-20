# Release Build Workflow

Follow these steps to generate a signed APK for release.

## 1. Generate Keystore

If you don't have a keystore yet, run this command in your terminal (replace names as needed):

```bash
keytool -genkey -v -keystore android/app/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

## 2. Configure key.properties

Create or update `android/key.properties` with the credentials used in step 1:

```properties
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=upload
storeFile=upload-keystore.jks
```

> [!NOTE]
> The `storeFile` path `upload-keystore.jks` assumes it is inside the `android/app` directory.

## 3. Build APK

Run the following command to build the release APK:

```bash
// turbo
flutter build apk --release
```

The output APK will be located at:
`build/app/outputs/flutter-apk/app-release.apk`
