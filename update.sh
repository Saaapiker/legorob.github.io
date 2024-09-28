#!/bin/bash

# Параметры
LOCAL_FILE="/legorob/v1.py"  # Локальный путь к Python-скрипту
PROCESS_NAME="v1.py"  # Имя Python-скрипта

# Функция для проверки обновления файла на GitHub
check_for_update() {
  # Загружаем последний файл с GitHub
  git pull

  # Проверяем изменения
  if ! cmp -s v1.py $LOCAL_FILE; then
    echo "Скрипт обновлен. Скачиваем новую версию."
    cp v1.py $LOCAL_FILE
    restart_process
  else
    echo "Скрипт не обновлен."
  fi
}

# Функция для перезапуска Python-скрипта
restart_process() {
  echo "Перезапуск Python-скрипта $PROCESS_NAME..."
  
  # Останавливаем запущенный Python-скрипт (если он существует)
  pkill -f $LOCAL_FILE

  # Запускаем скрипт заново
  nohup python3 $LOCAL_FILE &

  echo "$PROCESS_NAME перезапущен."
}

# Основной цикл проверки обновлений
while true; do
  check_for_update
  # Проверять обновления каждые 60 секунд
  sleep 60
done
