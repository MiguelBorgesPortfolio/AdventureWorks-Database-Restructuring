# AdventureWorks Database Restructuring

## 📌 About the Project  
This project focuses on the **restructuring of the AdventureWorks database**, a cycling equipment company that previously relied on an outdated system and Excel files for data management.  
The objective was to **migrate and optimize the database**, ensuring data normalization, access management, performance improvements, and backup strategies.  

---

## 🛠 Technologies Used  
- **SQL Server**  
- **MongoDB** (for reporting and data analysis)  

---

## 📂 Database Implementation  
The project consists of several structured components:  

### **1️⃣ Database Schema and Optimization**  
- **Entity-Relationship Model (ERD)** and **Relational Model** redesigned for **3rd Normal Form (3NF)** compliance.  
- **Data migration** from the old system to the new structured model.  
- **Views, Stored Procedures, Functions, and Triggers** to automate operations and enforce business rules.  

### **2️⃣ Data Management and Access Control**  
- **User Authentication** with role-based access (Administrator, SalesPerson, and Territory Managers).  
- **Password recovery system** using **security questions and encrypted storage**.  
- **Access control policies** ensuring restricted access to specific data segments.  

### **3️⃣ Performance Optimization**  
- **Indexing Strategies** to enhance query performance for sales reports and customer insights.  
- **Query Optimization** using **SQL Profiler and Tuning Advisor**.  
- **Concurrency Control** with appropriate **transaction isolation levels**.  

### **4️⃣ Backup and Recovery Strategy**  
- **Full, Differential, and Transaction Log Backups** scheduled based on system load.  
- **Disaster recovery plans** covering hardware failure, accidental deletion, and software corruption.  
- **Data redundancy measures** using off-site backups for disaster scenarios.  

### **5️⃣ NoSQL Integration with MongoDB**  
- **AdventureWorksWeb** database created in **MongoDB** for reporting without impacting transactional performance.  
- **Data synchronization scripts** between SQL Server and MongoDB.  
- **Predefined queries for sales analysis**, including sales per model, product, and year.  

---

## ⚡ Key Features  
✔ **Secure user authentication and password management**.  
✔ **Comprehensive data migration and validation**.  
✔ **Optimized SQL queries for sales analytics**.  
✔ **Efficient backup and recovery mechanisms**.  
✔ **MongoDB integration for lightweight reporting**.  

