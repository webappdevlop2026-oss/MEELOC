@echo off
REM Meeloc - one-time setup on Windows (needs Flutter installed)
cd /d "%~dp0"
for %%A in (customer_app business_app delivery_partner_app) do (
  echo ==== %%A ====
  pushd %%A
  call flutter create . --platforms android --org in.meeloc
  if exist test rmdir /s /q test
  call flutter pub get
  popd
)
echo ==== admin_panel ====
pushd admin_panel
call flutter create . --platforms web --org in.meeloc
if exist test rmdir /s /q test
call flutter pub get
popd
powershell -Command "(Get-Content customer_app\android\app\src\main\AndroidManifest.xml) -replace 'android:label=\"[^\"]*\"','android:label=\"Meeloc\"' | Set-Content customer_app\android\app\src\main\AndroidManifest.xml"
powershell -Command "(Get-Content business_app\android\app\src\main\AndroidManifest.xml) -replace 'android:label=\"[^\"]*\"','android:label=\"Meeloc Business\"' | Set-Content business_app\android\app\src\main\AndroidManifest.xml"
powershell -Command "(Get-Content delivery_partner_app\android\app\src\main\AndroidManifest.xml) -replace 'android:label=\"[^\"]*\"','android:label=\"Meeloc Partner\"' | Set-Content delivery_partner_app\android\app\src\main\AndroidManifest.xml"
echo.
echo Done! Run an app:  cd customer_app  then  flutter run
pause
