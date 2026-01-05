import os
import glob


for folder in os.listdir():
    if os.path.isdir(folder):
        files = glob.glob(os.path.join(folder, '*.png'))
        for file in files:
            os.remove(file)
            print(f"Deleted: {file}")