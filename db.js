const mysql = require("mysql2");

const db = mysql.createConnection({
  host: "localhost", // Servidor MySQL de XAMPP
  user: "root", // Usuario por defecto de MySQL en XAMPP
  password: "", // La contraseña por defecto suele ser vacía
  database: "magic_decks", // Nombre de la base de datos que has creado
});

db.connect((err) => {
  if (err) {
    console.error("Error conectando a la base de datos:", err.stack);
    return;
  }
  console.log("Conectado a la base de datos MySQL");
});

module.exports = db;
