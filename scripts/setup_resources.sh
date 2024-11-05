#!/bin/bash

# Настройки
RESOURCES_DIR="$HOME/resources"
RESULT_DIR="/tmp/result"
DATE=$(date +'%Y-%m-%d_%H-%M-%S')
ARCHIVE_NAME="resources_$DATE.tar.gz"
GROUP_NAME="resgrp"
USER_NAME=$(whoami)

# 0) Удаляем все файлы в /tmp/result/
rm -f "$RESULT_DIR"/*

# 1) Создаем папки disk, process, memory, user внутри resources
mkdir -p "$RESOURCES_DIR/disk"
mkdir -p "$RESOURCES_DIR/process"
mkdir -p "$RESOURCES_DIR/memory"
mkdir -p "$RESOURCES_DIR/user"

# 2) Создаем файлы d.txt, p.txt, m.txt, u.txt
touch "$RESOURCES_DIR/d.txt"
touch "$RESOURCES_DIR/p.txt"
touch "$RESOURCES_DIR/m.txt"
touch "$RESOURCES_DIR/u.txt"

# 3) Записываем информацию о свободном месте на дисках в d.txt
df -h > "$RESOURCES_DIR/d.txt"

# 4) Записываем информацию о 10 самых ресурсоёмких процессах в p.txt
ps aux --sort=-%mem | head -n 11 > "$RESOURCES_DIR/p.txt"

# 5) Записываем информацию об оперативной памяти в m.txt
free -h > "$RESOURCES_DIR/m.txt"

# 6) Записываем информацию о пользователе в u.txt
# 6.1) Информация из /etc/passwd
grep "^$USER_NAME:" /etc/passwd > "$RESOURCES_DIR/u.txt"
# 6.2) Информация о времени логина
last -n 1 "$USER_NAME" >> "$RESOURCES_DIR/u.txt"
# 6.3) Информация о группах пользователя
groups "$USER_NAME" >> "$RESOURCES_DIR/u.txt"
# 6.4) Содержание домашней директории
ls -la "$HOME" >> "$RESOURCES_DIR/u.txt"

# 7) Перемещаем файлы в соответствующие папки с изменением имени
mv "$RESOURCES_DIR/d.txt" "$RESOURCES_DIR/disk/disk.txt"
mv "$RESOURCES_DIR/p.txt" "$RESOURCES_DIR/process/process.txt"
mv "$RESOURCES_DIR/m.txt" "$RESOURCES_DIR/memory/memory.txt"

# 8) Копируем файл u.txt в папку user и переименовываем его в user.txt
cp "$RESOURCES_DIR/u.txt" "$RESOURCES_DIR/user/user.txt"

# 9) Смена группы и прав для папок и файлов
sudo chgrp -R "$GROUP_NAME" "$RESOURCES_DIR"
chmod -R 760 "$RESOURCES_DIR"

# 10) Создаем архив resources с текущей датой и временем, сохраняем его в /tmp/result/
tar -czf "$RESULT_DIR/$ARCHIVE_NAME" -C "$HOME" "resources"

# Сообщение о завершении
echo "Скрипт выполнен успешно. Архив создан: $RESULT_DIR/$ARCHIVE_NAME"
