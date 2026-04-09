#!/bin/bash

echo "=================================================================="
echo "  Универсальный белый список macOS (Chrome, Vivaldi, Edge, Brave)"
echo "=================================================================="
echo ""

counter=1

# --- ФУНКЦИЯ ДОБАВЛЕНИЯ ВО ВСЕ БРАУЗЕРЫ ---
add_extension() {
    local ext_id=$1
    # 2>/dev/null скрывает системные ошибки, если браузер не установлен
    defaults write com.google.Chrome ExtensionInstallAllowlist -array-add "$ext_id" 2>/dev/null
    defaults write com.vivaldi.Vivaldi ExtensionInstallAllowlist -array-add "$ext_id" 2>/dev/null
    defaults write com.microsoft.Edge ExtensionInstallAllowlist -array-add "$ext_id" 2>/dev/null
    defaults write com.brave.Browser ExtensionInstallAllowlist -array-add "$ext_id" 2>/dev/null
    defaults write com.operasoftware.Opera ExtensionInstallAllowlist -array-add "$ext_id" 2>/dev/null
    defaults write ru.yandex.desktop.yandex-browser ExtensionInstallAllowlist -array-add "$ext_id" 2>/dev/null
    ((counter++))
}

echo "Добавляем базовые расширения..."
predefined_ids=(
    "pgfanclceljfijjchkoihdddihlmkaec"
    "jjdfkffchblmcoalbpnkcdpdhijnddge"
    "bjgjeegdbhlgnopeamnbolkmlhalkdmf"
    "cggiokpifbiimhifgkjeobfoneeofcai"
    "hpmldkbhcihbifmcelpfjpdcoblgkgml"
)

for id in "${predefined_ids[@]}"; do
    add_extension "$id"
    echo "[OK] Базовое расширение $id добавлено!"
done
echo ""

echo "Инструкция: Если хотите добавить еще расширения, вставляйте ID по одному и нажимайте Enter."
echo "Чтобы закончить, просто нажмите Enter в пустой строке."
echo ""

while true; do
    read -p "Введите дополнительный ID (или Enter для завершения): " ext_id

    # Если ввели пустоту (ничего не написали) - выходим из цикла
    if [ -z "$ext_id" ]; then
        break
    fi

    add_extension "$ext_id"
    echo "[OK] Дополнительное расширение $ext_id добавлено!"
    echo ""
done

added=$((counter - 1))

echo ""
echo "=================================================================="
echo "ГОТОВО! Всего в белом списке: $added"
echo "=================================================================="
echo "Теперь полностью закройте ваш браузер (нажав Cmd+Q) и откройте заново,"
echo "чтобы новые политики вступили в силу."
echo ""
read -p "Нажмите Enter для выхода..."