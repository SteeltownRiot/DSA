SELECT  ic.offense_type AS Offense
        ,ic.description AS Description
        ,EXTRACT(YEAR FROM datetime) AS Year
        ,EXTRACT(MONTH FROM datetime) AS Month
        ,COUNT(*) AS Incidents
FROM    jch5x8.cases c JOIN iucr_codes ic
        USING (iucr_id)
WHERE   c.iucr_id IN (
        SELECT  DISTINCT ON(offense_type)
                offense_type
                ,iucr_id
        FROM    iucr_codes join cases
                USING (iucr_id)
        GROUP BY EXTRACT(YEAR FROM datetime), iucr_id
        ORDER BY EXTRACT(YEAR FROM datetime), COUNT(*) DESC, offense_type
        LIMIT   5)
GROUP BY Year, Month, ic.offense_type, ic.description
ORDER BY Year, Month, Incidents DESC;



SELECT  ic.offense_type AS Offense
        ,EXTRACT(YEAR FROM datetime) AS Year
        ,EXTRACT(MONTH FROM datetime) AS Month
        ,COUNT(*) AS Incidents
FROM    jch5x8.cases c JOIN iucr_codes ic
        USING (iucr_id)
WHERE   ic.offense_type EXISTS (
        SELECT  DISTINCT offense_type
                ,EXTRACT(YEAR FROM datetime) AS year   
                ,COUNT(*) AS cnt
        FROM    iucr_codes join cases
                USING (iucr_id)
        GROUP BY year, offense_type
        ORDER BY year, cnt DESC, offense_type
        LIMIT   5)
GROUP BY Year, Month, Offense
ORDER BY Year, Month;


SELECT  tos.offense_type AS Offense
        ,tos.year AS Year
        ,EXTRACT(MONTH FROM datetime) AS Month
        ,COUNT(*) AS Incidents
FROM    jch5x8.cases c JOIN iucr_codes ic
        USING (iucr_id)
        JOIN (
        SELECT  DISTINCT offense_type
                ,EXTRACT(YEAR FROM datetime) AS year   
                ,COUNT(*) AS cnt
        FROM    iucr_codes join cases
                USING (iucr_id)
        GROUP BY year, offense_type
        ORDER BY year, cnt DESC, offense_type
        LIMIT   5) AS tos
        ON tos.offense_type = ic.offense_type
GROUP BY year, Month, Offense
ORDER BY year, Month;


tos.Y





SELECT  DISTINCT offense_type
                ,EXTRACT(YEAR FROM datetime) AS year   
                ,COUNT(*) AS cnt
        FROM    iucr_codes join cases
                USING (iucr_id)
        GROUP BY year, offense_type
        ORDER BY year, cnt DESC, offense_type
        LIMIT   5;


SELECT  iucr_id
                ,COUNT(*) AS Incidents
                ,EXTRACT(MONTH FROM ca.datetime) AS Month
        FROM    iucr_codes i_c join cases ca
                USING (iucr_id)
        GROUP BY iucr_id, month
        ORDER BY cnt DESC
        LIMIT   5;



SELECT EXTRACT(MONTH FROM datetime) AS Month
        ,offense_type AS Offense
        ,ward AS Ward
        ,COUNT(*) AS COUNT
                        FROM    cases c JOIN iucr_codes i_c
                                USING   (iucr_id)
                                JOIN incident_locations il
                                USING (il_id)
                                JOIN wards w
                                USING (ward_id)
                        WHERE   ((offense_type = 'ASSAULT')
                                    OR (offense_type = 'BATTERY')
                                )
                                AND ((EXTRACT(MONTH FROM datetime) = 4)
                                    OR (EXTRACT(MONTH FROM datetime) = 7)
                                )
                        GROUP BY Month, Offense, Ward
                        ORDER BY Month, Offense, Ward
;



chicago_map_crime = folium.Map(location = [41.895140898, -87.624255632],
                        zoom_start = 13,
                        tiles = "CartoDB dark_matter")

chicago_map_crime = folium.Map(location = [41.895140898, -87.624255632],
                        zoom_start = 13,
                        tiles = "CartoDB dark_matter")

chicago_map_crime = folium.Map(location = [41.895140898, -87.624255632],
                        zoom_start = 13,
                        tiles = "CartoDB dark_matter")

for i in range(500):
    lat = CR_index['LocationCoord'].iloc[i][0]
    long = CR_index['LocationCoord'].iloc[i][1]
    radius = CR_index['ValueCOUNT'].iloc[i] / 45
    
    if CR_index['ValueCOUNT'].iloc[i] > 1000:
        color = "#FF4500"
    else:
        color = "#008080"
    
    popup_text = """Latitude : {}<br>
                Longitude : {}<br>
                Criminal Incidents : {}<br>"""
    popup_text = popup_text.format(lat,
                               long,
                               CR_index['ValueCOUNT'].iloc[i]
                               )
    folium.CircleMarker(location = [lat, long], popup =  popup_text,radius = radius, color = color, fill = True).add_to(chicago_map_crime)


chicago_crimes = '''

'''

# Create map of Chicago
chicago_map = folium.Map(location = [41.895140898, -87.624255632],
                        zoom_start = 13,
                        tiles = "CartoDB dark_matter")

# Iterate through the dataframe and add markers to the map
for i in range(500):
    lat = map_result['lat'].iloc[i][0]
    long = map_result['long'].iloc[i][1]
    radius = map_result['incidents'].iloc[i] / 45
    
    if map_result['incidents'].iloc[i] > 1000:
        color = "#FF4500"
    else:
        color = "#008080"
    
    popup_text = """Latitude : {}<br>
                Longitude : {}<br>
                Incidents : {}<br>"""
    popup_text = popup_text.format(lat,
                               long,
                               map_result['incidents'].iloc[i]
                               )
    folium.CircleMarker(location = [lat, long], popup = popup_text, radius = radius, color = color, fill = True).add_to(chicago_map)




WITH cte AS
(
SELECT
    
    COUNTry_id,
    indicator_id,
    year,
    value,
    (value - LAG(value,1) 
    OVER (PARTITION BY COUNTry_id,indicator_id ORDER BY year)) /LAG(value, 1) 
    OVER (ORDER BY year)*100 AS pct_change,
    LAG(year,1)
    OVER (PARTITION BY COUNTry_id,indicator_id ORDER BY year) as prev_obs_year
    
FROM data

ORDER BY COUNTry_id,indicator_id, year
)

SELECT COUNTry_id,
       indicator_id,
       year AS base_year,
       pct_change

FROM cte

WHERE FLOOR((year - prev_obs_year)/365) < = 3
ORDER BY pct_change DESC
LIMIT 1;

%%sql
SELECT  c.name, avg(ac.actors) as avg_actors
FROM    category c JOIN film_category fc
        USING(category_id)
        JOIN film f
        USING(film_id)
        JOIN (SELECT  film_id, COUNT(actor_id) as actors
              FROM    film_actor
              GROUP BY film_id
        ) as ac
        USING(film_id)
GROUP BY c.name
ORDER BY avg_actors DESC
LIMIT   3;


%%sql
SELECT  b.beat
        ,ic.offense_type AS Offense
        ,AVG(tbi.incidents) as "Avg. Incidents"
FROM    beats b JOIN incident_locations il
        USING(beat_id)
        JOIN cases c
        USING(il_id)
        JOIN iucr_codes ic
        USING(iucr_id)
        JOIN (
                SELECT  ca.iucr_id
                        ,i_c.offense_type
                        ,COUNT(ca.iucr_id) AS incidents
                FROM    cases ca JOIN iucr_codes i_c
                        USING(iucr_id)
                WHERE   offense_type IN ('THEFT', 'BATTERY')
                GROUP BY i_c.offense_type, ca.iucr_id
                ORDER BY incidents DESC
        ) as tbi
        ON ic.iucr_id = tbi.iucr_id
GROUP BY b.beat, Offense
ORDER BY b.beat, "Avg. Incidents" DESC
LIMIT   50;


drop table if exists cases, iucr_codes, incident_locations, beats, districts, wards, districts, locations, geolocs, blocks;


SELECT  EXTRACT(DOW FROM c.datetime) AS "Day of Week"
        ,EXTRACT(HOUR FROM c.datetime) AS "Hour"
        ,EXTRACT(MONTH FROM c.datetime) AS "Month"
        ,COUNT(*) AS "Incidents"

SELECT  EXTRACT(HOUR from c.datetime)

SELECT  i_c.offense_type AS offense
                        ,COUNT(ca.iucr_id) AS incidents
                FROM    cases ca JOIN iucr_codes i_c
                        USING(iucr_id)
                WHERE   offense_type IN ('THEFT', 'BATTERY')
                GROUP BY i_c.offense_type
                ORDER BY incidents DESC
                ;

SELECT  i_c.offense_type
                        ,i_l.beat_id
                        ,COUNT(ca.iucr_id) AS incidents
                FROM    cases ca JOIN iucr_codes i_c
                        USING(iucr_id)
                        JOIN incident_locations i_l
                        USING(il_id)
                WHERE   offense_type IN ('THEFT', 'BATTERY')
                GROUP BY i_l.beat_id, i_c.offense_type
                ORDER BY incidents DESC
;

SELECT  be.beat_id
                        ,i_c.offense_type
                        ,AVG(COUNT(ca.iucr_id)) AS incidents
                FROM    beats be JOIN incident_locations i_l
                        USING(beat_id)
                        JOIN cases ca
                        USING(il_id)
                        JOIN iucr_codes i_c
                        USING(iucr_id)
                WHERE   offense_type IN ('THEFT', 'BATTERY')
                GROUP BY be.beat_id, i_c.offense_type, ca.iucr_id
                 ;

SELECT  be.beat_id
                        ,i_c.offense_type
                        ,COUNT(ca.iucr_id) AS incidents
                FROM    beats be JOIN incident_locations i_l
                        USING(beat_id)
                        JOIN cases ca
                        USING(il_id)
                        JOIN iucr_codes i_c
                        USING(iucr_id)
                WHERE   offense_type IN ('THEFT', 'BATTERY')
                GROUP BY be.beat_id, i_c.offense_type
                 ;



SELECT  b.beat
        ,tbi.offense_type AS Offense
        ,AVG(tbi.incidents) as "Avg. Incidents"
FROM    beats b JOIN incident_locations il
        USING(beat_id)
        JOIN cases c
        USING(il_id)
        JOIN (
                SELECT  ca.iucr_id
                         ,i_c.offense_type
                         ,COUNT(ca.iucr_id) AS incidents
                 FROM    cases ca JOIN iucr_codes i_c
                         USING(iucr_id)
                 WHERE   offense_type IN ('THEFT', 'BATTERY')
                 GROUP BY i_c.offense_type, ca.iucr_id
                 ORDER BY incidents DESC
        ) as tbi
        ON c.iucr_id = tbi.iucr_id
GROUP BY b.beat, Offense
ORDER BY "Avg. Incidents" DESC, b.beat
LIMIT   50;


SELECT  b.beat
        ,tbi.offenses AS Offense
        ,AVG(tbi.incidents) as Avg_Incidents
FROM    beats b JOIN incident_locations il
        USING(beat_id)
        JOIN (
                SELECT  be.beat_id
                        ,i_c.offense_type AS offenses
                        ,COUNT(ca.iucr_id) AS incidents
                FROM    beats be JOIN incident_locations i_l
                        USING(beat_id)
                        JOIN cases ca
                        USING(il_id)
                        JOIN iucr_codes i_c
                        USING(iucr_id)
                WHERE   offense_type IN ('THEFT', 'BATTERY')
                GROUP BY be.beat_id, i_c.offense_type) AS tbi
        ON il.beat_id = tbi.beat_id
GROUP BY b.beat, Offense, Avg_Incidents
ORDER BY Avg_Incidents DESC, b.beat
LIMIT   50;


SELECT  be.beat_id
                        ,COUNT(ca.iucr_id) AS incidents
                FROM    beats be JOIN incident_locations i_l
                        USING(beat_id)
                        JOIN cases ca
                        USING(il_id)
                        JOIN iucr_codes i_c
                        USING(iucr_id)
                WHERE   offense_type IN ('THEFT', 'BATTERY')
                GROUP BY be.beat_id, ca.iucr_id
                ORDER BY ca.iucr_id DESC
                 ;



SELECT  b.beat
        ,ic.offense_type AS Offense
        ,AVG(tbi.incidents) as Avg_Incidents
FROM    beats b JOIN incident_locations il
        USING(beat_id)
        JOIN cases c
        USING(il_id)
        JOIN iucr_codes ic
        USING(iucr_id)
        JOIN (
                SELECT  be.beat_id
                        ,i_c.offense_type AS offenses
                        ,COUNT(ca.iucr_id) AS incidents
                FROM    beats be JOIN incident_locations i_l
                        USING(beat_id)
                        JOIN cases ca
                        USING(il_id)
                        JOIN iucr_codes i_c
                        USING(iucr_id)
                WHERE   offense_type IN ('THEFT', 'BATTERY')
                GROUP BY be.beat_id, offenses
                ORDER BY incidents DESC
                LIMIT   50) AS tbi
        ON b.beat_id = tbi.beat_id
WHERE   ic.offense_type IN ('THEFT', 'BATTERY')
GROUP BY b.beat, Offense
ORDER BY b.beat, Avg_Incidents DESC;

SELECT  b.beat
         ,ic.offense_type AS Offense
         ,AVG(tbi.incidents) as Avg_Incidents
 FROM    beats b JOIN incident_locations il
         USING(beat_id)
         JOIN cases c
         USING(il_id)
         JOIN iucr_codes ic
         USING(iucr_id)
         JOIN (
                 SELECT  be.beat_id
                         ,COUNT(ca.iucr_id) AS incidents
                 FROM    beats be JOIN incident_locations i_l
                         USING(beat_id)
                         JOIN cases ca
                         USING(il_id)
                         JOIN iucr_codes i_c
                         USING(iucr_id)
                 WHERE   offense_type IN ('THEFT', 'BATTERY')
                 GROUP BY be.beat_id
                 ORDER BY incidents DESC
                 LIMIT   50) AS tbi
         ON b.beat_id = tbi.beat_id
 WHERE   ic.offense_type IN ('THEFT', 'BATTERY')
 GROUP BY b.beat, Offense
 ORDER BY b.beat, Avg_Incidents DESC;


-- Gives top 50 beats by thefts + batteries
-- Can't get it to split by offense type in outer query, nor display the average
SELECT  be.beat_id
        ,COUNT(ca.iucr_id) AS incidents
FROM    beats be JOIN incident_locations i_l
        USING(beat_id)
        JOIN cases ca
        USING(il_id)
        JOIN iucr_codes i_c
        USING(iucr_id)
WHERE   offense_type IN ('THEFT', 'BATTERY')
GROUP BY be.beat_id
ORDER BY incidents DESC
LIMIT   50;

-- Gives me a list of the first 50 beats and displays number of thefts and batteries
-- but not the beats with the most theft + batteries
SELECT  b.beat
        ,tbi.offense_type AS Offense
        ,AVG(tbi.incidents) as "Avg. Incidents"
FROM    beats b JOIN incident_locations il
        USING(beat_id)
        JOIN cases c
        USING(il_id)
        NATURAL JOIN (
                SELECT  ca.iucr_id
                         ,i_c.offense_type
                         ,COUNT(ca.iucr_id) AS incidents
                 FROM    cases ca JOIN iucr_codes i_c
                         USING(iucr_id)
                 WHERE   offense_type IN ('THEFT', 'BATTERY')
                 GROUP BY i_c.offense_type, ca.iucr_id
                 ORDER BY incidents DESC
        ) as tbi
GROUP BY b.beat, Offense
ORDER BY b.beat, "Avg. Incidents" DESC
LIMIT   50;


WITH RECURSIVE cohort AS (
        SELECT  b.beat
                ,ic.offense_type AS Offense
                ,AVG(tbi.incidents) as Avg_Incidents
        FROM    beats b JOIN incident_locations il
                USING(beat_id)
                JOIN cases c
                USING(il_id)
                JOIN iucr_codes ic
                USING(iucr_id)
UNION
        SELECT  ca.iucr_id
                ,i_c.offense_type
                ,COUNT(ca.iucr_id) AS incidents
        FROM    cases ca JOIN iucr_codes i_c
                USING(iucr_id)
                WHERE   offense_type IN ('THEFT', 'BATTERY')
                GROUP BY i_c.offense_type, ca.iucr_id
                ORDER BY incidents DESC
INNER JOIN cohort s ON s.student_id = e.teacher_id)
SELECT *
FROM cohort;



SELECT  be.beat_id
        ,COUNT(ca.iucr_id) AS incidents
FROM    beats be JOIN incident_locations i_l
        USING(beat_id)
        JOIN cases ca
        USING(il_id)
        JOIN iucr_codes i_c
        USING(iucr_id)
WHERE   offense_type IN ('THEFT', 'BATTERY')
GROUP BY be.beat_id
ORDER BY incidents DESC
LIMIT   50
UNION ALL
SELECT  b.beat
        ,tbi.offense_type AS Offense
        ,COUNT(c.iucr_id) as Incidents
FROM    beats b JOIN incident_locations il
        USING(beat_id)
        JOIN cases c
        USING(il_id)
        GROUP BY b.beat, Offense
ORDER BY b.beat, "Avg. Incidents" DESC;



SELECT  AVG(tbi.incidents) as Avg_Incidents
FROM    (SELECT b.beat
                ,ic.offense_type AS offense
                ,COUNT(*) AS incidents
                ,RANK() OVER (PARTITION BY b.beat ORDER BY COUNT(*) DESC) AS rank
        FROM    cases c JOIN iucr_codes ic
                USING (iucr_id)
                JOIN incident_locations il
                USING (il_id)
                JOIN beats b
                USING (beat_id)
        WHERE   ic.offense_type IN ('THEFT', 'BATTERY')
        GROUP BY b.beat, ic.offense_type
        ORDER BY rank) AS tbi
WHERE tbi.rank < =  50
GROUP BY tbi.beat, tbi.offense
ORDER BY Avg_Incidents DESC;



chi_geolocs = """ 
WITH gl AS
(
    SELECT      g.lat
                ,g.long
                ,ic.offense_type,d.district
    FROM        geolocs g JOIN incident_locations il USING (loc_id)
                JOIN districts d USING (district_id)
                JOIN cases c USING (il_id)
                JOIN iucr_codes ic USING (iucr_id)
    WHERE       offense_type IN ('THEFT', 'BATTERY')
)
SELECT  gl.lat
        ,gl.long
        ,gl.offense_type
        ,gl.district
FROM    gl
ORDER BY gl.lat, gl.long
"""

# Store sql results in a variable
chi_gl_result = %sql $chi_geolocs
# Store sql result in dataframe
cdldf = pd.DataFrame(chi_gl_result, columns = ['Lat', 'Long', 'Offense', "District"])
cdldf.head()



WITH gl AS
(SELECT g.lat
        ,g.long
        ,ic.offense_type
        ,d.district
FROM    geolocs g JOIN incident_locations il USING (geoloc_id)
        JOIN districts d USING (district_id)
        JOIN cases c USING (il_id)
        JOIN iucr_codes ic USING (iucr_id)
WHERE   offense_type IN ('THEFT', 'BATTERY')
)
SELECT  gl.lat
        ,gl.long
        ,gl.offense_type
        ,gl.district
FROM    gl
ORDER BY gl.lat, gl.long


SELECT  di.district_id
FROM    district di JOIN incident_locations i_l
        USING(district_id)
        JOIN cases ca
        USING(il_id)
        JOIN iucr_codes i_c
        USING(iucr_id)
WHERE   offense_type IN ('THEFT', 'BATTERY')
GROUP BY di.district_id
ORDER BY incidents DESC
LIMIT   50


WITH gl AS
(SELECT g.lat
        ,g.long
        ,ic.offense_type
        ,d.district
FROM    geolocs g JOIN incident_locations il USING (geoloc_id)
        JOIN districts d USING (district_id)
        JOIN cases c USING (il_id)
        JOIN iucr_codes ic USING (iucr_id)
WHERE   d.district_id IN (
                SELECT  di.district_id
                FROM    districts di JOIN incident_locations i_l
                        USING(district_id)
                        JOIN cases ca
                        USING(il_id)
                        JOIN iucr_codes i_c
                        USING(iucr_id)
                WHERE   offense_type IN ('THEFT', 'BATTERY')
                        AND EXTRACT(MONTH FROM datetime) > 3
                        AND EXTRACT(MONTH FROM datetime) < 8
                GROUP BY di.district_id
                ORDER BY COUNT(ca.iucr_id) DESC
                LIMIT   5
        )
        AND ic.offense_type IN ('THEFT', 'BATTERY')
)
SELECT  gl.lat
        ,gl.long
        ,gl.offense_type
        ,gl.district
FROM    gl
ORDER BY gl.lat, gl.long


# Load Chicago Polic Districts shape file into GeoPandas
chi_districts = geopandas.read_file('geo_export_3dcb21dd-8266-4cd3-bb81-aa692a23ffda.shp')

# Load sql query into variable
chi_geolocs = """ 
WITH gl AS (
SELECT  g.lat
        ,g.long
        ,ic.offense_type
        ,d.district
FROM    geolocs g JOIN incident_locations il USING (geoloc_id)
        JOIN districts d USING (district_id)
        JOIN cases c USING (il_id)
        JOIN iucr_codes ic USING (iucr_id)
WHERE   d.district_id IN (
                SELECT  di.district_id
                FROM    districts di JOIN incident_locations i_l
                        USING(district_id)
                        JOIN cases ca
                        USING(il_id)
                        JOIN iucr_codes i_c
                        USING(iucr_id)
                WHERE   offense_type IN ('THEFT', 'BATTERY')
                GROUP BY di.district_id
                ORDER BY COUNT(ca.iucr_id) DESC
                LIMIT   5
        )
        AND EXTRACT(MONTH FROM c.datetime) > 3
        AND EXTRACT(MONTH FROM c.datetime) < 8
        AND ic.offense_type IN ('THEFT', 'BATTERY')
)
SELECT  gl.lat
        ,gl.long
        ,gl.offense_type
        ,gl.district
FROM    gl
ORDER BY gl.lat, gl.long
"""

# Store sql results in a variable
chi_gl_result = %sql $chi_geolocs
# Print sql result
print(chi_gl_result)

# Store sql result in dataframe
cdldf = pd.DataFrame(chi_gl_result, columns = ['Lat', 'Long', 'Offense', "District"])
#cdldf.head()

# Set data up for GeoPandas
cdldf = cdldf.drop(cdldf[(cdldf.Lat < 41.0)].index)        #Remove bad values in lat/longs 
cdldf['District'] = cdldf['District'].astype(int)
chi_crime_geo = [Point(xy) for xy in zip(cdldf.Long, cdldf.Lat)]
chi_crime_crs = {'type': 'EPSG', 'properties': {'code': 102671}}
chi_crime_plots = GeoDataFrame(cdldf, crs = chi_crime_crs, geometry = chi_crime_geo)
#chi_crime_plots.head()

# # Plot the thefts and batteries from April through July in the top 5 districts of occurrence
# chi_crime_map = chi_crime_plots.plot(figsize = (25, 25), markersize = 5) 
# chi_crime_map.set_axis_off()

# # Render the Chicago Police Districts map
#chi_dist_map = chi_districts.plot(figsize = (25, 25), edgecolor = 'k', alpha = 0.5, linewidth = 2) 
# chi_districts.apply(lambda x: chi_dist_map.annotate(s = x.dist_label, xy = x.geometry.centroid.coords[0], ha = 'center', size = 16), axis = 1);
# chi_dist_map.set_axis_off()

# Overlay the theft and battery crime data onto the Chicago Police Districts map
chi_dist_map = chi_districts.plot(figsize = (25, 25), edgecolor = 'k', alpha = 0.25, linewidth = 2) 
chi_districts.apply(lambda x: chi_dist_map.annotate(s = x.dist_label, xy = x.geometry.centroid.coords[0], ha = 'center', size = 16), axis = 1);
chi_crime_plots.plot(figsize = (25, 25), ax = chi_dist_map, markersize = 5, color = 'Red', alpha = 0.25)
chi_dist_map.set_axis_off()



SELECT  DISTINCT ON (b.beat) b.beat, COUNT(c.iucr_id) AS crimes
FROM    beats b JOIN incident_locations il USING(beat_id)
        JOIN cases c USING(il_id)
        JOIN iucr_codes ic USING(iucr_id)
WHERE   crimes > (
                SELECT  COUNT(*) as num_cases
                FROM    cases ca JOIN incident_locations i_l USING (il_id)
                        JOIN beats be USING (beat_id)
                WHERE   ca.iucr_id IN (
                                32
                                ,33
                                ,34
                                ,35
                                ,36
                                ,37
                                ,38
                                ,39
                                ,40
                                ,41
                                ,42
                                ,43
                                ,44
                                ,46
                                ,47
                                ,48
                                ,49
                                ,50
                                ,51
                                ,52
                                ,53
                                ,54
                                ,55
                                ,56
                                ,57
                                ,63
                                ,64
                                ,65
                                ,66
                                ,67
                                ,92
                                ,93
                                ,94
                                ,95
                                ,96
                                ,97
                                ,98
                                ,99
                                ,100
                                ,101
                                ,102
                                ,103
                                ,104
                                ,105
                        )       
                        AND EXTRACT(MONTH FROM ca.datetime) BETWEEN 4 AND 7
                GROUP BY be.beat
        )
        GROUP BY b.beat;


SELECT  COUNT(iucr_id)
                FROM    beats b2
                WHERE   b.beat = b2.beat


Select avg(last_10_COUNT) AS last_10_avg from 
(
        
SELECT  COUNT(*) as num_cases
FROM    cases ca JOIN incident_locations i_l USING (il_id)
        JOIN beats be USING (beat_id)
WHERE   iucr_id IN (
                32
                ,33
                ,34
                ,35
                ,36
                ,37
                ,38
                ,39
                ,40
                ,41
                ,42
                ,43
                ,44
                ,46
                ,47
                ,48
                ,49
                ,50
                ,51
                ,52
                ,53
                ,54
                ,55
                ,56
                ,57
                ,63
                ,64
                ,65
                ,66
                ,67
                ,92
                ,93
                ,94
                ,95
                ,96
                ,97
                ,98
                ,99
                ,100
                ,101
                ,102
                ,103
                ,104
                ,105
        )       
        AND EXTRACT(MONTH FROM ca.datetime) > 3
        AND EXTRACT(MONTH FROM ca.datetime) < 8
GROUP BY be.beat;


)

EXPLAIN
SELECT
  AVG(a.incidents) as avg_incidents
  ,beat
FROM (
        SELECT  COUNT(ca.icur_id) as incidents 
        FROM    cases ca JOIN incident_locations i_l USING (il_id)
                JOIN beats be USING (beat_id)
        GROUP BY be.beat) as a
CROSS JOIN cases c
GROUP BY beat;


SELECT  COUNT(*) / COUNT(DISTINCT il.beat_id)::REAL AS avg_incidents
FROM    cases c JOIN incident_locations il USING (il_id)
        JOIN iucr_codes ic USING (iucr_id)
        JOIN beats b USING (beat_id)
WHERE   EXTRACT(MONTH FROM c.datetime) BETWEEN 4 AND 7
        AND ic.offense_type IN ('BATTERY', 'THEFT');



WITH beat_incidents AS (
        SELECT  be.beat, COUNT(ca.iucr_id) AS incidents
        FROM    beats be JOIN incident_locations i_l USING(beat_id)
                JOIN cases ca USING(il_id)
                JOIN iucr_codes i_c USING(iucr_id)
        WHERE   i_c.offense_type IN ('BATTERY', 'THEFT')
                AND EXTRACT(MONTH FROM ca.datetime) BETWEEN 4 AND 7
        GROUP BY be.beat
)
SELECT  b.beat
        ,bi.incidents
FROM    beats b
        ,beat_incidents bi
WHERE   bi.incidents > (
                SELECT  COUNT(*) / COUNT(DISTINCT il.beat_id)::REAL AS avg_incidents
                FROM    cases c JOIN incident_locations il USING (il_id)
                        JOIN iucr_codes ic USING (iucr_id)
                        JOIN beats b USING (beat_id)
                WHERE   EXTRACT(MONTH FROM c.datetime) BETWEEN 4 AND 7
                        AND ic.offense_type IN ('BATTERY', 'THEFT')
        )
GROUP BY b.beat;


SELECT  EXTRACT(HOUR FROM c.datetime) AS "Hour"
        ,ic.iucr_id
        ,COUNT(c.iucr_id) AS Incidents
FROM    cases c JOIN iucr_codes ic USING (iucr_id)
WHERE   ic.offense_type IN ('BATTERY', 'THEFT')
GROUP BY "Hour"
ORDER BY Incidents DESC;


SELECT  EXTRACT(DOW FROM c.datetime) AS "Day of Week"
        ,COUNT(c.iucr_id) AS Incidents
FROM    cases c JOIN iucr_codes ic USING (iucr_id)
WHERE   ic.offense_type IN ('BATTERY', 'THEFT')
GROUP BY "Month", "Day of Week", "Hour"
ORDER BY Incidents DESC;


SELECT  di.district_id
FROM    districts di JOIN incident_locations i_l
        USING(district_id)
        JOIN cases ca
        USING(il_id)
        JOIN iucr_codes i_c
        USING(iucr_id)
WHERE   offense_type IN ('THEFT', 'BATTERY')
GROUP BY di.district_id
ORDER BY COUNT(ca.iucr_id) DESC
LIMIT   5
-- 17,8,7,4,18


SELECT  d.district
        ,h.hours
FROM    cases c JOIN incident_locations il USING(il_id)
        JOIN districts d USING(district_id)
        JOIN iucr_codes ic USING(iucr_id)
        JOIN (
                SELECT  EXTRACT(HOUR FROM ca.datetime) AS hours
                        ,i_c.offense_type
                        ,COUNT(ca.iucr_id) AS incidents
                FROM    cases ca JOIN iucr_codes i_c USING (iucr_id)
                WHERE   i_c.offense_type IN ('BATTERY', 'THEFT')
                GROUP BY hours, i_c.iucr_id
                ORDER BY incidents DESC
                LIMIT   4
        ) AS h
        ON ic.offense_type = h.offense_type
WHERE   d.district_id IN (17,8,7,4,18)
GROUP BY h.hours, d.district;


SELECT  b.beat
        ,tbi.offense_type AS Offense
        ,to_char(AVG(tbi.incidents), '999,999.99') as "Avg. Incidents"
FROM    beats b JOIN incident_locations il
        USING(beat_id)
        JOIN cases c
        USING(il_id)
        JOIN (
                SELECT  ca.iucr_id
                         ,i_c.offense_type
                         ,COUNT(ca.iucr_id) AS incidents
                 FROM    cases ca JOIN iucr_codes i_c
                         USING(iucr_id)
                 WHERE   offense_type IN ('THEFT', 'BATTERY')
                 GROUP BY i_c.offense_type, ca.iucr_id
                 ORDER BY incidents DESC
        ) as tbi
        ON c.iucr_id = tbi.iucr_id
WHERE   b.beat_id in(227,226,224,2,300,46,44,68,236,6,1,52,43,100,95,70,65,62
                ,184,220,7,118,41,97,32,75,69,223,289,99,164,74,53,176
                ,189,90,47,54,40,146,34,56,145,131,55,29,3,79,35,225
        )
GROUP BY b.beat, Offense
ORDER BY b.beat, "Avg. Incidents" DESC
LIMIT   100;


SELECT  beat_id
                 FROM    cases ca JOIN iucr_codes i_c
                         USING(iucr_id)
                         JOIN incident_locations il USING(il_id)
                 WHERE   offense_type IN ('THEFT', 'BATTERY')
                 GROUP BY beat_id
                 ORDER BY COUNT(ca.iucr_id) DESC
                 LIMIT   50;

227,226,224,2,300,46,44,68,236,6,1,52,43,100,95,70,65,62,184,220,7,118,41,97,32,75,69,223,289,99,164,74,53,176,189,90,47,54,40,146,34,56,145,131,55,29,3,79,35,225