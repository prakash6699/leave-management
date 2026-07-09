# Leave Management System (LMS)

A modern, full-stack Leave Management System built using Spring Boot, Spring Security, JSP templates, and JPA. The application features standard user authentication, statistics dashboards, leave balance trackers, quick actions, approvals management, and custom premium UI designs (glassmorphic user pill, customized action states, and custom colors).

---

## 🚀 Key Features

* **Role-Based Portals:** Custom portals for **ADMIN** and **EMPLOYEE** roles.
* **Dashboard & Metrics:** Live counters for pending requests, approved requests, and leave balances.
* **Leave Requests:** Fully validated apply and edit leave forms (prevents empty/invalid submissions).
* **Approvals Panel:** Admin-exclusive screen to review, approve, or reject employee leave requests with reasons.
* **Seeded Data:** Preloaded test users and sample leave balances.
* **Standardized Header:** Glassmorphic username pills and custom-styled red logout action button across all sub-pages.

---

## 🛠️ Technology Stack

* **Framework:** Spring Boot 3.2.5
* **Security:** Spring Security (Form Login/Logout)
* **Frontend:** JavaServer Pages (JSP), JSTL API, Bootstrap 5, FontAwesome 6
* **Database:** H2 In-Memory Database (with H2 console enabled)
* **ORM:** Spring Data JPA / Hibernate

---

## 💻 Setup & Run Instructions

Since the application requires **Java 17** or higher, if your machine does not have JDK 17 on the global path, you can run the project using the locally configured portable tools:

### 1. Build and Run:
Open a PowerShell terminal in the project directory and execute:
```powershell
$env:JAVA_HOME="C:\Users\Guest user 1\JOTHI\leave-management\tools\jdk-17.0.19+10"
& "C:\Users\Guest user 1\JOTHI\leave-management\tools\apache-maven-3.9.6\bin\mvn.cmd" spring-boot:run
```

### 2. Access the Application:
Open your browser and navigate to:
* **Application Homepage:** [http://localhost:8081](http://localhost:8081)
* **H2 Database Console:** [http://localhost:8081/h2-console](http://localhost:8081/h2-console) (JDBC URL: `jdbc:h2:mem:leavedb`)

---

## 🔐 Seed User Credentials

The database is automatically pre-populated with the following accounts upon startup:

| Role | Username | Password | Email |
| :--- | :--- | :--- | :--- |
| **ADMIN** | `admin` | `admin123` | `admin@company.com` |
| **EMPLOYEE** | `jothi` | `Jothi@123` | `jothi@company.com` |

---

## 📁 Repository Structure
```
leave-management/
├── src/
│   ├── main/
│   │   ├── java/            # Spring Boot controllers, entities, services, and repositories
│   │   ├── resources/       # application.properties configuration
│   │   └── webapp/          # WEB-INF/jsp views and user interface templates
├── tools/                   # Portable JDK 17 & Maven 3.9.6 binaries
├── pom.xml                  # Maven dependency configuration
└── README.md                # Project documentation
```
