#!/bin/bash

# Проверка аргументов
if [[ $# -lt 3 || $# -gt 4 ]]; then
  echo "Использование: $0 <путь к директории> <маска> <количество дней> [-y]"
  exit 1
fi

# Переменные
DIRECTORY=$1
MASK=$2
DAYS=$3
AUTO_CONFIRM=false

# Проверка на флаг -y
if [[ $4 == "-y" ]]; then
  AUTO_CONFIRM=true
fi

# Проверка, что директория существует
if [[ ! -d "$DIRECTORY" ]]; then
  echo "Ошибка: Директория '$DIRECTORY' не существует."
  exit 1
fi

# Поиск файлов
FILES=$(find "$DIRECTORY" -type f -name "$MASK" -mtime +"$DAYS")

if [[ -z "$FILES" ]]; then
  echo "Файлы, соответствующие критериям, не найдены."
  exit 0
fi

# Вывод списка файлов и запрос подтверждения
if [[ "$AUTO_CONFIRM" == false ]]; then
  echo "Следующие файлы будут удалены:"
  echo "$FILES"
  read -p "Вы уверены, что хотите удалить эти файлы? (y/n): " CONFIRM
  if [[ "$CONFIRM" != "y" ]]; then
    echo "Операция отменена."
    exit 0
  fi
fi

# Удаление файлов
echo "$FILES" | xargs rm -f
echo "Файлы успешно удалены."

