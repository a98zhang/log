# List 列表：有序集合，动态，可以修改
project_members = ['chen', 'bruno', 'kagura', 'hunt']

project_members.append('ashley')
project_members.insert(0, 'sherman')

del project_members[0]
last_added = project_members.pop()
first_added = project_members.pop(0)
project_members.remove('hunt')

project_members.sort(reverse=True)        # permanently changed
sorted(project_members, reverse=False)    # temporary
project_members.reverse()

for member in project_members:
  print(member)
for value in range(1,5):
  print(value)
indexes = list(range(1,5))
odd_indexes = list(range(1,5,2))

min(odd_indexes)
sum(odd_indexes)

squares = [value**2 for value in range(1,11)]  # 列表解析 list comprehension

values = list(range(1,10))[-3:]
employees = project_members[:]   # replicate list

if project_members: 
  for member in members:
    assign_task()
else:
  print('You currently don't have any member yet')

# Tuple 元组：有序集合，静态，不可修改(immutable)
roles = (product_manager, engineer)
roles = (engineer, product_manager) # 不可修改元组元素，但可给存储元组的变量赋值

# Dictionary 字典：无序键值对， 动态，可以修改
hunt = {'age': 25, 'role': 'senior algorithm engineer', 'current_projects' = ['huantong']}
hunt['last_name'] = 'zhan'   # 添加键值对
hunt['current_projects'] = ['conversation', 'huantong']

del hunt['last_name']

languages = {
    'hunt': 'python',
    'bruno': 'javascript',
    'wenbing': 'javascript',
    }

for person, language in languages.items():
    print('\n' + person + ' likes '
        language.title() + 
        'the most.')
   
# Set 集合
uniq_languages = set(languages.values())
