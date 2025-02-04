import pandas as pd
import folium
from folium.plugins import MarkerCluster
from folium.features import DivIcon

# Create enhanced dataset
data = {
    'Country': ['Côte d\'Ivoire', 'Ghana', 'Indonesia', 'Nigeria', 'Cameroon', 
                'Brazil', 'Ecuador', 'Peru', 'Dominican Republic', 'Colombia',
                'Papua New Guinea', 'Mexico', 'Venezuela', 'India', 'Liberia',
                'Sierra Leone', 'Togo', 'Guatemala', 'Honduras', 'Costa Rica'],
    'Production_Rank': list(range(1, 21)),
    'Slavery_Rank': [3, 2, 7, 4, 6, 9, 11, 8, 15, 13, 5, 12, 10, 20, 1, 14, 16, 17, 19, 18],
    'GDP_per_capita': [2270, 2200, 4293, 2085, 1523, 8920, 6215, 7129, 8775, 6427,
                       2862, 9946, 3728, 2103, 677, 548, 915, 4609, 2580, 12670],
    'Freedom_Rank': [130, 86, 113, 145, 153, 94, 111, 91, 78, 69, 89, 98, 162, 111, 120, 135, 128, 116, 121, 33],
    'Latitude': [7.54, 7.95, -0.79, 9.08, 7.37, -14.24, -1.83, -9.19, 18.74, 4.57,
                 -6.31, 23.63, 6.42, 20.59, 6.43, 8.46, 8.62, 15.78, 15.20, 9.75],
    'Longitude': [-5.55, -1.02, 113.92, 8.68, 12.35, -51.93, -78.18, -75.01, -70.16, -74.30,
                  143.96, -102.55, -66.59, 78.96, -9.43, -11.78, 0.82, -90.23, -86.24, -83.75],
    'Humanitarian_Quote': [
        "The greatest threat to our planet is the belief that someone else will save it.",
        "Freedom is not given, it is taken.",
        "Justice delayed is justice denied.",
        "Until the lions have their own historians, the history of the hunt will always glorify the hunter.",
        "A united people can never be defeated.",
        "The world is a great book, and those who do not travel read only a page.",
        "We don't inherit the earth from our ancestors, we borrow it from our children.",
        "When we stand together, no mountain is too high.",
        "The measure of a country's greatness is its ability to retain compassion in times of crisis.",
        "Peace cannot be kept by force; it can only be achieved by understanding.",
        "The wise man points to the stars, and the fool sees only the finger.",
        "They tried to bury us; they didn't know we were seeds.",
        "A people without memory is a people without future.",
        "Be the change you wish to see in the world.",
        "The price of freedom is eternal vigilance.",
        "When spider webs unite, they can tie up a lion.",
        "Unity is strength, division is weakness.",
        "The future belongs to those who prepare for it today.",
        "A small country can do big things when its people are united.",
        "Education is the most powerful weapon you can use to change the world."
    ]
}

df = pd.DataFrame(data)

# Create base map
m = folium.Map(location=[10, -20], zoom_start=3, tiles='cartodbpositron')

# Create numbered markers
marker_cluster = MarkerCluster().add_to(m)

for idx, row in df.iterrows():
    # Create custom number icon
    icon_number = DivIcon(
        icon_size=(30, 30),
        icon_anchor=(15, 15),
        html=f'<div style="font-size: 14pt; color: white; background: #8B4513; border-radius: 50%; width: 30px; height: 30px; display: flex; align-items: center; justify-content: center; border: 2px solid white">{row["Production_Rank"]}</div>'
    )
    
    # Create popup content
    popup_content = f'''
    <div style="width: 250px; font-family: Arial">
        <h3 style="color: #8B4513; margin: 0">{row['Country']}</h3>
        <p style="margin: 5px 0">
            <b>🥇 Production Rank:</b> {row['Production_Rank']}<br>
            <b>⚠️ Slavery Rank:</b> {row['Slavery_Rank']}<br>
            <b>🗽 Freedom Rank:</b> {row['Freedom_Rank']}<br>
            <b>💰 GDP per Capita:</b> ${row['GDP_per_capita']:,}
        </p>
        <blockquote style="background: #F5DEB3; padding: 10px; border-left: 3px solid #8B4513; margin: 5px 0">
            "{row['Humanitarian_Quote']}"
        </blockquote>
    </div>
    '''
    
    # Add marker to map
    folium.Marker(
        location=[row['Latitude'], row['Longitude']],
        icon=icon_number,
        popup=folium.Popup(popup_content, max_width=300),
        tooltip=f"Click for {row['Country']} details"
    ).add_to(marker_cluster)

# Add legend
legend_html = '''
<div style="
    position: fixed; 
    bottom: 50px; 
    left: 50px; 
    width: 200px; 
    height: auto; 
    background: white; 
    padding: 15px; 
    border-radius: 5px; 
    box-shadow: 0 0 10px rgba(0,0,0,0.2);
    z-index: 9999;
    font-family: Arial;
">
    <h4 style="margin: 0 0 10px 0; color: #8B4513">Map Legend</h4>
    <div style="margin-bottom: 8px">
        <div style="display: inline-block; width: 25px; height: 25px; background: #8B4513; color: white; border-radius: 50%; text-align: center; line-height: 25px">1</div>
        <span style="vertical-align: super; margin-left: 5px">= Production Rank</span>
    </div>
    <p style="margin: 5px 0; font-size: 0.9em">
        Click numbers to see:<br>
        - Slavery Rank<br>
        - Freedom Rank<br>
        - GDP per Capita<br>
        - Local Quote
    </p>
</div>
'''

m.get_root().html.add_child(folium.Element(legend_html))

# Add title
title_html = '''
<div style="
    position: fixed; 
    top: 20px; 
    left: 50%; 
    transform: translateX(-50%);
    font-size: 24px; 
    font-weight: bold; 
    color: #8B4513; 
    text-shadow: 2px 2px 4px rgba(255,255,255,0.8);
    z-index: 9999;
">
    🌍 Top 20 Cocoa Producers
</div>
'''

m.get_root().html.add_child(folium.Element(title_html))

# Display map
m
