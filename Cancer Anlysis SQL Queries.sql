create database cancer_analysis;

use cancer_analysis;

CREATE TABLE lung_cancer_data (
    ID INT PRIMARY KEY,
    Country VARCHAR(255),
    Population_Size INT,
    Age INT,
    Gender VARCHAR(10),
    Smoker VARCHAR(3),
    Years_of_Smoking INT,
    Cigarettes_per_Day INT,
    Passive_Smoker VARCHAR(3),
    Family_History VARCHAR(3),
    Lung_Cancer_Diagnosis VARCHAR(3),
    Cancer_Stage VARCHAR(50),
    Survival_Years INT,
    Adenocarcinoma_Type VARCHAR(50),
    Air_Pollution_Exposure VARCHAR(10),
    Occupational_Exposure VARCHAR(3),
    Indoor_Pollution VARCHAR(3),
    Healthcare_Access VARCHAR(50),
    Early_Detection VARCHAR(3),
    Treatment_Type VARCHAR(50),
    Developed_or_Developing VARCHAR(50),
    Annual_Lung_Cancer_Deaths INT,
    Lung_Cancer_Prevalence_Rate FLOAT,
    Mortality_Rate FLOAT
);

select * from lung_cancer_data;

-- Basic Level
-- 1. Retrieve all records for individuals diagnosed with lung cancer.
select * from lung_cancer_data where Lung_Cancer_Diagnosis="Yes";

-- 2. Count the number of smokers and non-smokers.
select smoker, count(*) as Total_Count from lung_cancer_data
group by smoker
order by total_count desc;

# OR

select 
case
when smoker in ("No") then "Non-Smoker"  
when smoker in ("Yes") then "Smoker"
else "None"
end as smoking_status,
Count(*) as total_count
from lung_cancer_data
group by smoking_status
order by total_count desc;

-- 3. List all unique cancer stages present in the dataset.
select distinct Cancer_Stage from lung_cancer_data where cancer_stage != "None";

-- 4. Retrieve the average number of cigarettes smoked per day by smokers.
select smoker, avg(Cigarettes_per_Day) as avg_cigarettes_per_day
from lung_cancer_data
where smoker = "Yes"
group by smoker;

-- 5. Count the number of people exposed to high air pollution.
select Air_Pollution_Exposure, count(*) as number_of_people
from lung_cancer_data
where Air_Pollution_Exposure="High"
group by Air_Pollution_Exposure;

-- 6. Find the top 5 countries with the highest lung cancer deaths.
select country, sum(Annual_Lung_Cancer_Deaths) as lung_cancer_deaths
from lung_cancer_data
group by country
order by lung_cancer_deaths desc
limit 5;

-- 7. Count the number of people diagnosed with lung cancer by gender.
select gender,count(*) as people_diagnosed
from lung_cancer_data
where Lung_Cancer_Diagnosis="Yes"
group by gender
order by people_diagnosed desc;

-- 8. Retrieve records of individuals older than 60 who are diagnosed with lung cancer.
select * from lung_cancer_data
where age>60
and Lung_Cancer_Diagnosis="Yes";


-- Intermediate Level
-- 1. Find the percentage of smokers who developed lung cancer.
select 
(count(case when smoker="yes" and Lung_Cancer_Diagnosis="Yes" then 1 end)*100
/count(case when smoker="yes" then 1 end))
as percentage_of_smoker
from lung_cancer_data;

-- 2. Calculate the average survival years based on cancer stages.
select cancer_stage,avg(survival_years) as average_survival_years_based_on_cancer_stages
from lung_cancer_data
where cancer_stage!="None" and Lung_Cancer_Diagnosis="Yes"
group by cancer_stage;

-- 3. Count the number of lung cancer patients based on passive smoking.
select Passive_Smoker, count(*) as lung_cancer_patients_count
from lung_cancer_data
where Lung_Cancer_Diagnosis="Yes"
group by passive_smoker;

-- 4. Find the country with the highest lung cancer prevalence rate.
select country,Lung_Cancer_Prevalence_Rate
from lung_cancer_data
order by Lung_Cancer_Prevalence_Rate desc
limit 1;

-- 5. Identify the smoking years' impact on lung cancer.
select 
case
when Years_of_Smoking<10 then "0-9 Years"
when Years_of_Smoking between 10 and 20 then "10-20 years"
when Years_of_Smoking between 20 and 30 then "20-30 years"
when Years_of_Smoking>30 then "30+ years"
else "None"
end as Years_of_Smoking_category, 
count(*) as lung_cancer_count
from lung_cancer_data
where Lung_Cancer_Diagnosis="Yes"
group by Years_of_Smoking_category
order by lung_cancer_count desc;

-- 6. Determine the mortality rate for patients with and without early detection.
select early_detection,avg(mortality_rate) as mortality_rate
from lung_cancer_data
group by early_detection;

#or

select 
case 
when early_detection = "No" then "Without early detection"
when early_detection = "yes" then "With early detection"
else "None"
end as with_and_without_early_detection,
avg(Mortality_rate) as mortality_date
from lung_cancer_data
group by with_and_without_early_detection
order by mortality_date desc;

-- 7. Group the lung cancer prevalence rate by developed vs. developing countries.
select Developed_or_Developing, avg(Lung_Cancer_Prevalence_Rate) as avg_Lung_Cancer_Prevalence_Rate
from lung_cancer_data
group by Developed_or_Developing
order by avg_Lung_Cancer_Prevalence_Rate desc;

-- Advanced Level
-- 1. Identify the correlation between lung cancer prevalence and air pollution levels.
select 
    (COUNT(*) * SUM(Lung_Cancer_Prevalence_Rate * 
                    CASE 
                        WHEN Air_Pollution_Exposure = 'low' THEN 1
                        WHEN Air_Pollution_Exposure = 'medium' THEN 2
                        WHEN Air_Pollution_Exposure = 'high' THEN 3
                    END) - SUM(Lung_Cancer_Prevalence_Rate) * SUM(
                        CASE 
                            WHEN Air_Pollution_Exposure = 'low' THEN 1
                            WHEN Air_Pollution_Exposure = 'medium' THEN 2
                            WHEN Air_Pollution_Exposure = 'high' THEN 3
                        END)) / 
    SQRT((COUNT(*) * SUM(POW(Lung_Cancer_Prevalence_Rate, 2)) - POW(SUM(Lung_Cancer_Prevalence_Rate), 2)) * 
         (COUNT(*) * SUM(POW(
                            CASE 
                                WHEN Air_Pollution_Exposure = 'low' THEN 1
                                WHEN Air_Pollution_Exposure = 'medium' THEN 2
                                WHEN Air_Pollution_Exposure = 'high' THEN 3
                            END, 2)) - POW(SUM(
                            CASE 
                                WHEN Air_Pollution_Exposure = 'low' THEN 1
                                WHEN Air_Pollution_Exposure = 'medium' THEN 2
                                WHEN Air_Pollution_Exposure = 'high' THEN 3
                            END), 2))) AS correlation_coefficient
FROM lung_cancer_data;

-- 2. Find the average age of lung cancer patients for each country.
select country,avg(age) as average_age_of_lung_cancer_patients
from lung_cancer_data
where Lung_Cancer_Diagnosis="Yes"
group by country;

-- 3. Calculate the risk factor of lung cancer by smoker status, passive smoking, and family history.
select smoker,passive_smoker,family_history,
count(case when Lung_Cancer_Diagnosis="Yes" then 1 end) as diagonised_with_cancer,
count(*) as total_patients,
(count(case when Lung_Cancer_Diagnosis="Yes" then 1 end)*1.0/count(*)) as diagnosis_rate,
avg(case when Lung_Cancer_Diagnosis="Yes" then 1 else 0 end) as risk_factor
from lung_cancer_data
group by smoker,passive_smoker,family_history;

-- 4. Rank countries based on their mortality rate.
select country,mortality_rate,rank()over(order by mortality_rate desc) as ranks
from lung_cancer_data
order by ranks;

-- 5. Determine if treatment type has a significant impact on survival years.
select treatment_type,
case
when Survival_Years<10 then "0-9 years"
when Survival_Years between 10 and 20 then "10-20 years"
when Survival_Years between 20 and 30 then "20-30 years"
else "Above 30 "
end as Survival_Years_category,
count(*) as patients
from lung_cancer_data
group by treatment_type,Survival_Years_category
order by patients desc;

#OR

SELECT Treatment_Type, AVG(Survival_Years) AS average_survival_years
FROM lung_cancer_data
GROUP BY Treatment_Type;

-- 6. Compare lung cancer prevalence in men vs. women across countries.
select country,gender, avg(Lung_Cancer_Prevalence_Rate) as Avg_Lung_Cancer_Prevalence_Rate
from lung_cancer_data
group by country,gender
order by country,gender;

-- 7. Find how occupational exposure, smoking, and air pollution collectively impact lung cancer rates.
select Occupational_Exposure,smoker,Air_Pollution_Exposure,
count(case when Lung_Cancer_Diagnosis="Yes" then 1 end) as lung_cancer_patinets,
count(*) as total_patients,
(count(case when Lung_Cancer_Diagnosis="Yes" then 1 else 0 end)*1.0/count(*)) as lung_cancer_rate
from lung_cancer_data
group by Occupational_Exposure,smoker,Air_Pollution_Exposure;

-- 8. Analyze the impact of early detection on survival years.
select early_detection, avg(survival_years) as avg_survival_years
from lung_cancer_data
group by early_detection
order by  avg_survival_years desc;






