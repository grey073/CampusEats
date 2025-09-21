package com.campuseats;

public class MenuItem {
    private int id;
    private String itemName;
    private String category;
    private double price;
    private boolean availability;
    private String images;

    public MenuItem(int id, String itemName, String category, double price, boolean availability, String images) {
        this.id = id;
        this.itemName = itemName;
        this.category = category;
        this.price = price;
        this.availability = availability;
        this.images = images;
    }

    public int getId() { return id; }
    public String getItemName() { return itemName; }
    public String getCategory() { return category; }
    public double getPrice() { return price; }
    public boolean isAvailable() { return availability; }
    public String getImages() { return images; }

    public void setAvailable(boolean availability) { this.availability = availability; }
}
