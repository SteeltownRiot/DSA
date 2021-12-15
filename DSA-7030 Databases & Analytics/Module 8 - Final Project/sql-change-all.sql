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


