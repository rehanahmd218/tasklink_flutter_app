import os
import re
from pathlib import Path
from bs4 import BeautifulSoup

# Get the directory containing this script
base_dir = Path(__file__).parent

# Dictionary to store image data
image_data = {}

# Find all code.html files
html_files = list(base_dir.glob('**/code.html'))

print(f"Found {len(html_files)} HTML files\n")

def extract_url_from_background_image(style_string):
    """Extract URL from CSS background-image property"""
    if not style_string:
        return None
    
    match = re.search(r'background-image:\s*url\(["\']?([^"\')\s]+)["\']?\)', style_string)

    if match:
        return match.group(1)
    return None

def is_lh3_image(url):
    """Check if URL is from lh3 domain (Google Images)"""
    return 'lh3.' in url and ('googleusercontent.com' in url or 'ggpht.com' in url)

# Process each HTML file
for html_file in sorted(html_files):
    with open(html_file, 'r', encoding='utf-8') as f:
        html_content = f.read()
    
    # Parse HTML
    soup = BeautifulSoup(html_content, 'html.parser')
    
    # Find all img tags
    img_tags = soup.find_all('img')
    # print(f"Found {len(img_tags)} <img> tags in {html_file.relative_to(base_dir)}")
    for img in img_tags:
        # Get src attribute
        src = img.get('src', '')
        
        # Check if src is from lh3 domain
        if is_lh3_image(src):
            # Get data-alt from img tag
            alt_text = img.get('data-alt', '')
            
            # If no data-alt in img, try to find it in parent div
            if not alt_text:
                parent = img.parent
                if parent:
                    alt_text = parent.get('data-alt', '')
            
            # If still no alt_text, create one from URL
            if not alt_text:
                alt_text = f"Image_{src[-20:]}"
            
            # Add to dictionary if not already present
            if alt_text not in image_data:
                image_data[alt_text] = src
                print(f"✓ [IMG] {alt_text}")
                print(f"  URL: {src[:80]}...\n")
    
    # Find all divs with background-image style
    divs = soup.find_all('div')
    for div in divs:
        style = div.get('style', '')
        alt_text = div.get('data-alt', '')
        
        # Extract URL from background-image
        if style and 'background-image' in style:
            url = extract_url_from_background_image(style)
            
            # Check if URL is from lh3 domain
            if url and is_lh3_image(url):
                # Use alt_text if available, otherwise use URL hash
                if alt_text:
                    key = alt_text
                else:
                    # Use last 20 chars of URL as unique identifier
                    key = f"Image_{url[-20:]}"
                
                if key not in image_data:  # Avoid duplicates
                    image_data[key] = url
                    print(f"✓ [DIV] {key}")
                    print(f"  URL: {url[:80]}...\n")

# # Print the output
# print("\n" + "="*80)
# print("LINK:NAME FORMAT:")
# print("="*80 + "\n")

# for key, value in sorted(image_data.items()):
#     print(f"{value}:{key}")

# print(f"\n\nTotal images extracted: {len(image_data)}")

# # Also save to a text file
# output_file = base_dir / 'image_data.txt'
# with open(output_file, 'w', encoding='utf-8') as f:
#     for key, value in sorted(image_data.items()):
#         f.write(f"{value}:{key}\n")

# print(f"✓ Data saved to: {output_file}")
