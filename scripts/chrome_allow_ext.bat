@echo off
:: Включаем поддержку русского языка в консоли
chcp 65001 >nul
color 0A

echo ==================================================================
echo   Универсальный белый список (Chrome, Vivaldi, Edge, Brave, Ya)
echo ==================================================================
echo.
echo ВНИМАНИЕ: Запустите файл от имени Администратора!
echo.

set counter=1

echo Добавляем базовые расширения...
call :ADD_EXT "pgfanclceljfijjchkoihdddihlmkaec"
call :ADD_EXT "jjdfkffchblmcoalbpnkcdpdhijnddge"
call :ADD_EXT "bjgjeegdbhlgnopeamnbolkmlhalkdmf"
call :ADD_EXT "cggiokpifbiimhifgkjeobfoneeofcai"
echo [OK] Все 4 базовых расширения успешно добавлены!
echo.

echo Инструкция: Если хотите добавить еще расширения, вставляйте ID по одному и нажимайте Enter.
echo Чтобы закончить, просто нажмите Enter в пустой строке.
echo.

:INPUT_LOOP
set "ext_id="
set /p ext_id="Введите дополнительный ID (или Enter для завершения): "

:: Если ввели пустоту (ничего не написали) - выходим из цикла
if "%ext_id%"=="" goto FINISH

call :ADD_EXT "%ext_id%"
echo [OK] Дополнительное расширение %ext_id% добавлено!
echo.
goto INPUT_LOOP

:FINISH
set /a added=%counter%-1

echo.
echo ==================================================================
echo ГОТОВО! Всего в белом списке: %added%
echo ==================================================================
echo Теперь перезапустите ваш браузер (Vivaldi, Chrome и т.д.),
echo чтобы новые политики вступили в силу.
echo.
pause
exit

:: --- ФУНКЦИЯ ДОБАВЛЕНИЯ ВО ВСЕ БРАУЗЕРЫ ---
:ADD_EXT
set "id=%~1"
:: Google Chrome
reg add "HKLM\SOFTWARE\Policies\Google\Chrome\ExtensionInstallAllowlist" /v "%counter%" /t REG_SZ /d "%id%" /f >nul
:: Проверяем на ошибку доступа
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
reg add "HKLM\SOFTWARE\Policies\Vivaldi\ExtensionInstallAllowlist" /v "%counter%" /t REG_SZ /d "%id%" /f >nul
:: Microsoft Edge
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge\ExtensionInstallAllowlist" /v "%counter%" /t REG_SZ /d "%id%" /f >nul
:: Brave
reg add "HKLM\SOFTWARE\Policies\BraveSoftware\Brave\ExtensionInstallAllowlist" /v "%counter%" /t REG_SZ /d "%id%" /f >nul
:: Opera
reg add "HKLM\SOFTWARE\Policies\Opera\ExtensionInstallAllowlist" /v "%counter%" /t REG_SZ /d "%id%" /f >nul
:: Яндекс.Браузер
reg add "HKLM\SOFTWARE\Policies\YandexBrowser\ExtensionInstallAllowlist" /v "%counter%" /t REG_SZ /d "%id%" /f >nul

set /a counter+=1
exit /b