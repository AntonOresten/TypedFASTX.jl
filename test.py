import random
import svgwrite

# Julia standard colors
colors = ["#4063D8", "#389826", "#9558B2", "#CB3C33"]

# SVG dimensions (aspect ratio 4/2)
width = 400
height = 200

# Number of strands
num_strands = len(colors)

# Minimum and maximum number of bases per strand
min_bases = 10
max_bases = 12

# Strand spacing (horizontal)
strand_spacing = width / (num_strands + 1)


import numpy as np

# Increase base (circle) radius
base_radius = 11

# Wave amplitude and frequency
wave_amplitude = 10
wave_frequency = 2 * np.pi / height

# Initialize SVG
dwg = svgwrite.Drawing('docs/sticker.svg')

# Adjust for horizontal strands

# Strand spacing (vertical now)
strand_spacing = height / (num_strands + 1)

# Wave frequency (across width now)
wave_frequency = 2 * np.pi / width
from svgwrite import cm, mm, rgb
from matplotlib import colors

random.seed(69)

def add_jitter(color, jitter_amount=0.05):
    # Convert hex color to RGB
    rgb_color = colors.hex2color(color)
    
    # Convert RGB color to HSV
    hsv_color = colors.rgb_to_hsv(rgb_color)
    
    # Add jitter to hue and value (brightness)
    hsv_jittered = hsv_color + jitter_amount * np.random.uniform(-1, 1, size=3)
    
    # Make sure hue and value are within valid range
    hsv_jittered[0] = hsv_jittered[0] % 1  # Hue wraps around
    hsv_jittered[2] = np.clip(hsv_jittered[2], 0, 1)  # Value is between 0 and 1
    
    # Convert jittered HSV color back to RGB
    rgb_jittered = colors.hsv_to_rgb(hsv_jittered)
    
    # Convert jittered RGB color to hex
    hex_jittered = colors.rgb2hex(rgb_jittered)
    
    return hex_jittered

# Julia standard colors
julia_colors = ["#4063D8", "#389826", "#9558B2", "#CB3C33"]

# Draw strands
for i in range(num_strands):
    # Number of bases for this strand
    num_bases = random.randint(min_bases, max_bases)
    
    # Base spacing (horizontal now)
    base_spacing = width / (num_bases + 1)
    
    # Strand y-coordinate
    strand_y = (i + 1) * strand_spacing
    
    phase = random.random() * 2
    
    # Draw bases
    for j in range(num_bases):
        # Base x-coordinate
        base_x = (j + 1) * base_spacing
        
        # Wave displacement
        displacement = wave_amplitude * np.sin(wave_frequency * base_x + phase)
        
        # Adjusted y-coordinate
        adjusted_y = strand_y + displacement
        
        # Jittered color
        jittered_color = add_jitter(julia_colors[i])
        
        # Draw base (circle)
        dwg.add(dwg.circle(center=(base_x, adjusted_y), r=base_radius, fill=jittered_color))

# Save SVG
dwg.save()

# Read SVG file content
with open("docs/sticker.svg", "r") as f:
    svg_content = f.read()

svg_content
