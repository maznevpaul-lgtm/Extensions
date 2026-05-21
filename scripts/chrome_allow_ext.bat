@echo off
:: Включаем поддержку русского языка в консоли
chcp 65001 >nul
color 0A

:: Надежная проверка на запуск от имени Администратора
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ==================================================================
    echo ОШИБКА ДОСТУПА! Запустите файл от имени Администратора.
    echo Закройте это окно, нажмите на файл ПРАВОЙ кнопкой мыши 
    echo и выберите "Запуск от имени администратора".
    echo ==================================================================
    echo.
    pause
    exit
)

echo ==================================================================
echo   Управление политиками расширений (Chrome, Vivaldi и др.)
echo ==================================================================
echo.
echo Выберите нужное действие:
echo [1] - ДОБАВИТЬ белый список (Позволит установить расширения, но заблокирует настройки)
echo [2] - УДАЛИТЬ белый список (Вернет доступ к настройкам браузера)
echo.
set /p choice="Ваш выбор (введите 1 или 2 и нажмите Enter): "

if "%choice%"=="1" goto ADD_ROUTINE
if "%choice%"=="2" goto REMOVE_ROUTINE

echo.
echo Неверный ввод. Закрытие программы...
pause
exit

:: ==================================================================
:: БЛОК ДОБАВЛЕНИЯ
:: ==================================================================
:ADD_ROUTINE
set counter=1
echo.
echo Добавляем базовые расширения...
call :ADD_EXT "pgfanclceljfijjchkoihdddihlmkaec"
call :ADD_EXT "jjdfkffchblmcoalbpnkcdpdhijnddge"
call :ADD_EXT "bjgjeegdbhlgnopeamnbolkmlhalkdmf"
call :ADD_EXT "cggiokpifbiimhifgkjeobfoneeofcai"
call :ADD_EXT "hpmldkbhcihbifmcelpfjpdcoblgkgml"
call :ADD_EXT "momgccnahgepogdgppifiknmhhllciih"
echo [OK] Все базовые расширения успешно добавлены!
echo.

echo Инструкция: Если хотите добавить еще расширения, вставляйте ID по одному и нажимайте Enter.
echo Чтобы закончить, просто нажмите Enter в пустой строке.
echo.
:INPUT_LOOP
set "ext_id="
set /p ext_id="Введите дополнительный ID (или Enter для завершения): "

if "%ext_id%"=="" goto FINISH_ADD

call :ADD_EXT "%ext_id%"
echo [OK] Дополнительное расширение %ext_id% добавлено!
echo.
goto INPUT_LOOP

:FINISH_ADD
set /a added=%counter%-1
echo.
echo ==================================================================
echo ГОТОВО! Всего в белом списке: %added%
echo ==================================================================
echo Теперь ПЕРЕЗАПУСТИТЕ браузер, чтобы политики вступили в силу.
echo После установки расширений не забудьте снова запустить 
echo этот скрипт и выбрать пункт [2], чтобы разблокировать настройки.
echo.
pause
exit

:: ==================================================================
:: БЛОК УДАЛЕНИЯ
:: ==================================================================
:REMOVE_ROUTINE
echo.
echo Удаление корпоративных политик из реестра...
:: Удаляем ключи, подавляя вывод возможных ошибок (если ключа уже нет)
reg delete "HKLM\SOFTWARE\Policies\Google\Chrome\ExtensionInstallAllowlist" /f >nul 2>&1

:: Для Vivaldi удаляем всю папку политик целиком, чтобы точно снять блокировку настроек
reg delete "HKLM\SOFTWARE\Policies\Vivaldi" /f >nul 2>&1

reg delete "HKLM\SOFTWARE\Policies\Microsoft\Edge\ExtensionInstallAllowlist" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\BraveSoftware\Brave\ExtensionInstallAllowlist" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Opera\ExtensionInstallAllowlist" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\YandexBrowser\ExtensionInstallAllowlist" /f >nul 2>&1

echo.
echo ==================================================================
echo ГОТОВО! Ограничения сняты.
echo ==================================================================
echo ПЕРЕЗАПУСТИТЕ браузер Vivaldi. 
echo Надпись "Управляется вашей организацией" должна исчезнуть, 
echo а настройки - полностью разблокироваться.
echo.
pause
exit

:: ==================================================================
:: ФУНКЦИЯ ДОБАВЛЕНИЯ ВО ВСЕ БРАУЗЕРЫ
:: ==================================================================
:ADD_EXT
set "id=%~1"
reg add "HKLM\SOFTWARE\Policies\Google\Chrome\ExtensionInstallAllowlist" /v "%counter%" /t REG_SZ /d "%id%" /f >nul
reg add "HKLM\SOFTWARE\Policies\Vivaldi\ExtensionInstallAllowlist" /v "%counter%" /t REG_SZ /d "%id%" /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge\ExtensionInstallAllowlist" /v "%counter%" /t REG_SZ /d "%id%" /f >nul
reg add "HKLM\SOFTWARE\Policies\BraveSoftware\Brave\ExtensionInstallAllowlist" /v "%counter%" /t REG_SZ /d "%id%" /f >nul
reg add "HKLM\SOFTWARE\Policies\Opera\ExtensionInstallAllowlist" /v "%counter%" /t REG_SZ /d "%id%" /f >nul
reg add "HKLM\SOFTWARE\Policies\YandexBrowser\ExtensionInstallAllowlist" /v "%counter%" /t REG_SZ /d "%id%" /f >nul
set /a counter+=1
exit /b