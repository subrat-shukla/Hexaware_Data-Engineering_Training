create database OYO_Business;
use OYO_Business;

select *from [dbo].[Oyo_City_CSV]

select *from [dbo].[Oyo_Sales_CSV]


--1. Average Room Rates of Different Cities
WITH CityAverage AS (
    SELECT 
        oc.city,
        AVG(os.amount / NULLIF(os.no_of_rooms, 0)) AS average_room_rate
    FROM Oyo_Sales_CSV os
    JOIN Oyo_City_CSV oc ON os.hotel_id = oc.hotel_id
    WHERE os.status != 'Cancelled'
    GROUP BY oc.city
)
SELECT * FROM CityAverage;


--2. Number of Bookings in Different Cities for January, February, and March
SELECT 
    oc.city,
    MONTH(os.date_of_booking) AS month,
    COUNT(os.booking_id) AS booking_count
FROM Oyo_Sales_CSV os
JOIN Oyo_City_CSV oc ON os.hotel_id = oc.hotel_id
WHERE MONTH(os.date_of_booking) IN (1, 2, 3)
GROUP BY oc.city, MONTH(os.date_of_booking)
ORDER BY oc.city, month;


--3. Frequency of Early Bookings Prior to Check-in
SELECT 
    CASE 
        WHEN DATEDIFF(DAY, os.date_of_booking, os.check_in) = 0 THEN 'Same Day'
        WHEN DATEDIFF(DAY, os.date_of_booking, os.check_in) <= 3 THEN 'Within 3 Days'
        WHEN DATEDIFF(DAY, os.date_of_booking, os.check_in) BETWEEN 4 AND 30 THEN 'Within a Month'
        WHEN DATEDIFF(DAY, os.date_of_booking, os.check_in) > 30 THEN 'Over a Month'
    END AS booking_timeframe,
    COUNT(os.booking_id) AS booking_frequency
FROM Oyo_Sales_CSV os
GROUP BY 
    CASE 
        WHEN DATEDIFF(DAY, os.date_of_booking, os.check_in) = 0 THEN 'Same Day'
        WHEN DATEDIFF(DAY, os.date_of_booking, os.check_in) <= 3 THEN 'Within 3 Days'
        WHEN DATEDIFF(DAY, os.date_of_booking, os.check_in) BETWEEN 4 AND 30 THEN 'Within a Month'
        WHEN DATEDIFF(DAY, os.date_of_booking, os.check_in) > 30 THEN 'Over a Month'
    END
ORDER BY booking_frequency DESC;


--4. Frequency of Bookings Based on Number of Rooms
SELECT 
    os.no_of_rooms,
    COUNT(os.booking_id) AS booking_frequency
FROM Oyo_Sales_CSV os
GROUP BY os.no_of_rooms
ORDER BY booking_frequency DESC;


--5. New Customers in January
WITH JanuaryBookings AS (
    SELECT customer_id, MIN(date_of_booking) AS first_booking_date
    FROM Oyo_Sales_CSV
    GROUP BY customer_id
)
SELECT COUNT(customer_id) AS new_customers
FROM JanuaryBookings
WHERE MONTH(first_booking_date) = 1;


--6. Net Revenue to Company (Excluding Cancelled Bookings)
SELECT 
    SUM(os.amount - os.discount) AS net_revenue
FROM Oyo_Sales_CSV os
WHERE os.status != 'Cancelled';


--7. Gross Revenue to Company (Including All Bookings)
SELECT 
    SUM(os.amount - os.discount) AS gross_revenue
FROM Oyo_Sales_CSV os;


--8. Average Room Rates of Different Cities (Repeated for Clarity)
WITH CityAverage AS (
    SELECT 
        oc.city,
        AVG(os.amount / NULLIF(os.no_of_rooms, 0)) AS average_room_rate
    FROM Oyo_Sales_CSV os
    JOIN Oyo_City_CSV oc ON os.hotel_id = oc.hotel_id
    WHERE os.status != 'Cancelled'
    GROUP BY oc.city
)
SELECT * FROM CityAverage;


--9. Find the Percentage of Cancellations for Each City
SELECT 
    oc.city,
    COUNT(CASE WHEN os.status = 'Cancelled' THEN 1 END) * 100.0 / COUNT(*) 
	AS cancellation_rate_percentage
FROM Oyo_Sales_CSV os
JOIN Oyo_City_CSV oc ON os.hotel_id = oc.hotel_id
GROUP BY oc.city
ORDER BY cancellation_rate_percentage DESC;


--10. List All Hotels in Cities with High Average Booking Amount (Above a Certain Threshold)
SELECT 
    oc.city, 
    os.hotel_id, 
    AVG(os.amount) AS average_booking_amount
FROM Oyo_Sales_CSV os
JOIN Oyo_City_CSV oc ON os.hotel_id = oc.hotel_id
GROUP BY oc.city, os.hotel_id
HAVING AVG(os.amount) > 15000
ORDER BY average_booking_amount DESC;


--11. Count of Bookings by Month for a Specific City (e.g., 'Delhi')
SELECT 
    DATENAME(MONTH, os.date_of_booking) AS booking_month, 
    COUNT(os.booking_id) AS booking_count
FROM Oyo_Sales_CSV os
JOIN Oyo_City_CSV oc ON os.hotel_id = oc.hotel_id
WHERE oc.city = 'Delhi'
GROUP BY DATENAME(MONTH, os.date_of_booking), MONTH(os.date_of_booking)
ORDER BY MONTH(os.date_of_booking);


--12. Average Length of Stay for Each City
SELECT 
    oc.city,
    AVG(DATEDIFF(DAY, os.check_in, os.check_out)) AS avg_stay_length
FROM Oyo_Sales_CSV os
JOIN Oyo_City_CSV oc ON os.hotel_id = oc.hotel_id
WHERE os.status != 'Cancelled'
GROUP BY oc.city
ORDER BY avg_stay_length DESC;


--13. Total Revenue and Average Discount Given for Each Month
SELECT 
    DATENAME(MONTH, os.date_of_booking) AS booking_month,
    SUM(os.amount - os.discount) AS total_revenue,
    AVG(os.discount) AS average_discount
FROM Oyo_Sales_CSV os
WHERE os.status != 'Cancelled'
GROUP BY DATENAME(MONTH, os.date_of_booking), MONTH(os.date_of_booking)
ORDER BY MONTH(os.date_of_booking);
