const express = require('express');
const app = express();

const port = 3000;

app.use(express.json());


app.get('/getSenhas', (req, res) => {
  const filePath = path.join(__dirname, 'data.json');
  fs.readFile(filePath, 'utf8', (err, data) => {
    if (err) {
      res.status(500).json({ error: 'Erro ao ler o arquivo' });
      return;
    }
    res.json(JSON.parse(data));
  });
});


app.post('/criarSenha', (req, res) => {
  const { username, senha, titulo, descricao, urlImage } = req.body;

  if (!username || !senha || !titulo || !descricao || !urlImage) {
    return res.status(400).json({ error: 'Todos os parâmetros (username, senha, titulo, descricao, urlImage) são obrigatórios' });
  }

  res.status(201).json({ message: 'Senha criada com sucesso' });
});


app.delete('/excluirSenha', (req, res) => {
  const { id } = req.body;

  if (!id) {
    return res.status(400).json({ error: 'O parâmetro id é obrigatório' });
  }

  res.status(200).json({ message: 'Senha excluída com sucesso' });
});


app.put('/editarSenha', (req, res) => {
  const { id, senha, descricao, titulo, urlImage } = req.body;

  if (!id || !senha || !descricao || !titulo || !urlImage) {
    return res.status(400).json({ error: 'Todos os parâmetros (id, senha, descricao, titulo, urlImage) são obrigatórios' });
  }

  res.status(200).json({ message: 'Senha editada com sucesso' });
});



app.post('/login', (req, res) => {
  const { username, senha } = req.body;

  if (!username || !senha) {
    return res.status(400).json({ error: 'Username e senha são obrigatórios' });
  }

  res.status(200).json({ message: 'Login bem-sucedido' });
});


app.post('/signup', (req, res) => {
  const { username, senha } = req.body;

  if (!username || !senha) {
    return res.status(400).json({ error: 'Username e senha são obrigatórios' });
  }

  res.status(201).json({ message: 'Usuário cadastrado com sucesso' });
});


app.listen(port, () => {
  console.log(`Servidor rodando em http://localhost:${port}`);
});
