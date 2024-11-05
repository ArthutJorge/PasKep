const express = require('express');
const fs = require('fs');
const path = require('path');
const app = express();

const port = 3000;

app.get('/', (req, res) => {
  res.send('Hello');
});

app.get('/dados', (req, res) => {
  const filePath = path.join(__dirname, 'data.json');
  fs.readFile(filePath, 'utf8', (err, data) => {
    if (err) {
      res.status(500).json({ error: 'Erro ao ler o arquivo' });
      return;
    }
    res.json(JSON.parse(data));
  });
});

app.listen(port, () => {
  console.log(`Servidor rodando em http://localhost:${port}`);
});
