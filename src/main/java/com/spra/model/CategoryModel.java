package com.spra.model;

import java.sql.Timestamp;

/**
 * CategoryModel
 * Represents a product category (Skincare, Makeup, etc.)
 *
 * @author Spra Team
 */
public class CategoryModel {

    private int       categoryId;
    private String    name;
    private String    description;
    private Timestamp createdAt;

    // ---- No-arg constructor ----
    public CategoryModel() {}

    // ---- Full constructor ----
    public CategoryModel(int categoryId, String name, String description, Timestamp createdAt) {
        this.categoryId  = categoryId;
        this.name        = name;
        this.description = description;
        this.createdAt   = createdAt;
    }

    // ---- Getters & Setters ----

    public int getCategoryId()                      { return categoryId; }
    public void setCategoryId(int categoryId)       { this.categoryId = categoryId; }

    public String getName()                         { return name; }
    public void setName(String name)                { this.name = name; }

    public String getDescription()                  { return description; }
    public void setDescription(String desc)         { this.description = desc; }

    public Timestamp getCreatedAt()                 { return createdAt; }
    public void setCreatedAt(Timestamp t)           { this.createdAt = t; }
}
