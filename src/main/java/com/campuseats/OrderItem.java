package com.campuseats;

public class OrderItem {
    private int id;
    private int orderId;
    private int itemId;
    private String name;
    private double price;
    private int quantity;

    public OrderItem(int id, int orderId, int itemId, String name, double price, int quantity) {
        this.id = id;
        this.orderId = orderId;
        this.itemId = itemId;
        this.name = name;
        this.price = price;
        this.quantity = quantity;
    }

    public int getId() { return id; }
    public int getOrderId() { return orderId; }
    public int getItemId() { return itemId; }
    public String getName() { return name; }
    public double getPrice() { return price; }
    public int getQuantity() { return quantity; }
}
