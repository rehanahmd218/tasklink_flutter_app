import os
import requests
from pathlib import Path
from urllib.parse import urlparse
import re
from image_data import image_data

# Paths
base_dir = Path(__file__).parent
assets_dir = base_dir / 'assets'

# Create assets directory
assets_dir.mkdir(exist_ok=True)

print(f"Found {len(image_data)} images to download\n")

# Function to categorize image based on name
def categorize_image(description):
    """Categorize image into folder based on description"""
    desc_lower = description.lower()
    
    if 'portrait' in desc_lower or 'profile' in desc_lower or 'avatar' in desc_lower:
        return 'portraits'
    elif 'map' in desc_lower or 'street' in desc_lower or 'location' in desc_lower:
        return 'maps'
    elif 'furniture' in desc_lower or 'wardrobe' in desc_lower or 'bookshelf' in desc_lower or 'drawer' in desc_lower:
        return 'furniture'
    elif 'lawn' in desc_lower or 'garden' in desc_lower or 'grass' in desc_lower or 'hedge' in desc_lower:
        return 'outdoor'
    elif 'kitchen' in desc_lower or 'room' in desc_lower or 'living' in desc_lower or 'interior' in desc_lower:
        return 'interiors'
    elif 'box' in desc_lower or 'cardboard' in desc_lower or 'moving' in desc_lower:
        return 'logistics'
    elif 'chat' in desc_lower or 'screenshot' in desc_lower:
        return 'ui'
    elif 'blueprint' in desc_lower or 'plan' in desc_lower or 'architecture' in desc_lower:
        return 'technical'
    else:
        return 'other'

# Function to sanitize filename
def sanitize_filename(name, max_length=100):
    """Create safe filename from description"""
    # Remove special characters
    name = re.sub(r'[<>:"/\\|?*]', '', name)
    # Replace spaces with underscores
    name = name.replace(' ', '_')
    # Limit length
    if len(name) > max_length:
        name = name[:max_length]
    return name

# Download images
success_count = 0
failed_count = 0
failed_urls = []

items = list(image_data.items())

for i, (description, url) in enumerate(items, 1):
    try:
        # Get category and create folder
        category = categorize_image(description)
        category_dir = assets_dir / category
        category_dir.mkdir(exist_ok=True)
        
        # Sanitize filename
        safe_name = sanitize_filename(description)
        
        # Determine file extension from URL
        parsed_url = urlparse(url)
        path = parsed_url.path
        if path:
            ext = Path(path).suffix or '.jpg'
        else:
            ext = '.jpg'
        
        filename = f"{safe_name}{ext}"
        filepath = category_dir / filename
        
        # Download image
        print(f"[{i}/{len(items)}] Downloading: {description[:50]}...")
        
        response = requests.get(url, timeout=10, allow_redirects=True)
        response.raise_for_status()
        
        # Save image
        with open(filepath, 'wb') as f:
            f.write(response.content)
        
        print(f"✓ Saved to: {category}/{filename}")
        success_count += 1
        
    except Exception as e:
        print(f"❌ Error downloading image {i}: {str(e)[:80]}")
        failed_count += 1
        failed_urls.append((description, url))

# Summary
print(f"\n{'='*80}")
print(f"SUMMARY")
print(f"{'='*80}")
print(f"✓ Successfully downloaded: {success_count}")
print(f"❌ Failed downloads: {failed_count}")
print(f"Total processed: {success_count + failed_count}")

if failed_urls:
    print(f"\nFailed URLs:")
    for desc, url in failed_urls[:5]:
        print(f"  - {desc}: {url[:60]}...")

# Print folder structure
print(f"\n{'='*80}")
print(f"FOLDER STRUCTURE CREATED")
print(f"{'='*80}")
for category in sorted(assets_dir.iterdir()):
    if category.is_dir():
        count = len(list(category.glob('*')))
        print(f"📁 {category.name}/ ({count} images)")
        for img in sorted(category.glob('*'))[:3]:
            print(f"   └─ {img.name}")
        if count > 3:
            print(f"   └─ ... and {count - 3} more")
