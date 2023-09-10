import os

os.system("pip list > ./pip_list.txt")

target_package_dict = dict()
with open('./python_package_list.txt') as f:
    contents = f.readlines()

    for content in contents[2:]:
        line_list = content.replace('\n', '').split('\t')
        
        name = line_list[0]
        try:
            version = line_list[1]
            target_package_dict[name] = version
        except:
            target_package_dict[name] = None

diff_package_dict = dict()
new_package_dict = dict()
with open('./pip_list.txt') as f:
    contents = f.readlines()

for content in contents[2:]:
    line_list = content.replace('\n', '').split(' ')
    name = line_list[0]

    try:
        version = line_list[-1]
    except:
        version = None

    try:
        if target_package_dict[name]!=version:
            diff_package_dict[name]=version
    except KeyError:
        if name: new_package_dict[name]=version

for key in diff_package_dict.keys():
    print(f"{key}=={diff_package_dict[key]}")
