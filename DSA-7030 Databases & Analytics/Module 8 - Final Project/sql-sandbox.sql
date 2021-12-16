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
        ,COUNT(*) AS count
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

chicago_map_crime = folium.Map(location=[41.895140898, -87.624255632],
                        zoom_start=13,
                        tiles="CartoDB dark_matter")

chicago_map_crime = folium.Map(location=[41.895140898, -87.624255632],
                        zoom_start=13,
                        tiles="CartoDB dark_matter")

for i in range(500):
    lat = CR_index['LocationCoord'].iloc[i][0]
    long = CR_index['LocationCoord'].iloc[i][1]
    radius = CR_index['ValueCount'].iloc[i] / 45
    
    if CR_index['ValueCount'].iloc[i] > 1000:
        color = "#FF4500"
    else:
        color = "#008080"
    
    popup_text = """Latitude : {}<br>
                Longitude : {}<br>
                Criminal Incidents : {}<br>"""
    popup_text = popup_text.format(lat,
                               long,
                               CR_index['ValueCount'].iloc[i]
                               )
    folium.CircleMarker(location = [lat, long], popup= popup_text,radius = radius, color = color, fill = True).add_to(chicago_map_crime)


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
    
    country_id,
    indicator_id,
    year,
    value,
    (value - LAG(value,1) 
    OVER (PARTITION BY country_id,indicator_id ORDER BY year)) /LAG(value, 1) 
    OVER (ORDER BY year)*100 AS pct_change,
    LAG(year,1)
    OVER (PARTITION BY country_id,indicator_id ORDER BY year) as prev_obs_year
    
FROM data

ORDER BY country_id,indicator_id, year
)

SELECT country_id,
       indicator_id,
       year AS base_year,
       pct_change

FROM cte

WHERE FLOOR((year - prev_obs_year)/365) <=3
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
        ,avg(bi.incidents) as "Avg. Incidents"
        ,bi.incidents as "Incidents"
FROM    beats b JOIN (
            SELECT  be.beat_id
                    ,c.iucr_id
                    ,COUNT(iucr_id) as incidents
            FROM    incident_locations ils JOIN cases c
                    USING(il_id)
                    JOIN beats be
                    USING(beat_id)
            GROUP BY be.beat_id, iucr_id
        ) as bi
        ON b.beat_id = bi.beat_id
        JOIN iucr_codes ic
        ON bi.iucr_id = ic.iucr_id
GROUP BY b.beat, bi.incidents, Offense
ORDER BY "Avg. Incidents" DESC
LIMIT   50;