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
    
    if map_result['incidents'].iloc[i] > 100:
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
