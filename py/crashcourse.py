# List 列表：有序sequence，动态，可以修改
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
employees = project_members[:]   # replicate list, used in functions to prevent function to change list

# if结构，for结构
if project_members: 
    for member in members:
        assign_task()
else:
    print("You currently don't have any member yet")

# Tuple 元组：有序sequence，静态，不可修改(immutable)
roles = (product_manager, engineer)
roles = (engineer, product_manager) # 不可修改元组元素，但可给存储元组的变量赋值

# Dictionary 字典：无序键值对， 动态，可以修改
hunt = {'first_name': 'hunt', 'age': 25, 'role': 'senior algorithm engineer', 'current_projects' = ['huantong']}
hunt['last_name'] = 'zhan'   # 添加键值对
hunt['current_projects'] = ['conversation', 'huantong']

del hunt['last_name']

languages = {
    'hunt': 'python',
    'bruno': 'javascript',
    'wenbing': 'javascript',
    }

for person, language in languages.items():
    print('\n' + person + ' likes ' +
        language.title() + 
        'the most.')
   
# Set 集合：无序sequence, 元素不可重复
uniq_languages = set(languages.values())
          

# Nesting 嵌套
kagura = {'first_name': 'kagura', 'age': 25, 'role': 'senior algorithm engineer', 'current_projects' = ['zhongjin']}
algorithm_engineers = [kagura, hunt]   # dictionary list
algorithm_engineers = {      # nested dict
    'hunt': hunt,
    'kagura': kagura,
    }

# 在for循环中不应该修改列表，否则将导致python难以追踪元素
# 使用while循环来遍历列表的同时对其进行修改
while unconfirmed_employees:
    current_employee = unconfirmed_employees.pop()
          
not_uniq_languages = languages.values()
while 'javascript' in not_uniq_languages:
    not_uniq_languages.remove('javascript')

# 函数 function
def greet():
   print('Morning!')

greet()

def greet_employee(name):
    print('Morning, ' + name.title() + '!')
    
greet_employee('hunt')

def get_employee(name, title, projects, age='', isintern=False):
    print('Employee name: '+ name.title() + '.')
    print('Employee title: ' + title + '.')
    print('Employee currently is involved in:')
    for project in projects:
        print(project)
    employee = {
        'name': name,
        'title': title,
        'projects': projects,
        'isintern': isintern,
        }
    if age:
        employee['age'] = age
    return employee

# 位置实参
get_employee('hunt', 'senior algorithm engineer', ['huantong', 'conversation'])
# 关键词实参
get_employee(name='hunt', projects=['huantong', 'conversation'], title='senior algorithm engineer')

# 当调用函数是给形参提供了实参时，使用指定实参值；否则使用形参的默认值。在形参给定默认值后，可在调用中省略相应实参
get_employee(name='ashley', projects=['huantong', 'tianjian'], title='pm intern',isintern=True)

# 使用函数，让程序更易拓展和维护
# 每个函数只应负责一项具体工作
# 可在函数中调用函数

def build_profile(name, title, **info):
    profile = {}
    profile['name'] = name
    profile['title'] = title
    for k, v in info.items():
        profile[k] = v
    return profile

employee_profile = build_profile('hunt', 'senior algorithm engineer', 
                                 age=25, projects=['huantong', 'conversation'])

# 可以将函数单独存储在独立文件（模块 module)中，使用时将模块导入即可
import employee as em  # module是扩展名为.py的文件，包含着要导入的代码
em.build_profile('ashley', 'intern', age=20)

from employee import build_profile # 将模块中的特定函数导入
build_profile('ashley', 'intern', age=20)

from employee import get_employee as gt
gt('hunt', 'senior algorithm engineer', ['huantong', 'conversation'])
   
# Object-oriented programming: Class - Object
# 类名中的每个单词的首字母都大写,而不使用下划线。实例名和模块名都采用小写格式,并在单词之间加上下划线。
# 对于每个类,都应紧跟在类定义后面包含一个文档字符串。这种文档字符串简要地描述类的功能,并遵循编写函数的文档字符串时采用的格式约定。
# 每个模块也都应包含一个文档字符串,对其中的类可用于做什么进行描述。
# 需要同时导入标准库中的模块和你编写的模块时,先编写导入标准库模块的 import 语句,再添加一个空行,然后编写导入你自己编写的模块的 import 语句。
# 在包含多条 import 语句的程序中,这种做法让人更容易明白程序使用的各个模块都来自何方。
class Employee():
    # 每个和class相关联的method调用都自动传递实参self
    # self是一个指向实例本身的引用，让实例能沟访问class中的attribute和method
    def __init__(self, name, title): 
        # 初始化属性
        self.name = name
        self.title = title
        self.time = 0
    def promote(self, new_title):
        # 通过方法修改属性的值
        if new_title != self.title:
            self.title = new_title
            print(name.title() + ' is now promoted to ' + new_title)
        else:
            print('This is not a valid promotion.')
   
employee_0 = Employee('hunt', 'algorithm engineer')
print(employee_0.name.title() + ' is a ' + employee_0.title + 'at Minerva.')
employee_0.promote('senior algorithm engineer')

class Machine():
   def __init__(self, name='HOST'):
       self.name = name
   def describe_machine(self):
       print('The machine is ' + self.name)
# Inheritance 继承 - parent class must be in front of child class
class Engineer(Employee):
   def __init__(self, name, title):
       # super() 链接parent class和child class
       super().__init__(name, title)
       self.languages = []
       self.machine = Machine()
   def update_language(self, languages):
       for language in languages:
           self.languages.append(language)
   # 重写parent class的method, python由此只会调用以下代码
   def promote(self, new_title, titles):
       if new_title in titles:
           self.title = new_title
           print(name.title() + ' is now promoted to ' + new_title)
       else:
           print('This is not a valid promotion.')

new_engineer = Engineer('ashley', 'sde intern')
new_engineer.update_language(['python', 'java', 'c'])
new_engineer.promote('sde I', ['sde I', 'sde II', 'algorithm engineer', 'senior algorithm engineer'])
new_engineer.machine.describe_machine()

# import a class
from employee import Employee 
   
# 读取文件 use 'with' keyword to avoid 'close' 
file_path = '/home/mnvai/huantong_poc_data/data/example_file.txt'
# 全部读取
with open(file_path) as fin:
   lines = fin.readlines()
for line in lines
   print(lines.rstrip())
# 逐行读取
with open(file_path) as fin:
   for line in fin:
      print(line.rstrip())

# 写入文件
with open(file_path, 'w') as fo:
   fo.write('Almost there.')

# TODO: chapter 10.3 异常情况处理

# 存储数据: json模块可以将简单的python数据结构转储到文件中
import json
numbers = [2,5,6,7,3,2,11]
filename = 'numbers.json'
with open(filename, 'w') as fo:
    json.dump(numbers, fo)
with open(filename) as fin:
    numbers = json.load(fin)
