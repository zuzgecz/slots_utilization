# 📊 Monitoring Exam Slot Utilization

## 🎯 Project Goal
The goal of this project was to create a solution for **monitoring the utilization of exam slots** in the system.  
The challenge was that an **exam slot was not linked to a specific subject** – instead, it was shared across all subjects and levels for which a teacher had examination rights.  

As a result, in order to realistically track exam occupancy, it was necessary to build logic that assigns slots to subjects and education levels.

---

## 🛠 Data Challenges
1. **No unique slot definition per subject** – a slot could potentially be available for multiple subjects and levels.  
2. **Information split across two tables**:  
   - the `calendar_event` table contains general information about added slots (slot type, recurrence),  
   - the `event_term` table stores detailed data about each specific exam slot instance.  
3. The need to distinguish between:  
   - **shared slots** (available slots),  
   - **booked slots** (already taken),  
   - **free slots** (available but not booked). 

---

## ✅ Proposed Solution
The query was built using **CTEs (Common Table Expressions)** to split the logic into clear steps:  

1. **booked_list** – list of all booked slots (students assigned to terms).  
2. **shared_list** – list of all slots shared by examiners.  
3. **booked** – aggregated count of booked slots per subject and level.  
4. **shared** – aggregated count of shared slots and calculation of free slots.  
5. **final select** – `full join` of both aggregates to produce a complete view.  

---

## 📂 Project Structure
- **`slots.sql`** → full SQL query
- **`README.md`** → project description 
- **`example_output.jpg`** → sample output of the query

---

## 📈 Outcome
The query allows to:  
- identify overall exam slot utilization,  
- quickly check the number of available free slots,  
- control exam availability per subject and level,  
- support exam planning and teacher resource management.  
