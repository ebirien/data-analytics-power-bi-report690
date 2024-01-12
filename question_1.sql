SELECT SUM(staff_numbers) AS Staff_in_UK_Stores
FROM dim_store
WHERE country = 'UK';