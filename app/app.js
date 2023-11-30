// app.js
'use strict';

const express = require('express');
const moment = require('moment-timezone');

const app = express();

// Ruta para obtener la hora de Lima y Austin
app.get('/', (req, res) => {
  // Obtener la hora actual de Lima y Austin
  const limaTime = moment.tz('America/Lima').format('YYYY-MM-DD HH:mm:ss');
  const austinTime = moment.tz('America/Chicago').format('YYYY-MM-DD HH:mm:ss');

  // Enviar la hora al cliente como JSON
  res.setHeader('Content-Type', 'application/json');
  res.json({ limaTime, austinTime });
});

app.get("/ping", (req, res) => {
  res.send({ success: true })
})

// Iniciar el servidor en el puerto 3000
const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Servidor iniciado en el puerto ${PORT}`);
  console.log('Press Ctrl+C to quit.');
});



module.exports = app; // Exportar la aplicación para pruebas