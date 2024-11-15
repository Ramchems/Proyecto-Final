const express = require("express");
const bodyParser = require("body-parser");
const session = require("express-session");
const db = require("./db"); // Importar la conexión a la base de datos
const path = require("path"); // Importar el módulo path
const axios = require("axios"); // Importar axios para las solicitudes HTTP

const app = express();
const PORT = 3000;

app.use(bodyParser.json());

// Configuración de sesiones
app.use(
  session({
    secret: "your_secret_key",
    resave: false,
    saveUninitialized: true,
  })
);

// Servir archivos estáticos
app.use(express.static(path.join(__dirname, "public")));

// Crear Tablas
db.query(
  `CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL
)`,
  (err) => {
    if (err) {
      console.error("Error al crear la tabla 'users':", err);
      throw err;
    }
    console.log("Tabla 'users' creada o verificada");
  }
);

db.query(
  `CREATE TABLE IF NOT EXISTS decks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    colors VARCHAR(10),
    likes INT DEFAULT 0,
    commander JSON,
    cards JSON,
    average_rating FLOAT DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES users(id)
);
`,
  (err) => {
    if (err) {
      console.error("Error al crear la tabla 'decks':", err);
      throw err;
    }
    console.log("Tabla 'decks' creada o verificada");
  }
);

db.query(
  `CREATE TABLE IF NOT EXISTS ratings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    deck_id INT,
    rating INT,
    comment TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (deck_id) REFERENCES decks(id)
)`,
  (err) => {
    if (err) throw err;
    console.log("Tabla 'ratings' creada o verificada");
  }
);

db.query(
  `CREATE TABLE IF NOT EXISTS likes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    deck_id INT,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (deck_id) REFERENCES decks(id)
);
`,
  (err) => {
    if (err) throw err;
    console.log("Tabla 'likes' creada o verificada");
  }
);

db.query(
  `CREATE TABLE IF NOT EXISTS comments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    deck_id INT,
    comment TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (deck_id) REFERENCES decks(id)
)`,
  (err) => {
    if (err) throw err;
    console.log("Tabla 'comments' creada o verificada");
  }
);

db.query(
  `CREATE TABLE IF NOT EXISTS favorites (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    deck_id INT,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (deck_id) REFERENCES decks(id)
)`,
  (err) => {
    if (err) throw err;
    console.log("Tabla 'favorites' creada o verificada");
  }
);

// Ruta para la raíz
app.get("/", (req, res) => {
  res.sendFile(path.join(__dirname, "public", "index.html"));
});
// Ruta para el registro de usuarios
app.post("/api/register", (req, res) => {
  const { username, email, password } = req.body;
  console.log("Datos recibidos para registro:", username, email, password);
  db.query(
    "INSERT INTO users (username, email, password) VALUES (?, ?, ?)",
    [username, email, password],
    (err, result) => {
      if (err) {
        console.error("Error en el registro:", err);
        res.status(500).send("Error en el registro");
        return;
      }
      res.status(201).send("Registro exitoso");
    }
  );
});

// Ruta para el inicio de sesión
app.post("/api/login", (req, res) => {
  const { userOrEmail, password } = req.body;

  db.query(
    "SELECT * FROM users WHERE (username = ? OR email = ?) AND password = ?",
    [userOrEmail, userOrEmail, password],
    (err, results) => {
      if (err) {
        res.status(500).send("Error en el inicio de sesión");
        return;
      }
      if (results.length === 0) {
        res
          .status(401)
          .send("Correo, nombre de usuario o contraseña incorrectos");
        return;
      }
      req.session.userId = results[0].id;
      req.session.username = results[0].username; // Almacenar el nombre de usuario en la sesión
      res.json({ user: results[0] });
    }
  );
});

// Ruta para verificar si el usuario está autenticado
app.get("/api/auth", (req, res) => {
  if (req.session.userId) {
    res.json({ authenticated: true, username: req.session.username }); // Devolver el nombre de usuario
  } else {
    res.status(401).send("Usuario no autenticado");
  }
});

// Ruta para cerrar sesión
app.post("/api/logout", (req, res) => {
  req.session.destroy((err) => {
    if (err) {
      res.status(500).send("Error al cerrar sesión");
      return;
    }
    res.status(200).send("Sesión cerrada correctamente");
  });
});

// Ruta para la búsqueda de decks
app.get("/api/decks/search", (req, res) => {
  const { name, colors, cardName } = req.query;

  let query = "SELECT * FROM decks WHERE 1=1";
  let queryParams = [];

  if (name) {
    query += " AND name LIKE ?";
    queryParams.push(`%${name}%`);
  }

  if (colors) {
    query += " AND colors LIKE ?";
    queryParams.push(`%${colors}%`);
  }

  if (cardName) {
    query +=
      " AND EXISTS (SELECT 1 FROM cards WHERE deck_id = decks.id AND card_name LIKE ?)";
    queryParams.push(`%${cardName}%`);
  }

  db.query(query, queryParams, (err, results) => {
    if (err) {
      res.status(500).send("Error al buscar decks");
      return;
    }
    res.json(results);
  });
});

// Ruta para crear un nuevo deck
app.post("/api/decks", (req, res) => {
  const { name, description, colors } = req.body;
  const userId = req.session.userId; // Asumiendo que el usuario está autenticado

  if (!userId) {
    return res.status(401).send("Usuario no autenticado");
  }

  db.query(
    "INSERT INTO decks (user_id, name, description, colors) VALUES (?, ?, ?, ?)",
    [userId, name, description, colors],
    (err, result) => {
      if (err) {
        console.error("Error al crear el deck:", err);
        return res.status(500).send("Error al crear el deck");
      }
      res.status(201).send("Deck creado exitosamente");
    }
  );
});

// Ruta para buscar cartas usando la API de Scryfall
app.get("/api/cards/search", async (req, res) => {
  const { query } = req.query;

  try {
    const response = await axios.get(
      `https://api.scryfall.com/cards/search?q=${encodeURIComponent(query)}`
    );
    res.json(response.data);
  } catch (err) {
    console.error("Error al buscar cartas:", err);
    res.status(500).send("Error al buscar cartas");
  }
});

// Ruta para el formulario de registro
app.get("/register.html", (req, res) => {
  res.sendFile(path.join(__dirname, "public", "register.html"));
});

// Ruta para el formulario de inicio de sesión
app.get("/login.html", (req, res) => {
  res.sendFile(path.join(__dirname, "public", "login.html"));
});

// Ruta para el formulario de creación de decks
app.get("/contr-deck.html", (req, res) => {
  res.sendFile(path.join(__dirname, "public", "contr-deck.html"));
});

// Ruta para guardar el deck
app.post("/api/save-deck", (req, res) => {
  if (!req.session.userId) {
    return res.status(401).send("Usuario no autenticado");
  }

  const { deckName, mainDeck, commander } = req.body;
  const userId = req.session.userId;

  // Convertir los objetos a JSON
  const commanderJSON = JSON.stringify(commander);
  const mainDeckJSON = JSON.stringify(mainDeck);

  // Insertar el deck en la tabla `decks`
  const sql =
    "INSERT INTO decks (user_id, name, commander, cards) VALUES (?, ?, ?, ?)";
  db.query(
    sql,
    [userId, deckName, commanderJSON, mainDeckJSON],
    (err, results) => {
      if (err) {
        console.error("Error al guardar el deck:", err);
        res.status(500).send("Error al guardar el deck");
        return;
      }
      res.send("Deck guardado exitosamente");
    }
  );
});
// Ruta para obtener los decks del usuario
app.get("/api/users/:userId/decks", (req, res) => {
  const userId = req.params.userId;
  db.query(
    "SELECT * FROM decks WHERE user_id = ?",
    [userId],
    (err, results) => {
      if (err) {
        console.error("Error al obtener decks del usuario:", err);
        res.status(500).send("Error al obtener decks del usuario");
        return;
      }
      res.json(results);
    }
  );
});

// Ruta para obtener todos los decks de todos los usuarios con los nombres de usuario
app.get("/api/decks", (req, res) => {
  const sql = `
      SELECT decks.*, users.username AS user 
      FROM decks 
      JOIN users ON decks.user_id = users.id
  `;
  db.query(sql, (err, results) => {
    if (err) {
      console.error("Error al obtener los decks:", err);
      res.status(500).send("Error al obtener los decks");
      return;
    }
    res.json(results);
  });
});

// Obtener los detalles de un deck
app.get("/api/decks/:deckId", async (req, res) => {
  const deckId = req.params.deckId;
  const sql = `
      SELECT decks.*, users.username AS user 
      FROM decks 
      JOIN users ON decks.user_id = users.id
      WHERE decks.id = ?
  `;

  try {
    const [results] = await db.promise().query(sql, [deckId]);

    if (results.length > 0) {
      let deck = results[0];
      deck.cards = JSON.parse(deck.cards);
      deck.commander = JSON.parse(deck.commander);

      // Llamar a la API de Scryfall para obtener las imágenes de las cartas
      const cardDetailsPromises = deck.cards.map(async (card) => {
        const response = await fetch(
          `https://api.scryfall.com/cards/named?exact=${encodeURIComponent(
            card.name
          )}`
        );
        const cardData = await response.json();
        return {
          ...card,
          imageUrl: cardData.image_uris.normal,
        };
      });

      const commanderResponse = await fetch(
        `https://api.scryfall.com/cards/named?exact=${encodeURIComponent(
          deck.commander.name
        )}`
      );
      const commanderData = await commanderResponse.json();
      deck.commander.imageUrl = commanderData.image_uris.normal;

      deck.cards = await Promise.all(cardDetailsPromises);

      res.json(deck);
    } else {
      res.status(404).send("Deck no encontrado");
    }
  } catch (err) {
    console.error("Error al obtener el deck:", err);
    res.status(500).send("Error al obtener el deck");
  }
});

// Manejar "me gusta" en un deck
app.post("/api/decks/:deckId/like", (req, res) => {
  if (!req.session.userId) {
    return res.status(401).send("Usuario no autenticado");
  }

  const deckId = req.params.deckId;
  const userId = req.session.userId;

  // Verificar si el usuario ya dio "me gusta" a este deck
  const checkLikeSql = "SELECT * FROM likes WHERE deck_id = ? AND user_id = ?";
  db.query(checkLikeSql, [deckId, userId], (err, results) => {
    if (err) {
      console.error('Error al verificar "me gusta":', err);
      res.status(500).send('Error al verificar "me gusta"');
      return;
    }

    if (results.length > 0) {
      res.status(400).send('Ya has dado "me gusta" a este deck');
    } else {
      // Insertar "me gusta"
      const insertLikeSql =
        "INSERT INTO likes (deck_id, user_id) VALUES (?, ?)";
      db.query(insertLikeSql, [deckId, userId], (err) => {
        if (err) {
          console.error('Error al dar "me gusta":', err);
          res.status(500).send('Error al dar "me gusta"');
          return;
        }

        // Actualizar el contador de "me gusta"
        const updateLikesSql =
          "UPDATE decks SET likes = likes + 1 WHERE id = ?";
        db.query(updateLikesSql, [deckId], (err) => {
          if (err) {
            console.error(
              'Error al actualizar el contador de "me gusta":',
              err
            );
            res
              .status(500)
              .send('Error al actualizar el contador de "me gusta"');
            return;
          }

          // Obtener el número actualizado de "me gusta"
          const getLikesSql = "SELECT likes FROM decks WHERE id = ?";
          db.query(getLikesSql, [deckId], (err, results) => {
            if (err) {
              console.error('Error al obtener los "me gusta":', err);
              res.status(500).send('Error al obtener los "me gusta"');
              return;
            }
            res.json(results[0].likes);
          });
        });
      });
    }
  });
});

// Añadir un comentario a un deck
app.post("/api/decks/:deckId/comments", (req, res) => {
  if (!req.session.userId) {
    return res.status(401).send("Usuario no autenticado");
  }

  const deckId = req.params.deckId;
  const userId = req.session.userId;
  const { text } = req.body;
  const sql =
    "INSERT INTO comments (deck_id, user_id, comment) VALUES (?, ?, ?)";
  db.query(sql, [deckId, userId, text], (err, results) => {
    if (err) {
      console.error("Error al añadir el comentario:", err);
      res.status(500).send("Error al añadir el comentario");
      return;
    }
    res.send("Comentario añadido exitosamente");
  });
});

// Obtener los comentarios de un deck
app.get("/api/decks/:deckId/comments", (req, res) => {
  const deckId = req.params.deckId;
  const sql = `
      SELECT comments.*, users.username 
      FROM comments 
      JOIN users ON comments.user_id = users.id
      WHERE deck_id = ?
  `;
  db.query(sql, [deckId], (err, results) => {
    if (err) {
      console.error("Error al obtener los comentarios:", err);
      res.status(500).send("Error al obtener los comentarios");
      return;
    }
    res.json(results);
  });
});

const port = process.env.PORT || 3000;

// Asegúrate de que el puerto esté disponible
app.listen(port, () => {
  console.log(`Servidor corriendo en http://localhost:${port}`);
});
