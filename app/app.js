const express = require("express")
const moment = require('moment-timezone');

const app = express()

// Ruta para obtener la hora de Lima y Austin
app.get("/", (req, res) => {
  // Obtener la hora actual de Lima y Austin
  const limaTime = moment.tz('America/Lima').format('YYYY-MM-DD HH:mm:ss');
  const austinTime = moment.tz('America/Chicago').format('YYYY-MM-DD HH:mm:ss');
  const santiagoTime = moment.tz('America/Santiago').format('YYYY-MM-DD HH:mm:ss')

  // Enviar la hora al cliente como JSON
  res.setHeader('Content-Type', 'application/json');
  res.send(JSON.stringify({ limaTime, austinTime , santiagoTime}));
});

app.get("/ping", (req, res) => {
  res.send({ success: true })
})

// Iniciar el servidor en el puerto 3000
app.listen(process.env.PORT || 3000, () => {
  console.log("Server is listening on port 3000")
})

module.exports = app; // Exportar la aplicación para pruebas
