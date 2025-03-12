-- Create inventory items table
CREATE TABLE inventory_items (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    quantity INTEGER NOT NULL,
    category VARCHAR(100),
    sku VARCHAR(50) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create trigger to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_inventory_items_updated_at
    BEFORE UPDATE ON inventory_items
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Insert some sample data
INSERT INTO inventory_items (name, description, price, quantity, category, sku) VALUES
    ('Laptop', 'High-performance gaming laptop', 1299.99, 10, 'Electronics', 'LAP-001'),
    ('Smartphone', 'Latest model smartphone', 899.99, 15, 'Electronics', 'PHN-001'),
    ('Headphones', 'Wireless noise-canceling headphones', 199.99, 20, 'Accessories', 'HEAD-001');
