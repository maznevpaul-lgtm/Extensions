@echo off
:: Включаем поддержку русского языка в консоли
chcp 65001 >nul
color 0A

echo ==================================================================
echo   Универсальный белый список (Chrome, Vivaldi, Edge, Brave, Ya)
echo ==================================================================
echo.
echo ВНИМАНИЕ: Чтобы этот скрипт сработал, вы должны были 
echo запустить его от имени Администратора!
echo.
echo Инструкция: Вставляйте ID расширений по одному и нажимайте Enter.
echo Когда добавите все нужные, просто нажмите Enter в пустой строке.
echo.

set counter=1

:INPUT_LOOP
set "ext_id="
set /p ext_id="Введите ID расширения #%counter% (или Enter для завершения): "

:: Если ввели пустоту (ничего не написали) - выходим из цикла
if "%ext_id%"=="" goto FINISH

:: --- ДОБАВЛЯЕМ ВО ВСЕ БРАУЗЕРЫ ---

:: Google Chrome
reg add "HKLM\SOFTWARE\Policies\Google\Chrome\ExtensionInstallAllowlist" /v "%counter%" /t REG_SZ /d "%ext_id%" /f >nul

:: Проверяем на ошибку доступа (хватит проверки первого браузера)
if %errorlevel% neq 0 (
    echo.
    echo ==================================================================
    echo ОШИБКА ДОСТУПА! 
    echo Скорее всего, вы запустили файл обычным двойным кликом.
    echo Закройте это окно, нажмите на файл ПРАВОЙ кнопкой мыши 
    echo и выберите "Запуск от имени администратора".
    echo ==================================================================
    echo.
    pause
    exit
)

:: Vivaldi
reg add "HKLM\SOFTWARE\Policies\Vivaldi\ExtensionInstallAllowlist" /v "%counter%" /t REG_SZ /d "%ext_id%" /f >nul

:: Microsoft Edge
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge\ExtensionInstallAllowlist" /v "%counter%" /t REG_SZ /d "%ext_id%" /f >nul

:: Brave
reg add "HKLM\SOFTWARE\Policies\BraveSoftware\Brave\ExtensionInstallAllowlist" /v "%counter%" /t REG_SZ /d "%ext_id%" /f >nul

:: Opera
reg add "HKLM\SOFTWARE\Policies\Opera\ExtensionInstallAllowlist" /v "%counter%" /t REG_SZ /d "%ext_id%" /f >nul

:: Яндекс.Браузер
reg add "HKLM\SOFTWARE\Policies\YandexBrowser\ExtensionInstallAllowlist" /v "%counter%" /t REG_SZ /d "%ext_id%" /f >nul


echo [OK] Расширение %ext_id% добавлено для всех браузеров!
set /a counter+=1
echo.
goto INPUT_LOOP

:FINISH
set /a added=%counter%-1

echo.
if %added% equ 0 (
    echo Вы не добавили ни одного расширения.
) else (
    echo ==================================================================
    echo ГОТОВО! Успешно разрешено расширений: %added%
    echo ==================================================================
    echo Теперь перезапустите ваш браузер (Vivaldi, Chrome и т.д.),
    echo чтобы новые политики вступили в силу.
)

echo.
pause