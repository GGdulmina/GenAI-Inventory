package model;

import java.sql.Date;

/**
 * Product / Item model – maps to the `products` table.
 * @author id43
 */
public class Item {

    private int    id;
    private String name;
    private String category;
    private int    quantity;
    private double price;
    private String description;
    private int    minStockLevel;
    private int    maxStockLevel;
    private Date   expiryDate;

    // Constructors
    public Item() {}

    public Item(int id, String name, String category, int quantity, double price) {
        this.id       = id;
        this.name     = name;
        this.category = category;
        this.quantity = quantity;
        this.price    = price;
    }

    // ---------- Getters & Setters ----------
    public int    getId()                          { return id; }
    public void   setId(int id)                    { this.id = id; }

    public String getName()                        { return name; }
    public void   setName(String name)             { this.name = name; }

    public String getCategory()                    { return category; }
    public void   setCategory(String category)     { this.category = category; }

    public int    getQuantity()                    { return quantity; }
    public void   setQuantity(int quantity)         { this.quantity = quantity; }

    public double getPrice()                       { return price; }
    public void   setPrice(double price)           { this.price = price; }

    public String getDescription()                 { return description; }
    public void   setDescription(String desc)      { this.description = desc; }

    public int    getMinStockLevel()               { return minStockLevel; }
    public void   setMinStockLevel(int min)        { this.minStockLevel = min; }

    public int    getMaxStockLevel()               { return maxStockLevel; }
    public void   setMaxStockLevel(int max)        { this.maxStockLevel = max; }

    public Date   getExpiryDate()                  { return expiryDate; }
    public void   setExpiryDate(Date expiryDate)   { this.expiryDate = expiryDate; }
}