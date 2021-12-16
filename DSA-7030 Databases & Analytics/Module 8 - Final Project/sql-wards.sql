ward_incidents = """
SELECT  EXTRACT(MONTH FROM datetime) AS Month
        ,offense_type AS Offense
        ,ward AS Ward
        ,COUNT(*) as Incidents
FROM    cases c JOIN iucr_codes i_c
        USING (iucr_id)
        JOIN incident_locations il
        USING (il_id)
        JOIN wards w
        USING (ward_id)
WHERE   ((offense_type = 'THEFT')
            OR (offense_type = 'BATTERY')
        )
        AND ((EXTRACT(MONTH FROM datetime) = 4)
            OR (EXTRACT(MONTH FROM datetime) = 7)
        )
GROUP BY Month, Offense, Ward
ORDER BY Month, Offense, Ward;"""

# Store sql results in a variable
ward_result = %sql $ward_incidents
# Print sql result
print(ward_result)

# Store sql result in dataframe
dfw = pd.DataFrame(ward_result, columns = ['Month', 'Offense', 'Ward', "Incidents"])
#dfw.head(10))

# Create variables for calculations
theft = dfw.loc[ward_incidents['Offense'] == 'THEFT', ['Month', 'Ward', 'Incidents']]
theft_jul = theft.loc[theft['Month'] == 7, ['Ward', 'Incidents']]
theft_apr = theft.loc[theft['Month'] == 4, ['Ward', 'Incidents']]
battery = dfw.loc[ward_incidents['Offense'] == 'BATTERY', ['Month', 'Ward', 'Incidents']]
battery_jul = battery.loc[battery['Month'] == 7, ['Ward', 'Incidents']]
battery_apr = battery.loc[battery['Month'] == 4, ['Ward', 'Incidents']]

# Set figure parameters
fig, ax = plt.subplots(1, 1, figsize = (25, 25))

myx = 100*(np.array(battery_jul['Incidents']) - np.array(battery_apr['Incidents']))/np.array(battery_apr['Incidents'])
myy = 100*(np.array(theft_jul['Incidents']) - np.array(theft_apr['Incidents']))/np.array(theft_apr['Incidents'])
plt.ylabel("Theft change (%)", color = 'grey', size = 30)
plt.xlabel("Battery change (%)", color = 'grey', size = 30)
# plot axes through the origin:
ax.axhline(y = 0, color = 'k', alpha = 0.2)
ax.axvline(x = 0, color = 'k', alpha = 0.2)

# Iterate through the dataframe and add high-incident wards to plot
for i in range(50):
    if (abs(myx[i]) > 19) or (abs(myy[i]) > 20): # only plot high-incident wards
        ax.annotate("Ward " + str(i), (myx[i], myy[i]), alpha = 0.5, xytext = (myx[i] + 0.5, myy[i] + 0.5), size = 18)
ax.scatter(myx, myy, s = 1/50*(np.array(battery_jul['Incidents']) + np.array(theft_jul['Incidents'])))
plt.xticks(np.arange(-40, 50, 10), color = 'grey')
plt.yticks(np.arange(-40, 50, 10), color = 'grey')
plt.show()