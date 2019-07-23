# coding=UTF-8

# 使用 Python 可视化包 Pygal 来生成可缩放的矢量图形文件。
# 需要在尺寸不同的屏幕上显示的图表, 将自动缩放,以适合观看者的屏幕。
# 如若考虑以在线方式使用图表,请考虑使用 Pygal

import pygal

from die import Die

die_1 = Die()
die_2 = Die(10)

results = []
for roll in range(50000):
    result = die_1.roll() + die_2.roll()
    results.append(result)

frequencies = []
max_result = die_1.num_sides + die_2.num_sides
for value in range(1, max_result+1):
    frequency = results.count(value)
    frequencies.append(frequency)

hist = pygal.Bar()

hist.title = 'Results of rolling two D6 dice 1000 times.'
hist.x_labels = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12',
    '13', '14', '15', '16']
hist.x_title = 'Result'
hist.y_title = 'Frequency of Result'

hist.add('D6 + D10', frequencies)
hist.render_to_file('dice_visual_diff.svg')