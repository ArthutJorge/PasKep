//configuracoes de dependencias
require('dotenv').config();
const express = require('express');
const { initializeApp } = require("firebase/app");
const { getFirestore, collection, doc, updateDoc, addDoc, getDocs, deleteDoc, query, where } = require("firebase/firestore");
const bcrypt = require('bcrypt');
const crypto = require('crypto');

//configuracoes do firebase
const firebaseConfig = {
  apiKey: process.env.API_KEY,
  authDomain: process.env.AUTH_DOMAIN,
  projectId: process.env.PROJECT_ID,
  storageBucket: process.env.STORAGE_BUCKET,
  messagingSenderId: process.env.MESSAGING_SENDER_ID,
  appId: process.env.APP_ID,
};

const firebaseApp = initializeApp(firebaseConfig);
const db = getFirestore(firebaseApp);

const app = express();
const port = 3000;
app.use(express.json());

const ENCRYPTION_KEY = process.env.ENCRYPTION_KEY; 

//criptografar senhas
function encrypt(text) {
  const iv = crypto.randomBytes(16);
  const cipher = crypto.createCipheriv('aes-256-cbc', Buffer.from(ENCRYPTION_KEY, 'hex'), iv);
  let encrypted = cipher.update(text, 'utf8', 'hex');
  encrypted += cipher.final('hex');
  return iv.toString('hex') + ':' + encrypted;
}

//descriptografar senhas
function decrypt(text) {
  const [iv, encryptedText] = text.split(':');
  const decipher = crypto.createDecipheriv('aes-256-cbc', Buffer.from(ENCRYPTION_KEY, 'hex'), Buffer.from(iv, 'hex'));
  let decrypted = decipher.update(encryptedText, 'hex', 'utf8');
  decrypted += decipher.final('utf8');
  return decrypted;
}

//cadastrar usuario
app.post('/usuarios', async (req, res) => {
  const { username, senha } = req.body;
  console.log(`Tentando cadastrar o usuário...`);

  try {
    const userRef = collection(db, 'Usuario');
    const userQuery = query(userRef, where("username", "==", username));
    const userSnapshot = await getDocs(userQuery);

    if (!userSnapshot.empty) {
      return res.status(400).json({ error: "O nome de usuário já está em uso." });
    }

    const hashedPassword = await bcrypt.hash(senha, 10);
    const docRef = await addDoc(collection(db, 'Usuario'), {
      username,
      senha: hashedPassword,
    });
    res.status(201).json({ id: docRef.id, username });
  } catch (error) {
    res.status(500).json({ error: "Erro ao criar usuário." });
  }
});

//login
app.post('/login', async (req, res) => {
  const { username, senha } = req.body;
  console.log(`login....`)

  try {
    const userRef = collection(db, 'Usuario');
    const userQuery = query(userRef, where("username", "==", username));
    const userSnapshot = await getDocs(userQuery);

    if (userSnapshot.empty) {
      return res.status(404).json({ message: "Usuário não encontrado." });
    }

    const userData = userSnapshot.docs[0].data();
    
    const match = await bcrypt.compare(senha, userData.senha);
    if (!match) {
      return res.status(401).json({ message: "Senha incorreta." });
    }

    res.status(200).json({ message: "Login bem-sucedido!" });
  } catch (error) {
    res.status(500).json({ error: "Erro ao fazer login." });
  }
});

//criar nova senha
app.post('/usuarios/:username/senhas', async (req, res) => {
  const { username: usernameParam } = req.params;
  const { titulo, descricao, senha, urlImagem } = req.body;
  
  try {
    const userRef = collection(db, 'Usuario');
    const userQuery = query(userRef, where("username", "==", usernameParam));
    const userSnapshot = await getDocs(userQuery);

    if (userSnapshot.empty) {
      return res.status(404).json({ message: "Usuário não encontrado." });
    }

    const userId = userSnapshot.docs[0].id; 

    const senhaRef = collection(db, 'Senha');
    const docRef = await addDoc(senhaRef, {
      titulo,
      descricao,
      senha: encrypt(senha),
      username: usernameParam,
      idUsuario: userId, 
      urlImagem
    });

    res.status(201).json({ id: docRef.id, titulo }); 
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Erro ao criar senha." });
  }
});

//encontrar todas as senhas daquele usuario
app.get('/usuarios/:username/senhas', async (req, res) => {
  const { username } = req.params;

  try {
    const userRef = collection(db, 'Usuario');
    const userQuery = query(userRef, where("username", "==", username));
    const userSnapshot = await getDocs(userQuery);

    if (userSnapshot.empty) {
      return res.status(404).json({ message: "Usuário não encontrado." });
    }

    const userId = userSnapshot.docs[0].id; 

    const senhaRef = collection(db, 'Senha');
    const senhaQuery = query(senhaRef, where("idUsuario", "==", userId)); 
    const senhaSnapshot = await getDocs(senhaQuery);

    if (senhaSnapshot.empty) {
      return res.status(404).json({ message: "Nenhuma senha encontrada para este usuário." });
    }

    const senhas = senhaSnapshot.docs.map(doc => {
      const data = doc.data();
      return {
        id: doc.id,
        titulo: data.titulo,
        descricao: data.descricao,
        senha: decrypt(data.senha), 
        username: data.username, 
        urlImagem: data.urlImagem
      };
    });

    res.status(200).json(senhas);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Erro ao buscar senhas." });
  }
});

//deletar senha
app.delete('/usuarios/:username/senhas/:senhaId', async (req, res) => {
  const { username, senhaId } = req.params;

  try {
    const userRef = collection(db, 'Usuario');
    const userQuery = query(userRef, where("username", "==", username));
    const userSnapshot = await getDocs(userQuery);

    if (userSnapshot.empty) {
      return res.status(404).json({ message: "Usuário não encontrado." });
    }

    const userId = userSnapshot.docs[0].id;

    const senhaRef = collection(db, 'Senha');
    const senhaQuery = query(senhaRef, where("idUsuario", "==", userId), where("__name__", "==", senhaId));
    const senhaSnapshot = await getDocs(senhaQuery);

    if (senhaSnapshot.empty) {
      return res.status(404).json({ message: "Senha não encontrada ou não pertence a este usuário." });
    }

    await deleteDoc(doc(db, 'Senha', senhaId));
    res.status(200).json({ message: "Senha excluída com sucesso." });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Erro ao apagar a senha." });
  }
});

//obter todos os usuarios
app.get('/usuarios', async (req, res) => {
  try {
    const usuarioRef = collection(db, 'Usuario');
    const usuarioSnapshot = await getDocs(usuarioRef);

    const usuarios = usuarioSnapshot.docs.map(doc => ({
      id: doc.id,
      ...doc.data()
    }));

    res.status(200).json(usuarios);
  } catch (error) {
    res.status(500).json({ error: "Erro ao buscar usuários." });
  }
});

//editar senha
app.put('/usuarios/:username/senhas/:senhaId', async (req, res) => {
  const { username, senhaId } = req.params;
  const { titulo, descricao, senha, urlImagem, username: novoUsername } = req.body;

  try {
    const userRef = collection(db, 'Usuario');
    const userQuery = query(userRef, where("username", "==", username));
    const userSnapshot = await getDocs(userQuery);

    if (userSnapshot.empty) {
      return res.status(404).json({ message: "Usuário não encontrado." });
    }

    const userId = userSnapshot.docs[0].id; 

    const senhaRef = collection(db, 'Senha');
    const senhaQuery = query(senhaRef, where("idUsuario", "==", userId), where("__name__", "==", senhaId));
    const senhaSnapshot = await getDocs(senhaQuery);

    if (senhaSnapshot.empty) {
      return res.status(404).json({ message: "Senha não encontrada ou não pertence a este usuário." });
    }

    const updateData = {};
    if (titulo) updateData.titulo = titulo;
    if (descricao) updateData.descricao = descricao;
    if (senha) updateData.senha = encrypt(senha); 
    if (urlImagem) updateData.urlImagem = urlImagem;
    if (novoUsername) updateData.username = novoUsername; 

    await updateDoc(doc(db, 'Senha', senhaId), updateData);

    res.status(200).json({ message: "Senha atualizada com sucesso." });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Erro ao atualizar a senha." });
  }
});

app.listen(port, () => {
  console.log(`Servidor rodando em http://localhost:${port}`);
});
