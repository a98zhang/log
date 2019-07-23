#coding=utf-8
import matplotlib.pyplot as plt
'''
# 1. 绘制一个点，设置大小
plt.scatter(2, 10, s=200)

# 2. 绘制一系列点
x_values = [1, 2, 3, 4, 5]
y_values = [1, 4, 9, 16, 25]
plt.scatter(x_values, y_values, s=100)
'''
# 3. 绘制自动生成数据
x_values = list(range(1, 1001))
y_values = [x**2 for x in x_values]
plt.scatter(x_values, y_values, c='skyblue', edgecolor='none', s=40)

# 4. 使用colormap
plt.scatter(x_values, y_values, c=y_values, cmap=plt.cm.BuPu,
    edgecolor='none', s=40)


# 设置图表标题，给坐标轴加上标签
plt.title('Square Numbers', fontsize=24)
plt.xlabel('Value', fontsize=14)
plt.ylabel('Square of Value', fontsize=14)

# 设置刻度标记大小
plt.tick_params(axis='both', labelsize=14)

# 设置坐标轴的取值范围
plt.axis([0, 1100, 0, 1100000])

plt.show()
plt.savefig('squares_plot.png', bbox_inches='tight')