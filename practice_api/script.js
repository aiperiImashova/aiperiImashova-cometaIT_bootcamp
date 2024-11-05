const express = require('express'); // Подключаем библиотеку Express
const app = express(); // Создаём приложение Express
const PORT = 3030; // Задаём порт, на котором будет работать сервер

// Это middleware для обработки JSON-запросов
app.use(express.json());

// GET-запрос для проверки работы сервера
app.get('/', (req, res) => {
  res.send('API работает! Отправьте POST-запрос с числом, чтобы проверить его чётность.');
});

// POST-запрос для проверки чётности числа
app.post('/check', (req, res) => {
  const { number } = req.body; // Извлекаем число из тела запроса

  // Проверяем, передано ли число
  if (typeof number !== 'number') {
    return res.status(400).json({ error: 'Введите корректное число' });
  }

  // Проверка чётности числа
  const isEven = number % 2 === 0;
  res.json({ number, isEven }); // Отправляем ответ в формате JSON
});

// Запуск сервера
app.listen(PORT, () => {
  console.log(`Сервер запущен на http://localhost:${PORT}`);
});
