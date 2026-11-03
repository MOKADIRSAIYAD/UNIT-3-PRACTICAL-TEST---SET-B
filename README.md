# GRID_SQL_U3_SetB

**Name:** YOUR NAME HERE
**GRID:** YOUR GRID HERE
**Test:** SQL - Unit 3 (Joins and Subqueries) Practical Test - Set B
**Database:** `hospital_db` (MySQL Workbench)

## Repository Structure

```
GRID_SQL_U3_SetB/
|
+-- README.md
+-- GRID_SQL_U3_SetB.sql
|
+-- Screenshots/
    +-- Q01_Setup.png
    +-- Q02_Inner_Join.png ... Q18_Exists.png (18 files)
```

## What I Practised (Sections A to E)

- **Section A - Database Setup (Q1):** Created the database and tables with primary and foreign keys, loaded the data, and counted rows in every table using `UNION ALL`.
- **Section B - INNER JOIN (Q2-Q4):** Joined two and four tables with aliases and `ON`, filtered with `WHERE`, and summarised data using `GROUP BY` with `COUNT` and `SUM`.
- **Section C - LEFT, RIGHT and FULL OUTER JOIN (Q5-Q8):** Kept unmatched rows with outer joins, used `COALESCE` for default text, found missing rows with `IS NULL`, and simulated FULL OUTER JOIN using `UNION`.
- **Section D - CROSS JOIN and SELF JOIN (Q9-Q12):** Built all combinations with `CROSS JOIN`, and joined the staff table to itself for supervisors, same-ward pairs and two-level supervisors.
- **Section E - Subqueries (Q13-Q18):** Used scalar, `IN` / `NOT IN`, derived table, SELECT-list, correlated and `EXISTS` / `NOT EXISTS` subqueries.

## When do you use LEFT JOIN instead of INNER JOIN?

Use `LEFT JOIN` when you want every row from the left table, even if it has no match in the right table (the right columns show `NULL`).
Use `INNER JOIN` only when you want rows that have a match in both tables.

## The Two Hardest Questions

**1. Q14 (c) - NOT IN with NULL**
The query returned an empty set even though Radiology has no drive. The reason is that the `drives` table has a `NULL` ward_id (Wellness Run). When a `NOT IN` list contains `NULL`, the comparison becomes UNKNOWN for every row, so nothing is returned. I fixed it in (b) by adding `WHERE ward_id IS NOT NULL` inside the subquery.

**2. Q17 - Correlated subquery**
I had to compare each staff member's pay with the average of their own ward. The inner query uses the outer row (`e2.ward_id = e.ward_id`), so it runs again for each outer row. Gita (ward is `NULL`) is never returned because `NULL = NULL` is not true, so her average is `NULL`.

## Git Commits

1. Add setup and INNER JOIN queries
2. Add OUTER, CROSS and SELF JOIN queries
3. Add subquery solutions and README
