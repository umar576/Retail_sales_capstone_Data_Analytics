# Retail_sales_capstone_Data_Analytics
End-to-End Retail Data Cleaning and Preprocessing project using Python (Pandas, NumPy) including feature engineering, data validation, and preparation for SQL analysis and Power BI dashboards.
# 🧹 Retail Data Cleaning & Preprocessing (Python Project)

## 📌 Project Overview
This project focuses on cleaning, preprocessing, and transforming raw retail datasets into a structured format suitable for analysis and visualization.

The goal is to ensure data quality, consistency, and reliability before performing SQL analysis and building Power BI dashboards.

---

## 📂 Datasets Used

- sales_data.csv  
- customers.csv  
- products.csv  
- stores.csv  
- returns.csv  

---

## 🛠️ Tools & Technologies

- Python  
- Pandas  
- NumPy  

---

## 🧱 Data Processing Workflow

### 🔹 1. Data Type Standardization
- Converted date columns (order_date, signup_date, return_date) into proper datetime format  
- Ensured numeric columns are correctly stored (int, float)  

---

### 🔹 2. Duplicate Handling
- Identified duplicate records using primary keys  
- Removed duplicates to avoid incorrect analysis  

---

### 🔹 3. Missing Value Treatment
- Detected null and missing values  
- Applied:
  - Removal for invalid records  
  - Retention where logically acceptable (e.g., online sales without store_id)  

---

## 📊 Dataset-wise Cleaning

### 🛒 Sales Data
- Validated quantity and price values  
- Verified discount percentages  
- Ensured total amount consistency  
- Created derived columns:
  - Revenue  
  - Profit  

---

### 👥 Customer Data
- Removed invalid age values  
- Grouped customers into age categories  
- Standardized gender values  
- Validated region names  

---

### 📦 Product Data
- Checked cost vs selling price  
- Calculated profit margin percentage  
- Standardized category and brand names  

---

### 🏬 Store Data
- Validated operating costs  
- Ensured region and city consistency  
- Handled nullable store_id for online sales  

---

### 🔁 Returns Data
- Ensured each return is linked to a valid order  
- Removed orphan return records  
- Standardized return reasons  

---

## ⚙️ Feature Engineering

- Profit calculation  
- Return rate calculation  
- Customer tenure  
- Age group segmentation  

---

## 📈 Outcome

After preprocessing:
- Cleaned datasets were generated  
- Data became ready for SQL analysis  
- Enabled accurate and reliable Power BI dashboards  

---

## 🎯 Business Value

This project helps:
- Improve data quality for decision-making  
- Enable accurate KPI tracking  
- Support business insights like profit, returns, and customer behavior  

---

## 🚀 Future Enhancements

- Automate pipeline using Python scripts  
- Add SQL integration  
- Build Power BI dashboard  
- Implement advanced analytics (customer segmentation, churn prediction)  

---

## 👤 Author

**Brahma (Data Analyst)**  
- Skilled in Python, SQL, Power BI, Excel  
- Focused on data cleaning, analytics, and business insights  

---

## ⭐ Support

If you like this project, give it a ⭐ on GitHub!
