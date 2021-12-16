CREATE TABLE IF NOT EXISTS jch5x8.blocks(
        block_id INT PRIMARY KEY,
        block VARCHAR(150);

CREATE TABLE IF NOT EXISTS jch5x8.locations(
        loc_id INT PRIMARY KEY,
        location VARCHAR(250);

CREATE TABLE IF NOT EXISTS jch5x8.beats(
        beat_id INT PRIMARY KEY,
        beat INT);

CREATE TABLE IF NOT EXISTS jch5x8.districts(
        district_id INT PRIMARY KEY,
        district INT);

CREATE TABLE IF NOT EXISTS jch5x8.wards(
        ward_id INT PRIMARY KEY);
        ward INT);

CREATE TABLE IF NOT EXISTS jch5x8.community_areas(
        ca_id INT PRIMARY KEY,
        comm_area INT);

CREATE TABLE IF NOT EXISTS jch5x8.geolocs(
        geoloc_id INT PRIMARY KEY,
        x_coord REAL,
        y_coord REAL,
        lat REAL,
        long REAL,
        lat_long VARCHAR(50));

CREATE  TABLE IF NOT EXISTS jch5x8.incident_locations(
        il_id INT PRIMARY KEY,
        block_id INT REFERENCES jch5x8.blocks(block_id) ON DELETE SET NULL ON UPDATE CASCADE,
        loc_id INT REFERENCES jch5x8.locations(loc_id) ON DELETE SET NULL ON UPDATE CASCADE,
        beat_id INT REFERENCES jch5x8.beats(beat_id) ON DELETE SET NULL ON UPDATE CASCADE,
        district_id INT REFERENCES jch5x8.districts(district_id) ON DELETE SET NULL ON UPDATE CASCADE,
        ward_id INT REFERENCES jch5x8.wards(ward_id) ON DELETE SET NULL ON UPDATE CASCADE,
        ca_id INT REFERENCES jch5x8.community_areas(ca_id) ON DELETE SET NULL ON UPDATE CASCADE,
        geoloc_id INT REFERENCES jch5x8.geolocs(geoloc_id) ON DELETE SET NULL ON UPDATE CASCADE);

CREATE TABLE IF NOT EXISTS jch5x8.iucr_codes(
        iucr_id INT PRIMARY KEY,
        iucr VARCHAR(50),
        offense_type VARCHAR(50),
        description VARCHAR(100),
        nibrs INT);

CREATE  TABLE IF NOT EXISTS jch5x8.cases(
        case_id INT PRIMARY KEY,
        case_num VARCHAR(50),
        datetime DATETIME,
        arrest BOOL,
        domestic BOOL,
        updated_on DATETIME
        iucr_id INT REFERENCES jch5x8.iucr_codes(iucr_id) ON DELETE SET NULL ON UPDATE CASCADE,
        il_id INT REFERENCES jch5x8.incident_locations(il_id) ON DELETE SET NULL ON UPDATE CASCADE);

drop table if exists jch5x8.incident_locations, jch5x8.cases, jch5x8.iucr_codes, jch5x8.geolocs, jch5x8.community_areas, jch5x8.wards, jch5x8.districts, jch5x8.beats, jch5x8.locations, jch5x8.blocks;

drop table if exists jch5x8.incident_locations, jch5x8.cases, jch5x8.geolocs;

drop table if exists jch5x8.iucr_codes, jch5x8.cases;


SELECT  year,
        month,
        incidents
FROM    (SELECT EXTRACT(year FROM datetime) AS year
                ,EXTRACT(month FROM datetime) AS month
                ,COUNT(1) AS incidents
                ,RANK() OVER (PARTITION BY year ORDER BY COUNT(1) DESC) AS rank
        FROM    jch5x8.cases AS c JOIN iucr_codes AS ic
                USING (iucr_id)
        WHERE   offense_type = 'MOTOR VEHICLE THEFT'
        GROUP BY year, month) AS mvt
WHERE   rank = 1
ORDER BY year, month DESC;




SELECT  ic.offense_type AS Offense
        ,ic.description AS Description
        ,EXTRACT(MONTH FROM datetime)::INT AS Month
        ,incidents AS Incidents
FROM    jch5x8.cases c JOIN iucr_codes ic
        USING (iucr_id)
WHERE   c.iucr_codes IN (
        SELECT  iucr_id
                ,COUNT(*) AS Incidents
                ,EXTRACT(MONTH FROM ca.datetime) AS Month
        FROM    iucr_codes i_c join cases ca
                USING (iucr_id)
        GROUP BY iucr_id, month
        ORDER BY cnt DESC
        LIMIT   5)
GROUP BY ic.description, ic.offense_type, EXTRACT(MONTH FROM datetime)::INT
ORDER BY Month, Incidents DESC;


SELECT  tos.offense_type AS Offense
        ,tos.description AS Description
        ,EXTRACT(YEAR FROM datetime) AS Year
        ,EXTRACT(MONTH FROM datetime) AS Month
        ,tos.cnt AS Incidents
FROM    jch5x8.cases c JOIN iucr_codes ic
        USING (iucr_id)
WHERE   c.iucr_codes EXISTS (
        SELECT  iucr_id
        FROM    iucr_codes join cases
                USING (iucr_id)
        GROUP BY EXTRACT(YEAR FROM datetime), iucr_id
        ORDER BY EXTRACT(YEAR FROM datetime), COUNT(*) DESC
        LIMIT   5)
        USING (iucr_id)
GROUP BY Year, Month, tos.cnt, tos.offense_type, tos.description
ORDER BY Year, Month, tos.cnt DESC;



SELECT  iucr_id, offense_type
FROM    iucr_codes join cases
        USING (iucr_id)
GROUP BY EXTRACT(YEAR FROM datetime), iucr_id, offense_type
ORDER BY EXTRACT(YEAR FROM datetime), COUNT(*) DESC
LIMIT   5
;



# Load sql query into variable
monthly_incidents = '''
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
ORDER BY year, Month;'''

# Store sql results in a variable
result = %sql $monthly_incidents
# Print sql result
#result

# Store sql result in dataframe
df = pd.DataFrame(result, columns = ['Offense', 'Description', 'Year', 'Month', "Incidents"])
print(df.head(10))

# Set figure parameters
fig, ax = plt.subplots(1, 1, figsize = (25, 15))

# Set crime variable = to top 5 offenses
for crime in ['THEFT', 'BATTERY', 'battery', 'CRIMINAL DAMAGE', 'NARCOTICS']:
    plt.plot(df.loc[df['Offense'] == crime, ['Month']], df.loc[df['Offense'] == crime, ['Incidents']], label = crime.lower().capitalize(), linewidth = 3.0, alpha = 0.75)
plt.xticks(np.arange(1, 13, 1), color = 'grey', size = 20)
plt.yticks(np.arange(0, 32000, 10000), color = 'grey', size = 20)
plt.ylabel("Incidents Reported", color = 'grey', size = 30)
plt.xlabel("Month", color = 'grey', size = 30)
legend = plt.legend(bbox_to_anchor=(1.05, 1), fontsize = 20, frameon = False)
plt.setp(legend.get_texts(), color = 'grey')
# Display plot
plt.show()



# Set figure parameters
fig, ax = plt.subplots(1, 1, figsize=(25, 15))
# Set crime variable = to top 5 offenses
for crime in ['THEFT', 'BATTERY', 'battery', 'CRIMINAL DAMAGE', 'NARCOTICS']:
    plt.plot(df.loc[df['Offense'] == crime, ['Month']], df.loc[df['Offense'] == crime, ['Incidents']], label = crime.lower().capitalize(), linewidth = 3.0, alpha = 0.75)
plt.xticks(np.arange(1, 13, 1), color = 'grey')
plt.yticks(np.arange(0, 40000, 10000), color = 'grey')
plt.ylabel("Number of reports", color = 'grey', size = 30)
plt.xlabel("Month (1=January)", color = 'grey', size = 30)

legend = plt.legend(loc=1, fontsize = 'large', frameon = False)
plt.setp(legend.get_texts(), color = 'grey')
plt.show()





# Set crime variable = to top 5 offenses
for crime in ['THEFT', 'BATTERY', 'CRIMINAL DAMAGE', 'NARCOTICS']:
    plt.plot(df.loc[df['Offense'] == crime, ['Month']], df.loc[df['Offense'] == crime, ['Incidents']], label = crime.lower().capitalize(), linewidth = 3.0, alpha = 0.75)
plt.xticks(np.arange(1, 13, 1), color = 'grey')
plt.yticks(np.arange(0, 61000, 10000), color = 'grey')
plt.ylabel("Number of Incidents", color = 'grey', size = 30)
plt.xlabel("Month", color = 'grey', size = 30)

legend = plt.legend(loc = 1, fontsize = 'medium', frameon = False)
plt.setp(legend.get_texts(), color = 'grey')
plt.show()




monthFormatter = mdates.DateFormatter("%b")

# Set figure parameters
fig, ax = plt.subplots(1, 1, figsize = (35, 20))
ax.xaxis_date()
ax.xaxis.set_major_formatter(monthFormatter)

# Set crime variable = to top 5 offenses
for crime in ['THEFT', 'BATTERY', 'CRIMINAL DAMAGE', 'NARCOTICS']:
    plt.plot(df.loc[df['Offense'] == crime, ['Month']], df.loc[df['Offense'] == crime, ['Incidents']], label = crime.lower().capitalize(), linewidth = 3.0, alpha = 0.75)
plt.xticks(np.arange(1, 13, 1), color = 'grey', size = 20)
plt.yticks(np.arange(0, 40000, 10000), color = 'grey', size = 20)
plt.ylabel("Number of Incidents", color = 'grey', size = 30)
plt.xlabel("Month", color = 'grey', size = 30)

legend = plt.legend(loc = 1, fontsize = 'medium', frameon = False)
plt.setp(legend.get_texts(), color = 'grey')
plt.show()




ward_incidents = """
SELECT  EXTRACT(MONTH FROM datetime) AS Month
        ,offense_type AS Offense
        ,ward AS Ward
        ,COUNT(*) as count
FROM    cases c JOIN iucr_codes i_c
        USING   (iucr_id)
        JOIN incident_locations il
        USING (il_id)
        JOIN wards w
        USING (ward_id)
WHERE   ((offense_type = 'battery')
            OR (offense_type = 'BATTERY')
        )
        AND ((EXTRACT(MONTH FROM datetime) = 4)
            OR (EXTRACT(MONTH FROM datetime) = 7)
        )
GROUP BY Month, Offense, Ward
ORDER BY Month, Offense, Ward;"""

ward_data = chicago_crime.query_to_pandas_safe(ward_query)
# we could do the following with SQL queries instead, but usually best to do locally:
ward_battery = ward_data.loc[ward_data['primary_type'] == 'battery', ['year', 'ward', 'count']]
ward_battery_2017 = ward_battery.loc[ward_battery['year'] == 2017, ['ward', 'count']]
ward_battery_2016 = ward_battery.loc[ward_battery['year'] == 2016, ['ward', 'count']]
ward_theft = ward_data.loc[ward_data['primary_type'] == 'THEFT', ['year', 'ward', 'count']]
ward_theft_2017 = ward_theft.loc[ward_theft['year'] == 2017, ['ward', 'count']]
ward_theft_2016 = ward_theft.loc[ward_theft['year'] == 2016, ['ward', 'count']]

fig, ax = plt.subplots(1, 1, figsize=(25, 25))

myx = 100*(np.array(ward_theft_2017['count']) - np.array(ward_theft_2016['count']))/np.array(ward_theft_2016['count'])
myy = 100*(np.array(ward_battery_2017['count']) - np.array(ward_battery_2016['count']))/np.array(ward_battery_2016['count'])
plt.ylabel("battery change (%)", color='grey', size=30)
plt.xlabel("Theft change (%)", color='grey', size=30)
# plot axes through the origin:
ax.axhline(y=0, color='k', alpha=0.2)
ax.axvline(x=0, color='k', alpha=0.2)

for i in range(50):
    if (abs(myx[i]) > 19) or (abs(myy[i]) > 20): # only plot 'unusual' wards
        ax.annotate("Ward " + str(i), (myx[i], myy[i]), alpha=0.5, xytext = (myx[i] + 0.5, myy[i] + 0.5), size = 18)
ax.scatter(myx, myy, s = 1/50*(np.array(ward_theft_2017['count']) + np.array(ward_battery_2017['count'])))
plt.xticks(np.arange(-40, 50, 10), color='grey')
plt.yticks(np.arange(-40, 50, 10), color='grey')
plt.show()




SELECT  DISTINCT iucr.offense_type AS offense
        ,geo.lat_long AS lat_long
        ,COUNT(*) AS incidents
FROM    cases c JOIN incident_locations ic
        USING (il_id)
        JOIN iucr_codes iucr
        USING (iucr_id)
        JOIN geolocs geo
        USING (geoloc_id)
WHERE   (iucr.offense_type = 'THEFT'
        OR iucr.offense_type = 'BATTERY'
        OR iucr.offense_type = 'CRIMINAL DAMAGE'
        OR iucr.offense_type = 'NARCOTICS'
        OR iucr.offense_type = 'BURGLARY')
GROUP BY offense, lat_long;




chicago_crimes = '''
SELECT  DISTINCT iucr.offense_type AS offense
        ,geo.lat_long AS lat_long
        ,COUNT(*) AS incidents
FROM    cases c JOIN incident_locations ic
        USING (il_id)
        JOIN iucr_codes iucr
        USING (iucr_id)
        JOIN geolocs geo
        USING (geoloc_id)
WHERE   (iucr.offense_type = 'THEFT'
        OR iucr.offense_type = 'BATTERY')
GROUP BY offense, lat_long;
'''
# Store sql results in a variable
map_result = %sql $chicago_crimes
# Print sql result
print(map_result)

# Store sql result in dataframe
df = pd.DataFrame(map_result, columns = ['Month', 'Offense', 'Ward', "Incidents"])
#df.head(10))

# Create map of Chicago
chicago_map = folium.Map(location = [41.895140898, -87.624255632],
                        zoom_start = 13,
                        tiles = "CartoDB dark_matter")

# Iterate through the dataframe and add markers to the map
for i in range(500):
    lat = map_result['lat_long'].iloc[i][0]
    long = map_result['lat_long'].iloc[i][1]
    radius = map_result['incidents'].iloc[i] * 10
    
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


SELECT  EXTRACT(MONTH FROM datetime):INT AS month
        ,offense_type AS offense
        ,ward AS ward
        ,COUNT(*) as incidents
FROM    cases c JOIN iucr_codes i_c
        USING   (iucr_id)
        JOIN incident_locations il
        USING (il_id)
        JOIN wards w
        USING (ward_id)
WHERE   ((offense_type = 'battery')
            OR (offense_type = 'BATTERY')
        )
        AND ((EXTRACT(MONTH FROM datetime) = 4)
            OR (EXTRACT(MONTH FROM datetime) = 7)
        )
GROUP BY month, offense, ward
ORDER BY month, offense, ward
;