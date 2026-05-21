#!/bin/bash

echo "=================================================================="
echo "  Управление политиками расширений macOS (Chrome, Vivaldi и др.)"
echo "=================================================================="
echo ""
echo "Выберите нужное действие:"
echo "[1] - ДОБАВИТЬ в белый список (Позволит установить расширения, но заблокирует настройки)"
echo "[2] - УДАЛИТЬ из белого списка (Снимет корпоративные ограничения и вернет настройки)"
echo ""
read -p "Ваш выбор (введите 1 или 2 и нажмите Enter): " choice

if [ "$choice" == "1" ]; then
    # ==========================================
    # БЛОК ДОБАВЛЕНИЯ
    # ==========================================
    counter=1

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

    echo ""
    echo "Добавляем базовые расширения..."
    predefined_ids=(
        "pgfanclceljfijjchkoihdddihlmkaec"
        "jjdfkffchblmcoalbpnkcdpdhijnddge"
        "bjgjeegdbhlgnopeamnbolkmlhalkdmf"
        "cggiokpifbiimhifgkjeobfoneeofcai"
        "hpmldkbhcihbifmcelpfjpdcoblgkgml"
        "momgccnahgepogdgppifiknmhhllciih"
    )

    for id in "${predefined_ids[@]}"; do
        add_extension "$id"
    done
    echo "[OK] Все базовые расширения успешно добавлены!"
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
    echo "Теперь ПОЛНОСТЬЮ закройте ваши браузеры (нажав Cmd+Q) и откройте заново,"
    echo "чтобы политики вступили в силу."
    echo "После установки расширений не забудьте снова запустить "
    echo "этот скрипт и выбрать пункт [2], чтобы разблокировать настройки."
    echo ""
    read -p "Нажмите Enter для выхода..."

elif [ "$choice" == "2" ]; then
    # ==========================================
    # БЛОК УДАЛЕНИЯ
    # ==========================================
    echo ""
    echo "Удаление корпоративных политик для всех браузеров..."

    # Удаляем только конкретный ключ ExtensionInstallAllowlist из настроек
    defaults delete com.google.Chrome ExtensionInstallAllowlist 2>/dev/null
    defaults delete com.vivaldi.Vivaldi ExtensionInstallAllowlist 2>/dev/null
    defaults delete com.microsoft.Edge ExtensionInstallAllowlist 2>/dev/null
    defaults delete com.brave.Browser ExtensionInstallAllowlist 2>/dev/null
    defaults delete com.operasoftware.Opera ExtensionInstallAllowlist 2>/dev/null
    defaults delete ru.yandex.desktop.yandex-browser ExtensionInstallAllowlist 2>/dev/null

    echo ""
    echo "=================================================================="
    echo "ГОТОВО! Ограничения сняты."
    echo "=================================================================="
    echo "ОБЯЗАТЕЛЬНО полностью закройте браузеры (нажав Cmd + Q) и запустите их снова."
    echo "Надпись 'Управляется вашей организацией' должна исчезнуть,"
    echo "а настройки - полностью разблокироваться."
    echo ""
    read -p "Нажмите Enter для выхода..."

else
    echo ""
    echo "Неверный ввод. Закрытие программы..."
    exit 1
fi