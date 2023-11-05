/* Number of users and daily averages, maximums, and minimums */ 
	
--1) Tracking physical activities 

SELECT 
	COUNT(DISTINCT Id) As users_tracking_activity,
	AVG(TotalSteps) AS average_steps,
	AVG(TotalDistance) AS average_distance,
	AVG(Calories) AS average_calories 

FROM 
	bellabeat.dbo.daily_activity_cleaned

--2) Tracking heart rate

SELECT
	COUNT(DISTINCT Id) AS users_tracking_heartRate,
	AVG(Value) AS average_heartRate,
	MIN(Value) AS minimum_heartRate,
	MAX(Value) AS maximum_heartRate

FROM 
	bellabeat.dbo.heartrate_seconds_2

--3) Tracking sleep

SELECT 
	COUNT(DISTINCT Id) AS users_tracking_sleep,
	AVG(TotalMinutesAsleep)/60.0 AS average_hours_asleep,
	MIN(TotalMinutesAsleep)/60.0 AS minimum_hours_asleep,
	MAX(TotalMinutesAsleep)/60.0 AS maximum_hours_asleep,
	AVG(TotalTimeInBed)/60.0 AS average_hours_inBed

FROM
	bellabeat.dbo.sleep_day_2

--4) Tracking weight

SELECT
	COUNT(DISTINCT Id) AS users_tracking_weight,
	AVG(WeightKg) AS average_weight_kg,
	AVG(WeightPounds) As average_weight_pounds,
	MIN(WeightKg) AS minimum_weight_kg,
	MIN (WeightPounds) AS minimum_weight_pounds,
	MAX(WeightKg) AS maximum_weight_kg,
	MAX(WeightPounds) AS maximum_weight_pounds

FROM
	bellabeat.dbo.weight_cleaned

/* Calculating METs */ 

SELECT 
	*
FROM
	bellabeat.dbo.minuteMETsNarrow_2

ORDER BY 
	METs DESC

/* Calculating the largest weight in Kilograms descending */

SELECT Id,
	ROUND (WeightKg, 2) AS WeightKg,
	ROUND (WeightPounds, 1) AS WeightPounds

FROM 
	bellabeat.dbo.weight_log_info

ORDER BY 
	WeightKg DESC

/* A loook at weight in both Kilograms and Pounds */ 

SELECT 
	ROUND (MAX(WeightKg),2) AS MaxKg,
	ROUND (MIN(WeightKg), 2) AS MinKg,
	ROUND (AVG(WeightKg), 2) AS AvgKg,
	ROUND (MAX(WeightPounds), 1) AS MaxPounds,
	ROUND (MIN(WeightPounds), 1) AS MinPounds,
	ROUND (AVG(WeightPounds), 1) AS AvgPounds
FROM
	bellabeat.dbo.weight_log_info

/* Determining when users were most active */ 

SELECT
	DISTINCT (CAST(ActivityHour AS TIME)) AS activity_time,
	AVG(TotalIntensity) OVER (PARTITION BY DATEPART(HOUR, ActivityHour)) AS average_intensity,
	AVG(METs) OVER (PARTITION BY DATEPART(HOUR, ActivityHour)) AS average_METs
FROM
	bellabeat.dbo.hourly_activity AS hourly_activity 
JOIN 
	bellabeat.dbo.minuteMETsNarrow_2 AS METs
ON 
	hourly_activity.Id = METs.Id
AND 
	hourly_activity.ActivityHour = METs.ActivityMinute
ORDER BY 
	activity_time DESC	

/* Calculate the number of days each user tracked physical activity */

SELECT
	DISTINCT Id,
	COUNT(ActivityDate) OVER (PARTITION BY Id) AS days_activity_recorded

FROM
	bellabeat.dbo.daily_activity_cleaned

ORDER BY
	days_activity_recorded DESC

--Calculate average minutes for each activity

SELECT 
	ROUND (AVG(VeryActiveMinutes),2) AS AVG_VeryActiveMinutes,
	ROUND (AVG(FairlyActiveMinutes),2) AS AVG_FairlyActiveMinutes,
	ROUND (AVG(LightlyActiveMinutes)/60,2) AS AVG_LightlyActiveHours,
	ROUND (AVG(SedentaryMinutes)/60,2) AS AVG_SedentaryHours

FROM
	bellabeat.dbo.daily_activity_cleaned

/* Calculating heart rate */

SELECT 
	* 
FROM 
	bellabeat.dbo.heartrate_seconds_2

