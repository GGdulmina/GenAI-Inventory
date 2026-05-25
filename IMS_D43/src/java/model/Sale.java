package model;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.List;
import java.util.ArrayList;

/**
 * Sale model – represents a single sales transaction.
 * @author id43
 */
public class Sale {

    private int        id;
    private String     invoiceNumber;
    private Timestamp  saleDate;
    private BigDecimal totalAmount;
    private int        userId;
    private String     username;          // joined from users table
    private List<SaleItem> items = new ArrayList<>();

    public Sale() {}

    // ---------- Getters & Setters ----------
    public int        getId()                          { return id; }
    public void       setId(int id)                    { this.id = id; }

    public String     getInvoiceNumber()               { return invoiceNumber; }
    public void       setInvoiceNumber(String inv)     { this.invoiceNumber = inv; }

    public Timestamp  getSaleDate()                    { return saleDate; }
    public void       setSaleDate(Timestamp d)         { this.saleDate = d; }

    public BigDecimal getTotalAmount()                 { return totalAmount; }
    public void       setTotalAmount(BigDecimal t)     { this.totalAmount = t; }

    public int        getUserId()                      { return userId; }
    public void       setUserId(int userId)            { this.userId = userId; }

    public String     getUsername()                     { return username; }
    public void       setUsername(String u)             { this.username = u; }

    public List<SaleItem> getItems()                   { return items; }
    public void setItems(List<SaleItem> items)          { this.items = items; }
}