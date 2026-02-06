import os
import glob

# for file in os.walk('lib'):
#     print(file)

# print(len(glob.glob('lib/**/*.dart', recursive=True)))
# print(len(glob.glob('ios/lib/**/*.dart', recursive=True)))

folder1 = 'lib'
folder2 = 'ios/lib'

# Get all directories in both folders
dirs1 = set()
dirs2 = set()

for root, dirs, files in os.walk(folder1):
    for dir in dirs:
        rel_path = os.path.relpath(os.path.join(root, dir), folder1)
        dirs1.add(rel_path)

for root, dirs, files in os.walk(folder2):
    for dir in dirs:
        rel_path = os.path.relpath(os.path.join(root, dir), folder2)
        dirs2.add(rel_path)

# Find directories in folder2 but not in folder1
diff = dirs2 - dirs1

print(f"Folders in {folder2} but not in {folder1}:")
for folder in sorted(diff):
    print(f"  {folder}")