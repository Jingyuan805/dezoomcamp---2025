#!/usr/bin/env python
# coding: utf-8

# In[2]:


import pyspark
from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .master("local[*]") \
    .appName('test') \
    .getOrCreate()


# In[3]:


import pandas as pd
from pyspark.sql import types
from pyspark.sql.functions import col


yellow_schema = types.StructType([
    types.StructField("VendorID", types.IntegerType(), True),
    types.StructField("tpep_pickup_datetime", types.TimestampType(), True),
    types.StructField("tpep_dropoff_datetime", types.TimestampType(), True),
    types.StructField("passenger_count", types.LongType(), True),
    types.StructField("trip_distance", types.DoubleType(), True),
    types.StructField("RatecodeID", types.LongType(), True),
    types.StructField("store_and_fwd_flag", types.StringType(), True),
    types.StructField("PULocationID", types.IntegerType(), True),
    types.StructField("DOLocationID", types.IntegerType(), True),
    types.StructField("payment_type", types.LongType(), True),
    types.StructField("fare_amount", types.DoubleType(), True),
    types.StructField("extra", types.DoubleType(), True),
    types.StructField("mta_tax", types.DoubleType(), True),
    types.StructField("tip_amount", types.DoubleType(), True),
    types.StructField("tolls_amount", types.DoubleType(), True),
    types.StructField("improvement_surcharge", types.DoubleType(), True),
    types.StructField("total_amount", types.DoubleType(), True),
    types.StructField("congestion_surcharge", types.DoubleType(), True)
])


# In[ ]:


df_yellow = spark.read \
        .schema(yellow_schema) \
        .parquet('./yellow_tripdata_2024-10.parquet')


# In[ ]:


df_yellow.schema


# In[ ]:


df_yellow \
    .repartition(4) \
    .write.parquet('pq/')


# In[ ]:





# In[4]:


df_yellow = spark.read.parquet('./pq/*')


# In[5]:


df_yellow = df_yellow \
    .withColumnRenamed('tpep_pickup_datetime', 'pickup_datetime') \
    .withColumnRenamed('tpep_dropoff_datetime', 'dropoff_datetime')


# In[6]:


df_yellow.createOrReplaceTempView('yellow_trips_data')


# In[13]:


spark.sql("""
SELECT
    count(1)
FROM
    yellow_trips_data
WHERE 
    DATE(pickup_datetime) = '2024-10-15'
    
""").show()


# In[22]:


spark.sql("""
SELECT
    MAX(TIMESTAMPDIFF(hour, pickup_datetime, dropoff_datetime)) AS longest_trip_in_hours
FROM
    yellow_trips_data
""").show()


# In[26]:


df = spark.read \
    .option("header", "true") \
    .csv('taxi_zone_lookup.csv')


# In[27]:


df.createOrReplaceTempView('taxi_zone_lookup')


# In[34]:


spark.sql("""
SELECT
    Zone, count(pickup_datetime) as number
FROM
    yellow_trips_data as a
LEFT JOIN taxi_zone_lookup as b on a.PULocationID = b.LocationID
GROUP BY 1
ORDER BY 2 
""").show()


# In[ ]:




