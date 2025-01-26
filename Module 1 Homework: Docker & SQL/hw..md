# 1
    docker run -it --entrypoint bash python:3.12.8
    pip --version
    

# 2
    hostname is "db"
    internal post used to connect to postgres database is "5432"

# 3
#in terminal
    docker-compose up -d

    wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-10.csv.gz
    gunzip green_tripdata_2019-10.csv.gz
    wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/misc/taxi_zone_lookup.csv

#in jupyter notebook
#upload csv files

#in terminal
    pgcli -h localhost -U root -d ny_taxi

#in pgadmin SQL
SELECT 
    COUNT(CASE WHEN trip_distance <= 1 THEN 1 END) AS "Up to 1 mile",
    COUNT(CASE WHEN trip_distance > 1 AND trip_distance <= 3 THEN 1 END) AS "Between 1 and 3 miles",
    COUNT(CASE WHEN trip_distance > 3 AND trip_distance <= 7 THEN 1 END) AS "Between 3 and 7 miles",
    COUNT(CASE WHEN trip_distance > 7 AND trip_distance <= 10 THEN 1 END) AS "Between 7 and 10 miles",
    COUNT(CASE WHEN trip_distance > 10 THEN 1 END) AS "Over 10 miles"
FROM 
    green_taxi_data
WHERE 
    lpep_pickup_datetime >= '2019-10-01' 
    AND lpep_pickup_datetime < '2019-11-01'
	AND lpep_dropoff_datetime < '2019-11-01';

# 4
#in pgadmin SQL
SELECT date_trunc('day', lpep_pickup_datetime), max(trip_distance)
FROM green_taxi_data
GROUP BY 1
ORDER BY 2 desc

# 5
#in pgadmin SQL
SELECT "Zone", sum(total_amount) as total_amount
FROM green_taxi_data 
LEFT JOIN taxi_zone_lookup on "PULocationID" = "LocationID"
WHERE date_trunc('day', lpep_pickup_datetime) = '2019-10-18' 
GROUP BY 1
HAVING sum(total_amount) > 13000
ORDER BY 2 desc

# 6
#in pgadmin SQL
WITH main AS (
SELECT "DOLocationID", MAX(tip_amount) as max_tip
FROM green_taxi_data 
LEFT JOIN taxi_zone_lookup on "PULocationID" = "LocationID"
WHERE lpep_pickup_datetime >= '2019-10-01' 
    AND lpep_pickup_datetime < '2019-11-01'
	AND "Zone" = 'East Harlem North'
GROUP BY 1
)

SELECT "DOLocationID", max_tip, "Zone"
FROM main
LEFT JOIN taxi_zone_lookup on "DOLocationID" = "LocationID"
ORDER BY 2 DESC
LIMIT 1

# 7
terraform init, terraform apply -auto-approve, terraform destroy


