create database `Data Analysis`;
use `Data Analysis`;
---- Retrieve the Patient_id & ages of all patients -----
select patient_id,age from diabetes_prediction;


---- Select all female patients who are older than 40 -----
select * from diabetes_prediction where gender = 'Female' and age > 40;


----- Calculate the average BMI of patients -----
select avg(bmi) as Average_BMI from diabetes_prediction;


----- List patients in descending order of blood glucose levels -----
select * from diabetes_prediction order by blood_glucose_level desc;


----- Find patients who have hypertension and diabetes -----
select * from diabetes_prediction where hypertension = 1 and diabetes = 1;


----- Determine the number of patients with heart disease ----- 
select count(heart_disease) as Num_heart_disease_patients from diabetes_prediction;


----- Group patients by smoking history and count how many smokers and nonsmokers there are -----
select smoking_history,count(smoking_history) from diabetes_prediction group by smoking_history;


----- Retrieve the Patient_ids of patients who have a BMI greater than the average BMI -----
select patient_id from diabetes_prediction where bmi > (select avg(bmi) from diabetes_prediction);


----- Find the patient with the highest HbA1c level and the patient with the lowest HbA1clevel -----
select (select patient_id from diabetes_prediction where HbA1c_level = (select max(HbA1c_level) from diabetes_prediction) order by patient_id limit 1) as Highest_HbA1c_level_Patient, 
(Select patient_id from diabetes_prediction where HbA1c_level = (select min(HbA1c_level) from diabetes_prediction) order by patient_id limit 1) as Lowest_HbA1c_level_Patient;


----- Calculate the age of patients in years (assuming the current date as of now) -----
select *, FLOOR(DATEDIFF(CURDATE(), age) / 365.25) AS Age_in_years from diabetes_prediction;


----- Rank patients by blood glucose level within each gender group -----
select patient_id,gender,blood_glucose_level, rank() over (partition by gender order by blood_glucose_level) as glucose_level_rank from diabetes_prediction;


----- Update the smoking history of patients who are older than 50 to "Ex-smoker -----
Create temporary table tempdp select patient_id from diabetes_prediction where age > 50;
Set SQL_SAFE_UPDATES = 0;
update diabetes_prediction as dp set dp.smoking_history = 'Ex-smoker' Where dp.patient_id in (select patient_id from tempdp);
Set SQL_SAFE_UPDATES = 1;


----- Insert a new patient into the database with sample data -----
insert into diabetes_prediction (EmployeeName,Patient_id,gender,age,hypertension,heart_disease,smoking_history,bmi,
HbA1c_level,blood_glucose_level,diabetes) 
values ('Nilesh Dhangar','PT100101','Male',24,0,0,'Never',25.5,5.7,110,0),
       ('Snehal Deshmukh ', 'PT100102', 'Female', 50, 1, 0, 'Ex-smoker', 30.2, 6.1, 125, 1),
	   ('Ashish Shinde', 'PT100103', 'Male', 55, 0, 1, 'Smoker', 27.8, 7.3, 140, 1);
       
       
----- Delete all patients with heart disease from the database -----
create temporary table temp_table as select * from diabetes_prediction where  heart_disease = 1;
set sql_safe_updates = 0;
delete from diabetes_prediction as dp where heart_disease = 1;
set sql_safe_updates = 1;


----- Find patients who have hypertension but not diabetes using the EXCEPT operator -----
select * from diabetes_prediction dp1 where dp1.hypertension = 1 and not exists (select 1 from diabetes_prediction dp2 where dp2.patient_id = dp1.patient_id and dp2.diabetes = 1);


----- Define a unique constraint on the "patient_id" column to ensure its values are unique -----
alter table diabetes_prediction add constraint unique_patient_id unique (patient_id(255));


select * from patient_info;

