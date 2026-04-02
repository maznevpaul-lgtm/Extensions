#!/bin/bash

echo "=================================================================="
echo "  Универсальный белый список macOS (Chrome, Vivaldi, Edge, Brave)"
echo "=================================================================="
echo ""
echo "Инструкция: Вставляйте ID расширений по одному и нажимайте Enter."
echo "Когда добавите все нужные, просто нажмите Enter в пустой строке."
echo ""

counter=1

while true; do
    read -p "Введите ID расширения #$counter (или Enter для завершения): " ext_id

    # Если ввели пустоту (ничего не написали) - выходим из цикла
    if [ -z "$ext_id" ]; then
        break
    fi

    # --- ДОБАВЛЯЕМ ВО ВСЕ БРАУЗЕРЫ ---
    # 2>/dev/null скрывает системные ошибки, если какой-то из браузеров не установлен

    # Google Chrome
    defaults write com.google.Chrome ExtensionInstallAllowlist -array-add "$ext_id" 2>/dev/null
    
    # Vivaldi
    defaults write com.vivaldi.Vivaldi ExtensionInstallAllowlist -array-add "$ext_id" 2>/dev/null
    
    # Microsoft Edge
    defaults write com.microsoft.Edge ExtensionInstallAllowlist -array-add "$ext_id" 2>/dev/null
    
    # Brave
    defaults write com.brave.Browser ExtensionInstallAllowlist -array-add "$ext_id" 2>/dev/null
    
    # Opera
    defaults write com.operasoftware.Opera ExtensionInstallAllowlist -array-add "$ext_id" 2>/dev/null
    
    # Яндекс.Браузер
    defaults write ru.yandex.desktop.yandex-browser ExtensionInstallAllowlist -array-add "$ext_id" 2>/dev/null

    echo "[OK] Расширение $ext_id добавлено!"
    ((counter++))
    echo ""
done

added=$((counter - 1))

echo ""
if [ $added -eq 0 ]; then
    echo "Вы не добавили ни одного расширения."
else
    echo "=================================================================="
    echo "ГОТОВО! Успешно разрешено расширений: $added"
    echo "=================================================================="
    echo "Теперь полностью закройте ваш браузер (нажав Cmd+Q) и откройте заново,"
    echo "чтобы новые политики вступили в силу."
fi

echo ""
read -p "Нажмите Enter для выхода..."