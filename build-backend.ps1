# Create folders
mkdir config -ErrorAction SilentlyContinue
mkdir routes -ErrorAction SilentlyContinue
mkdir controllers -ErrorAction SilentlyContinue
mkdir middleware -ErrorAction SilentlyContinue

# Create files
New-Item -Path ".env" -ItemType File -Force
New-Item -Path "server.js" -ItemType File -Force
New-Item -Path "config\db.js" -ItemType File -Force
New-Item -Path "routes\auth.js" -ItemType File -Force
New-Item -Path "routes\trips.js" -ItemType File -Force
New-Item -Path "routes\drivers.js" -ItemType File -Force
New-Item -Path "controllers\authController.js" -ItemType File -Force
New-Item -Path "controllers\tripsController.js" -ItemType File -Force
New-Item -Path "controllers\driversController.js" -ItemType File -Force
New-Item -Path "middleware\auth.js" -ItemType File -Force

# Write starter content into server.js
@"
const express = require('express');
const cors = require('cors');
require('dotenv').config();
const db = require('./config/db');

const app = express();
app.use(cors());
app.use(express.json());

app.get('/', (req, res) => {
  res.send('DipOut backend is running');
});

app.get('/health', async (req, res) => {
  try {
    const result = await db.query('SELECT NOW()');
    res.json({ status: 'ok', time: result.rows[0].now });
  } catch (err) {
    res.status(500).json({ status: 'error', message: 'DB connection failed' });
  }
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log('Server running on port ' + PORT));
"@ | Set-Content -Path "server.js"

# Write starter content into db.js
@"
const { Pool } = require('pg');
require('dotenv').config();

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: { rejectUnauthorized: false }
});

module.exports = pool;
"@ | Set-Content -Path "config\db.js"

Write-Host "Backend folder structure created successfully!"
