Clear-Host
Write-Host "=== DipOut Backend Interactive Setup ===" -ForegroundColor Cyan

# Ask for environment values
$port = Read-Host "Enter PORT (default 5000)"
if (-not $port) { $port = "5000" }

$dbUrl = Read-Host "Enter your Render DATABASE_URL"
$jwt = Read-Host "Enter your JWT_SECRET (anything you want)"

Write-Host "`nCreating folders..." -ForegroundColor Yellow

# Create folders
mkdir config -ErrorAction SilentlyContinue
mkdir routes -ErrorAction SilentlyContinue
mkdir controllers -ErrorAction SilentlyContinue
mkdir middleware -ErrorAction SilentlyContinue

Write-Host "Folders created." -ForegroundColor Green

Write-Host "`nWriting .env..." -ForegroundColor Yellow

# Write .env file
@"
PORT=$port
DATABASE_URL=$dbUrl
JWT_SECRET=$jwt
"@ | Set-Content -Path ".env"

Write-Host ".env created." -ForegroundColor Green

Write-Host "`nWriting config/db.js..." -ForegroundColor Yellow

# Write db.js
@"
const { Pool } = require('pg');
require('dotenv').config();

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: { rejectUnauthorized: false }
});

module.exports = pool;
"@ | Set-Content -Path "config\db.js"

Write-Host "db.js created." -ForegroundColor Green

Write-Host "`nWriting server.js..." -ForegroundColor Yellow

# Write server.js
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

const PORT = process.env.PORT || $port;
app.listen(PORT, () => console.log('Server running on port ' + PORT));
"@ | Set-Content -Path "server.js"

Write-Host "server.js created." -ForegroundColor Green

Write-Host "`nCreating empty route and controller files..." -ForegroundColor Yellow

# Create empty route + controller files
New-Item -Path "routes\auth.js" -ItemType File -Force | Out-Null
New-Item -Path "routes\trips.js" -ItemType File -Force | Out-Null
New-Item -Path "routes\drivers.js" -ItemType File -Force | Out-Null

New-Item -Path "controllers\authController.js" -ItemType File -Force | Out-Null
New-Item -Path "controllers\tripsController.js" -ItemType File -Force | Out-Null
New-Item -Path "controllers\driversController.js" -ItemType File -Force | Out-Null

New-Item -Path "middleware\auth.js" -ItemType File -Force | Out-Null

Write-Host "All backend files created successfully!" -ForegroundColor Green

Write-Host "`n=== Setup Complete ===" -ForegroundColor Cyan
Write-Host "You can now edit your routes, controllers, and middleware."
