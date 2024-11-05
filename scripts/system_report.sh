#!/bin/bash
# Проверяем, установлен ли пакет sendmail (для отправки отчета по почте)
if ! command -v sendmail &> /dev/null; then
  echo "Пакет sendmail не установлен. Установите его для отправки отчетов по e-mail."
  exit 1
fi

# Переменные для отчетов
DATE=$(date +'%Y-%m-%d_%H-%M-%S')
REPORT_FILE="system_report_$DATE.txt"
EMAIL="$1"  # E-mail адрес передается в виде аргумента

# Создаем файл отчета
echo "Отчет о загрузке системных ресурсов" > "$REPORT_FILE"
echo "Дата и время: $(date)" >> "$REPORT_FILE"
echo "===================================" >> "$REPORT_FILE"

# Сбор данных о CPU
echo -e "\nЗагрузка ЦПУ:" >> "$REPORT_FILE"
top -bn1 | grep "Cpu(s)" | awk '{print "CPU загрузка: " $2 + $4 "%"}' >> "$REPORT_FILE"

# Сбор данных о памяти
echo -e "\nОперативная память:" >> "$REPORT_FILE"
free -h | awk '/^Mem/ {print "Использовано: "$3", Свободно: "$4}' >> "$REPORT_FILE"

# Сбор данных о дисковом пространстве
echo -e "\nДисковое пространство:" >> "$REPORT_FILE"
df -h / | awk 'NR==2 {print "Доступно: "$4", Использовано: "$3", Всего: "$2}' >> "$REPORT_FILE"

# Топ-5 процессов по загрузке CPU
echo -e "\nТоп-5 процессов по CPU:" >> "$REPORT_FILE"
ps aux --sort=-%cpu | head -n 6 | awk '{print $1, $2, $3"%", $4"%", $11}' >> "$REPORT_FILE"

# Топ-5 процессов по загрузке RAM
echo -e "\nТоп-5 процессов по RAM:" >> "$REPORT_FILE"
ps aux --sort=-%mem | head -n 6 | awk '{print $1, $2, $3"%", $4"%", $11}' >> "$REPORT_FILE"

echo "Отчет сохранен в файл $REPORT_FILE"

# Если указан e-mail, отправляем отчет на него
if [[ -n "$EMAIL" ]]; then
  echo -e "Отчет о загрузке системных ресурсов.\n\n$(cat "$REPORT_FILE")" | sendmail "$EMAIL"
  echo "Отчет отправлен на e-mail: $EMAIL"
fi

