const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');
require('dotenv').config();

const app = express();
const port = process.env.PORT || 3000;

// Middleware
app.use(cors({
  origin: ['http://localhost:5173', 'http://localhost:80', 'http://localhost'],
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type']
}));
app.use(express.json());

// Database configuration
const pool = new Pool({
    user: process.env.POSTGRES_USER,
    host: process.env.POSTGRES_HOST,
    database: process.env.POSTGRES_DB,
    password: process.env.POSTGRES_PASSWORD,
    port: 5432,
});

// Routes

// Get all items
app.get('/api/inventory', async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM inventory_items ORDER BY id');
        res.json(result.rows);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Get single item
app.get('/api/inventory/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const result = await pool.query('SELECT * FROM inventory_items WHERE id = $1', [id]);
        if (result.rows.length === 0) {
            return res.status(404).json({ message: 'Item not found' });
        }
        res.json(result.rows[0]);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Create new item
app.post('/api/inventory', async (req, res) => {
    try {
        const { name, description, price, quantity, category, sku } = req.body;
        const result = await pool.query(
            'INSERT INTO inventory_items (name, description, price, quantity, category, sku) VALUES ($1, $2, $3, $4, $5, $6) RETURNING *',
            [name, description, price, quantity, category, sku]
        );
        res.status(201).json(result.rows[0]);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Update item
app.put('/api/inventory/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const { name, description, price, quantity, category, sku } = req.body;
        const result = await pool.query(
            'UPDATE inventory_items SET name = $1, description = $2, price = $3, quantity = $4, category = $5, sku = $6 WHERE id = $7 RETURNING *',
            [name, description, price, quantity, category, sku, id]
        );
        if (result.rows.length === 0) {
            return res.status(404).json({ message: 'Item not found' });
        }
        res.json(result.rows[0]);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Delete item
app.delete('/api/inventory/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const result = await pool.query('DELETE FROM inventory_items WHERE id = $1 RETURNING *', [id]);
        if (result.rows.length === 0) {
            return res.status(404).json({ message: 'Item not found' });
        }
        res.json({ message: 'Item deleted successfully' });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

app.listen(port, () => {
    console.log(`Server running on port ${port}`);
});
