package com.campuseats;

import java.sql.Timestamp;
import java.util.List;

public class Order {
    private int orderId;
    private int userId;
    private double totalAmount;
    private String paymentStatus; // Paid/Pending
    private String orderStatus;   // Ready/Pending
    private Timestamp orderDate;
    private List<OrderItem> items;

    public Order(int orderId, int userId, double totalAmount, String paymentStatus,
                 String orderStatus, Timestamp orderDate, List<OrderItem> items) {
        this.orderId = orderId;
        this.userId = userId;
        this.totalAmount = totalAmount;
        this.paymentStatus = paymentStatus;
        this.orderStatus = orderStatus;
        this.orderDate = orderDate;
        this.items = items;
    }

    // Getters
    public int getOrderId() { return orderId; }
    public int getUserId() { return userId; }
    public double getTotalAmount() { return totalAmount; }
    public String getPaymentStatus() { return paymentStatus; }
    public String getOrderStatus() { return orderStatus; }
    public Timestamp getOrderDate() { return orderDate; }
    public List<OrderItem> getItems() { return items; }
}
