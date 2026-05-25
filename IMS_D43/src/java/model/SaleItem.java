package model;

/**
 * SaleItem model – one line in a sales invoice.
 * @author id43
 */
public class SaleItem {

    private int    id;
    private int    saleId;
    private int    productId;
    private String productName;   // joined from products table
    private int    quantity;
    private double unitPrice;
    private double subtotal;

    public SaleItem() {}

    // ---------- Getters & Setters ----------
    public int    getId()                          { return id; }
    public void   setId(int id)                    { this.id = id; }

    public int    getSaleId()                      { return saleId; }
    public void   setSaleId(int saleId)            { this.saleId = saleId; }

    public int    getProductId()                   { return productId; }
    public void   setProductId(int productId)      { this.productId = productId; }

    public String getProductName()                 { return productName; }
    public void   setProductName(String n)         { this.productName = n; }

    public int    getQuantity()                    { return quantity; }
    public void   setQuantity(int quantity)         { this.quantity = quantity; }

    public double getUnitPrice()                   { return unitPrice; }
    public void   setUnitPrice(double p)           { this.unitPrice = p; }

    public double getSubtotal()                    { return subtotal; }
    public void   setSubtotal(double s)            { this.subtotal = s; }
}
