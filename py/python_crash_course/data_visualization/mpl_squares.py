#coding=utf-8
import matplotlib.pyplot as plt

# 绘制一条线，设置粗细
input_values = [1, 2, 3, 4, 5]
squares = [1, 4, 9, 16, 25]
plt.plot(input_values, squares, lw=5)

# 设置图表标题，给坐标轴加上标签
plt.title('Square Numbers', fontsize=24)
plt.xlabel('Value', fontsize=14)
plt.ylabel('Square of Value', fontsize=14)

# 设置刻度标记大小
plt.tick_params(axis='both', labelsize=14)

plt.show()
