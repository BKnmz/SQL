/* Cyclistic Bike Share Case Study
This Case Study is Part of the Google Data Analytics Certificate Capstone and the Dataset used is publicly available to use 

The director of marketing believes that the companies future success depends on maximizing the number of annual memberships. Based on prior 
assumptions the finance analysts also concluded that annual memberships are much more profitable then casual riders.

--The company has tasked us to establish how annual members and casual riders use Cyclistic 
--Bikes differetly in hopes that this will shed a light and help produce a data driven decision.

-- The following steps will be taken during this analytical process
-- 1- Import data and Merge
-- 2- Creating calculated columns for consolidation
-- 3- Testing the data
-- 4- Data cleaning and Calculations
-- 5- Calculating Aggregates and Summarizing Findings */

--Merging the table_ Test */

CREATE TABLE Test_Merge AS
    SELECT ride_id, rideable_type AS bike_type, day_of_week ,  started_at , ended_at , member_casual 
    FROM "202005"
    UNION ALL 
    SELECT ride_id, rideable_type AS bike_type, day_of_week ,  started_at , ended_at , member_casual 
    FROM "202006"
    
--testing the data of test_merge    
SELECT * 
FROM  "Test_Merge"
LIMIT 100;

--adding the duration of ride in merged table

ALTER TABLE Test_Merge 
ADD COLUMN ride_length 
GENERATED ALWAYS AS ((strftime('%s', ended_at) - strftime('%s', started_at)) / 60)

--testing the avg of ride length 
SELECT avg(ride_length)
FROM  "Test_Merge"
WHERE ride_length > 0 ;


-- Finding the number of total rows in tables

SELECT COUNT(*) AS RideNum
FROM "202005"
UNION ALL
SELECT COUNT(*) 
FROM "202006"
 UNION ALL
SELECT COUNT(*) 
FROM "202007"
UNION ALL
SELECT COUNT(*) 
FROM "202008"
UNION ALL
SELECT COUNT(*) 
FROM "202009"
UNION ALL
SELECT COUNT(*) 
FROM "202010"
UNION ALL
SELECT COUNT(*) 
FROM "202011"
UNION ALL
SELECT COUNT(*) 
FROM "202012"
UNION ALL
SELECT COUNT(*) 
FROM "202101"
UNION ALL
SELECT COUNT(*) 
FROM "202102"
UNION ALL
SELECT COUNT(*) 
FROM "202103"
UNION ALL
SELECT COUNT(*) 
FROM "202104"



--Merging whole 12 tables
CREATE TABLE Bike_Ride AS
    SELECT ride_id, rideable_type AS bike_type, started_at, ended_at, member_casual 
    FROM "202005"
    UNION ALL 
    SELECT ride_id, rideable_type AS bike_type, started_at, ended_at, member_casual 
    FROM "202006"
    UNION ALL 
    SELECT ride_id, rideable_type AS bike_type, started_at, ended_at, member_casual 
    FROM "202007"
    UNION ALL 
    SELECT ride_id, rideable_type AS bike_type, started_at, ended_at, member_casual
    FROM "202008"
    UNION ALL 
    SELECT ride_id, rideable_type AS bike_type, started_at, ended_at, member_casual 
    FROM "202009"
    UNION ALL 
    SELECT ride_id, rideable_type AS bike_type, started_at , ended_at, member_casual 
    FROM "202010"
    UNION ALL 
    SELECT ride_id, rideable_type AS bike_type, started_at, ended_at, member_casual 
    FROM "202011"
    UNION ALL 
    SELECT ride_id, rideable_type AS bike_type, started_at , ended_at , member_casual 
    FROM "202012"
    UNION ALL 
    SELECT ride_id, rideable_type AS bike_type, started_at , ended_at , member_casual 
    FROM "202101"
    UNION ALL 
    SELECT ride_id, rideable_type AS bike_type, started_at , ended_at , member_casual 
    FROM "202102"
    UNION ALL 
    SELECT ride_id, rideable_type AS bike_type, started_at , ended_at , member_casual 
    FROM "202103"
    UNION ALL 
    SELECT ride_id, rideable_type AS bike_type, started_at , ended_at , member_casual 
    FROM "202104"


-- Testing the merged table

SELECT * FROM Bike_Ride
LIMIT 100

SELECT count(ride_id) From Bike_Ride;

SELECT COUNT(*) 
FROM Bike_Ride

--Adding ride_length column to merged table 
ALTER TABLE Bike_Ride 
ADD COLUMN ride_length 
GENERATED ALWAYS AS ((strftime('%s', ended_at) - strftime('%s', started_at)) / 60);


--Checiking the ride_length column as minutes There are negative values!!!
SELECT * FROM Bike_Ride
WHERE ride_length < 0
LIMIT 100

--Adding day_of_week column to merged table where Sunday = 0

ALTER TABLE Bike_Ride 
ADD COLUMN day_of_week 
GENERATED ALWAYS AS (strftime("%w", started_at)) ;

--Testing the added column
SELECT * FROM Bike_Ride

LIMIT 100

--adding a month column 

ALTER TABLE Bike_Ride 
ADD COLUMN Ride_Month 
GENERATED ALWAYS AS (strftime("%m", started_at)) ;

--Renaming member_casual column as customer_type

ALTER TABLE Bike_Ride 
RENAME COLUMN member_casual TO customer_type;

--checking the number of rides lasted more than one day

SELECT started_at, ended_at, ride_length,day_of_week
FROM Bike_Ride
WHERE ride_length > 1440 
ORDER BY ride_length DESC


-- Calculating Aggregates of the merged data 

--1.Total Time spent on bike per year per customer type

SELECT customer_type, SUM(ride_length) AS Yearly_Duration
FROM Bike_Ride
WHERE ride_length > 0 
GROUP BY customer_type

/*customer_type     Yearly_Duration
casual	            67644798
member	            34703684 */

-- 2. Average ride length differences between casual and member rides

SELECT customer_type ,AVG(ride_length) AS Avg_Ride_Mins
FROM Bike_Ride
WHERE ride_length > 0
GROUP BY customer_type

/*customer_type        Avg_Ride_Mins
casual	        44.25842495935305
member	        15.99747202237749*/

-- 3. Average ride length  for each day_week for customer types

SELECT day_of_week, customer_type, Round(AVG(ride_length),2) AS Avg_Ride_Mins
FROM Bike_Ride 
WHERE ride_length > 0
GROUP BY customer_type, day_of_week
ORDER BY day_of_week; 

/* day_of_week	customer_type	Avg_Ride_Mins
0	casual	50.09
0	member	17.93
1	casual	44.33
1	member	15.33
2	casual	39.75
2	member	15.02
3	casual	40.27
3	member	15.3
4	casual	41.64
4	member	15.04
5	casual	42.21
5	member	15.73
6	casual	46.14
6	member	17.68*/

-- 4. Number of rides for each week day per customer type

SELECT day_of_week, customer_type, COUNT(ride_length) AS Number_of_Rides
FROM Bike_Ride 
WHERE ride_length > 0
GROUP BY customer_type, day_of_week
ORDER BY day_of_week; 

/* day_of_week	customer_type	Number_of_Rides
0	casual	279343
0	member	275925
1	casual	163060
1	member	284162
2	casual	160476
2	member	304035
3	casual	167092
3	member	320345
4	casual	174754
4	member	316258
5	casual	227073
5	member	331447
6	casual	356607
6	member	337151 */


--5.Average ride_length for each Month per customer type 

SELECT Ride_Month, customer_type, Round(AVG(ride_length),2) AS Average_Ride_Duration
FROM Bike_Ride 
WHERE ride_length > 0
GROUP BY customer_type, Ride_Month
ORDER BY Average_Ride_Duration DESC; 

/*Ride_Month	customer_type	Average_Ride_Duration
7	casual	60.2
6	casual	51.91
5	casual	51.42
2	casual	49.87
8	casual	45.39
9	casual	38.57
3	casual	38.4
4	casual	38.29
11	casual	32.1
10	casual	30.63
12	casual	27.05
1	casual	25.92
5	member	19.96
6	member	18.91
2	member	18.25
7	member	17.95
8	member	17.02
9	member	15.72
4	member	14.84
10	member	14.21
3	member	14.09
11	member	13.72
1	member	12.98
12	member	12.86*/




--6. Summary for Merged Data

SELECT customer_type, day_of_week, Ride_Month, count(ride_id) AS Number_of_Rides,SUM(ride_length) AS Total_Ride_Time, Round(avg(ride_length),2) AS Avg_Ride_Mins
FROM Bike_Ride
WHERE ride_length > 0 
GROUP BY customer_type, day_of_week, Ride_Month
ORDER BY Avg_Ride_Mins DESC;   

/*
customer_type	day_of_week	Ride_Month	Number_of_Rides	Total_Ride_Time	Avg_Ride_Mins
casual	0	7	43119	3072819	71.26
casual	5	2	1471	94491	64.24
casual	6	7	53549	3367546	62.89
casual	1	7	27697	1739639	62.81
casual	6	2	3456	213368	61.74
casual	4	6	20827	1240166	59.55
casual	4	7	37028	2147255	57.99
casual	3	7	30549	1759550	57.6
casual	0	5	13159	742623	56.43
casual	0	6	32703	1824652	55.79
casual	1	5	10490	571501	54.48
casual	5	7	49589	2651787	53.48
casual	2	7	26022	1369147	52.61
casual	1	6	14301	751855	52.57
casual	2	5	6159	315734	51.26
casual	6	6	33068	1687892	51.04
casual	5	5	12710	647406	50.94
casual	0	8	58095	2923523	50.32
casual	2	2	994	49671	49.97
casual	3	5	9151	456144	49.85
casual	6	5	27459	1352493	49.25
casual	5	6	18603	914156	49.14
casual	4	5	7370	361999	49.12
casual	6	8	72884	3481955	47.77
casual	2	6	18491	848581	45.89
casual	3	6	15831	717802	45.34
casual	0	9	43771	1960196	44.78
casual	1	3	11904	529223	44.46
casual	0	2	1382	60951	44.1
casual	1	8	28521	1256902	44.07
casual	4	8	30608	1348300	44.05
casual	0	4	25031	1065069	42.55
casual	6	3	21977	934447	42.52
casual	6	9	49120	2066377	42.07
casual	5	8	38735	1617999	41.77
casual	2	8	27857	1161495	41.69
casual	0	3	17230	717331	41.63
casual	5	4	22754	943711	41.47
casual	0	12	5088	209935	41.26
casual	3	8	29034	1178697	40.6
casual	2	4	20225	805447	39.82
casual	1	9	27235	1083251	39.77
casual	0	11	15664	611994	39.07
casual	3	4	11872	457601	38.54
casual	1	2	576	21610	37.52
casual	1	4	15924	596504	37.46
casual	6	4	27561	1016929	36.9
casual	5	9	32582	1193519	36.63
casual	6	11	20735	751347	36.24
casual	2	3	10405	376865	36.22
casual	3	9	29373	1059036	36.05
casual	6	10	38287	1320223	34.48
casual	3	2	1114	38221	34.31
casual	0	10	21269	719628	33.83
casual	6	1	3973	127087	31.99
casual	5	10	23381	747123	31.95
casual	4	9	23613	748975	31.72
casual	2	9	22288	681962	30.6
casual	4	3	5445	166558	30.59
casual	5	11	13268	405280	30.55
casual	6	12	4538	134663	29.67
casual	2	10	14061	416272	29.6
casual	0	1	2832	83668	29.54
casual	5	3	7731	227023	29.37
casual	3	3	8817	255304	28.96
casual	4	11	10227	295338	28.88
casual	2	11	8158	226191	27.73
casual	1	11	10789	298583	27.67
casual	3	10	16383	441793	26.97
casual	3	1	2077	53740	25.87
casual	1	10	10048	254530	25.33
casual	4	4	12276	308664	25.14
casual	3	11	8308	208586	25.11
casual	4	10	19327	473359	24.49
casual	4	12	4670	112862	24.17
casual	1	12	3511	81979	23.35
casual	5	1	2811	65100	23.16
casual	5	12	3438	77930	22.67
casual	2	1	1869	42046	22.5
casual	3	12	4583	103023	22.48
member	6	5	26817	589946	22
casual	4	1	2327	50878	21.86
casual	2	12	3947	85030	21.54
member	0	2	3951	84981	21.51
member	0	5	13201	283337	21.46
casual	4	2	1036	21877	21.12
casual	1	1	2064	42811	20.74
member	6	6	31052	635251	20.46
member	0	6	29825	605863	20.31
member	1	2	3955	78886	19.95
member	6	7	37989	746563	19.65
member	0	7	31810	624137	19.62
member	6	2	6440	125870	19.55
member	1	5	12973	252159	19.44
member	3	6	23451	455579	19.43
member	5	5	19766	383738	19.41
member	0	9	38246	732889	19.16
member	3	5	15595	297267	19.06
member	0	8	48805	918729	18.82
member	4	6	28049	520278	18.55
member	4	5	12900	237902	18.44
member	6	8	57880	1056031	18.25
member	5	6	24386	437055	17.92
member	2	5	10960	195138	17.8
member	2	6	27141	481591	17.74
member	3	2	6535	115313	17.65
member	2	2	5659	99651	17.61
member	5	7	48992	861398	17.58
member	2	7	35475	621005	17.51
member	4	7	47153	825727	17.51
member	5	2	6493	113117	17.42
member	1	7	34185	594792	17.4
member	6	9	39100	680033	17.39
member	1	6	22362	385748	17.25
member	0	4	24873	421446	16.94
member	3	7	42613	719296	16.88
member	1	8	43925	739338	16.83
member	3	8	44139	739164	16.75
member	6	4	26368	440317	16.7
member	0	3	18119	295307	16.3
member	5	8	45422	738650	16.26
member	6	3	22920	367678	16.04
member	2	8	43325	690682	15.94
member	4	2	5962	93872	15.75
member	4	8	43751	688375	15.73
member	6	11	24805	388848	15.68
member	1	9	37608	582267	15.48
member	5	10	39481	608433	15.41
member	5	9	43194	665063	15.4
member	6	10	40184	614514	15.29
member	0	10	24469	365070	14.92
member	0	11	22147	330119	14.91
member	2	4	31552	461332	14.62
member	4	9	41154	601287	14.61
member	1	4	27450	400477	14.59
member	3	9	53336	775480	14.54
member	5	4	35460	510775	14.4
member	0	12	11680	168103	14.39
member	1	3	22623	322576	14.26
member	2	9	44740	636575	14.23
member	3	10	35704	495713	13.88
member	5	11	25680	355806	13.86
member	6	1	12201	167076	13.69
member	2	10	32422	443663	13.68
member	2	3	23343	317206	13.59
member	3	4	25081	340566	13.58
member	3	1	11114	150749	13.56
member	0	1	8799	118520	13.47
member	4	4	27822	372299	13.38
member	1	1	11041	147178	13.33
member	4	10	41431	550703	13.29
member	4	12	16597	217376	13.1
member	4	11	23709	309601	13.06
member	6	12	11395	148701	13.05
member	3	3	22591	294539	13.04
member	2	11	21898	285222	13.03
member	3	11	22671	294093	12.97
member	5	3	17742	227987	12.85
member	5	12	12293	157369	12.8
member	3	12	17515	222645	12.71
member	1	11	28453	359294	12.63
member	1	10	25795	324709	12.59
member	5	1	12538	155878	12.43
member	4	1	11863	146626	12.36
member	1	12	13792	169235	12.27
member	4	3	15867	192738	12.15
member	2	1	10489	127191	12.13
member	2	12	17031	205983	12.09 */

--7. Average ride duration by each day for customer type

SELECT day_of_week, customer_type, COUNT(ride_id) AS Num_of_Ride,ROUND(AVG(ride_length),2) AS Mean_Ride_Duration
FROM Bike_Ride 
WHERE ride_length > 0
GROUP BY customer_type,day_of_week

/*day_of_week	customer_type	Num_of_Ride	Mean_Ride_Duration
0	casual	279343	50.09
1	casual	163060	44.33
2	casual	160476	39.75
3	casual	167092	40.27
4	casual	174754	41.64
5	casual	227073	42.21
6	casual	356607	46.14
0	member	275925	17.93
1	member	284162	15.33
2	member	304035	15.02
3	member	320345	15.3
4	member	316258	15.04
5	member	331447	15.73
6	member	337151	17.68*/
