# coding=UTF-8

# 使用 Python 可视化包 Pygal 来生成可缩放的矢量图形文件。
# 需要在尺寸不同的屏幕上显示的图表, 将自动缩放,以适合观看者的屏幕。
# 如若考虑以在线方式使用图表,请考虑使用 Pygal

import pygal

from die import Die

die = Die()

results = []
for roll in range(1000):
    result = die.roll()
    results.append(result)

frequencies = []
for value in range(1, die.num_sides+1):
    frequency = results.count(value)
    frequencies.append(frequency)

hist = pygal.Bar()

hist.title = 'Results of rolling one D6 1000 times.'
hist.x_labels = ['1', '2', '3', '4', '5', '6']
hist.x_title = 'Result'
hist.y_title = 'Frequency of Result'

hist.add('D6', frequencies)
hist.render_to_file('die_visual.svg')