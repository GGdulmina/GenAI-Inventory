-- ============================================================
-- Smart Inventory Management System – Database Schema
-- Database: inventory_db
-- ============================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

DROP DATABASE IF EXISTS inventory_db;
CREATE DATABASE inventory_db CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE inventory_db;

-- ─────────────────────────────────────────────
-- TABLE: users
-- ─────────────────────────────────────────────
CREATE TABLE users (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    username    VARCHAR(50)  NOT NULL UNIQUE,
    password    VARCHAR(255) NOT NULL,
    role        VARCHAR(20)  NOT NULL DEFAULT 'staff',
    created_at  TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

INSERT INTO users (username, password, role) VALUES
('admin', 'admin123', 'admin'),
('staff', 'staff123', 'staff');

-- ─────────────────────────────────────────────
-- TABLE: products
-- ─────────────────────────────────────────────
CREATE TABLE products (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    name            VARCHAR(100) NOT NULL,
    category        VARCHAR(50)  DEFAULT NULL,
    quantity        INT          NOT NULL DEFAULT 0,
    price           DECIMAL(10,2) NOT NULL,
    description     TEXT,
    min_stock_level INT          NOT NULL DEFAULT 10,
    max_stock_level INT          NOT NULL DEFAULT 500,
    expiry_date     DATE         DEFAULT NULL,
    created_at      TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 50 Supermarket / Retail Products
INSERT INTO products (name, category, quantity, price, description, min_stock_level, max_stock_level, expiry_date) VALUES
('Fresh Milk 1L',           'Dairy',        120, 1.99,  'Full cream fresh milk',              20, 300, DATE_ADD(CURDATE(), INTERVAL 5 DAY)),
('Cheddar Cheese 250g',     'Dairy',         85, 4.49,  'Mature cheddar block',               15, 200, DATE_ADD(CURDATE(), INTERVAL 30 DAY)),
('Greek Yogurt 500g',       'Dairy',         60, 3.29,  'Natural Greek yogurt',               10, 150, DATE_ADD(CURDATE(), INTERVAL 14 DAY)),
('Butter 200g',             'Dairy',         95, 2.79,  'Salted butter',                      10, 200, DATE_ADD(CURDATE(), INTERVAL 60 DAY)),
('White Bread Loaf',        'Bakery',       200, 1.49,  'Sliced white bread',                 30, 400, DATE_ADD(CURDATE(), INTERVAL 4 DAY)),
('Whole Wheat Bread',       'Bakery',       150, 1.89,  'Sliced wholemeal bread',              25, 350, DATE_ADD(CURDATE(), INTERVAL 4 DAY)),
('Croissants 4-Pack',       'Bakery',        40, 3.99,  'Butter croissants',                  10, 100, DATE_ADD(CURDATE(), INTERVAL 3 DAY)),
('Basmati Rice 5kg',        'Grains',       300, 8.99,  'Premium basmati rice',               50, 600, DATE_ADD(CURDATE(), INTERVAL 365 DAY)),
('Spaghetti 500g',          'Grains',       250, 1.29,  'Durum wheat spaghetti',              40, 500, DATE_ADD(CURDATE(), INTERVAL 365 DAY)),
('Corn Flakes 500g',        'Breakfast',    180, 3.49,  'Crispy corn flakes cereal',          20, 300, DATE_ADD(CURDATE(), INTERVAL 180 DAY)),
('Instant Oats 1kg',        'Breakfast',    140, 2.99,  'Quick cook porridge oats',           15, 250, DATE_ADD(CURDATE(), INTERVAL 270 DAY)),
('Orange Juice 1L',         'Beverages',    160, 2.49,  '100% pure orange juice',             20, 300, DATE_ADD(CURDATE(), INTERVAL 10 DAY)),
('Coca-Cola 1.5L',          'Beverages',    400, 1.79,  'Carbonated soft drink',              50, 800, DATE_ADD(CURDATE(), INTERVAL 180 DAY)),
('Mineral Water 6-Pack',    'Beverages',    350, 2.99,  'Natural spring water',               40, 700, NULL),
('Green Tea 25-Pack',       'Beverages',    100, 2.49,  'Japanese green tea bags',            15, 200, DATE_ADD(CURDATE(), INTERVAL 365 DAY)),
('Instant Coffee 200g',     'Beverages',     90, 5.99,  'Freeze-dried instant coffee',        10, 200, DATE_ADD(CURDATE(), INTERVAL 365 DAY)),
('Chicken Breast 1kg',      'Meat',          70, 7.99,  'Boneless skinless chicken breast',   10, 150, DATE_ADD(CURDATE(), INTERVAL 3 DAY)),
('Beef Mince 500g',         'Meat',          55, 6.49,  'Lean beef mince',                    10, 120, DATE_ADD(CURDATE(), INTERVAL 3 DAY)),
('Pork Sausages 6-Pack',    'Meat',          45, 4.99,  'Traditional pork sausages',          10, 100, DATE_ADD(CURDATE(), INTERVAL 5 DAY)),
('Salmon Fillet 200g',      'Seafood',       30, 8.99,  'Fresh Atlantic salmon fillet',        8, 80,  DATE_ADD(CURDATE(), INTERVAL 2 DAY)),
('Tuna Canned 185g',        'Seafood',      200, 1.99,  'Tuna chunks in spring water',       30, 400, DATE_ADD(CURDATE(), INTERVAL 730 DAY)),
('Bananas 1kg',             'Fruits',       300, 1.29,  'Fresh ripe bananas',                 40, 600, DATE_ADD(CURDATE(), INTERVAL 5 DAY)),
('Red Apples 6-Pack',       'Fruits',       200, 2.99,  'Royal Gala apples',                  25, 400, DATE_ADD(CURDATE(), INTERVAL 14 DAY)),
('Strawberries 400g',       'Fruits',        60, 3.99,  'Fresh strawberries punnet',          10, 120, DATE_ADD(CURDATE(), INTERVAL 3 DAY)),
('Avocado 2-Pack',          'Fruits',        80, 2.49,  'Ripe & ready avocados',              10, 150, DATE_ADD(CURDATE(), INTERVAL 5 DAY)),
('Potatoes 2kg',            'Vegetables',   250, 2.49,  'White potatoes',                     30, 500, DATE_ADD(CURDATE(), INTERVAL 21 DAY)),
('Onions 1kg',              'Vegetables',   220, 1.49,  'Brown onions',                       25, 450, DATE_ADD(CURDATE(), INTERVAL 30 DAY)),
('Tomatoes 6-Pack',         'Vegetables',   180, 1.99,  'Vine-ripened tomatoes',              20, 350, DATE_ADD(CURDATE(), INTERVAL 7 DAY)),
('Broccoli Head',           'Vegetables',   100, 1.79,  'Fresh broccoli crown',               15, 200, DATE_ADD(CURDATE(), INTERVAL 5 DAY)),
('Carrots 1kg',             'Vegetables',   200, 1.29,  'Fresh carrots',                      25, 400, DATE_ADD(CURDATE(), INTERVAL 14 DAY)),
('Olive Oil 500ml',         'Cooking',      130, 4.99,  'Extra virgin olive oil',             15, 250, DATE_ADD(CURDATE(), INTERVAL 365 DAY)),
('Sunflower Oil 1L',        'Cooking',      110, 2.49,  'Refined sunflower oil',              15, 250, DATE_ADD(CURDATE(), INTERVAL 365 DAY)),
('Tomato Ketchup 500ml',    'Condiments',   160, 2.29,  'Classic tomato ketchup',             20, 300, DATE_ADD(CURDATE(), INTERVAL 180 DAY)),
('Mayonnaise 400ml',        'Condiments',   120, 2.79,  'Real egg mayonnaise',                15, 250, DATE_ADD(CURDATE(), INTERVAL 120 DAY)),
('Soy Sauce 250ml',         'Condiments',    90, 1.99,  'Naturally brewed soy sauce',         10, 200, DATE_ADD(CURDATE(), INTERVAL 365 DAY)),
('Salt 1kg',                'Spices',       300, 0.99,  'Fine table salt',                    40, 600, NULL),
('Black Pepper 100g',       'Spices',       150, 1.99,  'Ground black pepper',                15, 300, DATE_ADD(CURDATE(), INTERVAL 365 DAY)),
('Sugar 1kg',               'Baking',       280, 1.29,  'Granulated white sugar',             35, 500, NULL),
('All-Purpose Flour 1.5kg', 'Baking',       200, 1.49,  'Plain white flour',                  25, 400, DATE_ADD(CURDATE(), INTERVAL 365 DAY)),
('Eggs 12-Pack',            'Dairy',        150, 3.49,  'Free-range large eggs',              20, 300, DATE_ADD(CURDATE(), INTERVAL 21 DAY)),
('Chocolate Bar 100g',      'Snacks',       250, 1.49,  'Milk chocolate bar',                 30, 500, DATE_ADD(CURDATE(), INTERVAL 180 DAY)),
('Potato Chips 150g',       'Snacks',       200, 1.99,  'Salted potato chips',                25, 400, DATE_ADD(CURDATE(), INTERVAL 120 DAY)),
('Biscuit Assortment 400g', 'Snacks',       130, 3.49,  'Mixed biscuit selection',            15, 250, DATE_ADD(CURDATE(), INTERVAL 180 DAY)),
('Ice Cream 1L',            'Frozen',        60, 4.99,  'Vanilla ice cream tub',              10, 120, DATE_ADD(CURDATE(), INTERVAL 365 DAY)),
('Frozen Pizza',            'Frozen',        80, 3.99,  'Margherita frozen pizza',            10, 150, DATE_ADD(CURDATE(), INTERVAL 180 DAY)),
('Frozen Peas 1kg',         'Frozen',       100, 1.79,  'Garden peas frozen',                 15, 200, DATE_ADD(CURDATE(), INTERVAL 365 DAY)),
('Laundry Detergent 2L',    'Household',    110, 6.99,  'Liquid laundry detergent',           15, 200, NULL),
('Dish Soap 500ml',         'Household',    130, 1.99,  'Lemon dish washing liquid',          15, 250, NULL),
('Toilet Paper 9-Pack',     'Household',    180, 4.99,  'Soft white toilet rolls',            25, 350, NULL),
('Paper Towels 4-Pack',     'Household',    140, 3.49,  'Absorbent kitchen towels',           20, 300, NULL);

-- ─────────────────────────────────────────────
-- TABLE: sales
-- ─────────────────────────────────────────────
CREATE TABLE sales (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    invoice_number  VARCHAR(20)   NOT NULL UNIQUE,
    sale_date       TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    total_amount    DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    user_id         INT           NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id)
) ENGINE=InnoDB;

-- ─────────────────────────────────────────────
-- TABLE: sale_items
-- ─────────────────────────────────────────────
CREATE TABLE sale_items (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    sale_id     INT           NOT NULL,
    product_id  INT           NOT NULL,
    quantity    INT           NOT NULL,
    unit_price  DECIMAL(10,2) NOT NULL,
    subtotal    DECIMAL(12,2) NOT NULL,
    FOREIGN KEY (sale_id)    REFERENCES sales(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
) ENGINE=InnoDB;

SET FOREIGN_KEY_CHECKS = 1;
