// app.js

const express = require('express');
const moment = require('moment-timezone');

const app = express();

app.get('/', (req, res) => {
  const limaTime = moment.tz('America/Lima').format('YYYY-MM-DD HH:mm:ss');
  const austinTime = moment.tz('America/Chicago').format('YYYY-MM-DD HH:mm:ss');
  
  const responseText = `Hora de Lima: ${limaTime}\n Hora de Austin: ${austinTime}`;
  res.send(responseText);
});

app.listen(3000, () => {
  console.log('Servidor iniciado en el puerto 3000');
});

module.exports = app; // Exportar la aplicación para pruebas
