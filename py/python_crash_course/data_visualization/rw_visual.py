import matplotlib.pyplot as plt

from random_walk import RandomWalk

''' visualize random walk'''

while True:
    # create a RandomWalk instance and plot the points
    rw = RandomWalk(50000)
    rw.fill_walk()

    # config the figure screen
    plt.figure(dpi=108, figsize=(10, 6))

    point_numbers = list(range(rw.num_points))
    plt.scatter(rw.x_values, rw.y_values, c=point_numbers, cmap= plt.cm.BuPu,
        edgecolor='none', s=1)

    #plt.plot(rw.x_values, rw.y_values, lw=1)

    # hide the axes
    plt.axes().get_xaxis().set_visible(False)
    plt.axes().get_yaxis().set_visible(False)

    # underscore the starting point and the ending point
    plt.scatter(0, 0, c='green', edgecolor='none', s=100)
    plt.scatter(rw.x_values[-1], rw.y_values[-1], c='red', edgecolor='none', s=100)    
    plt.show()

    keep_running = input('Make another walk? (y/n): ')
    if keep_running == 'n':
        break