from random import choice

'''simulate random_walk'''

class RandomWalk():
    ''' a class that generates random walk data'''
    
    def __init__(self, num_points=5000):
        '''initialize attributes'''
        self.num_points = num_points
        # all random walks start with (0, 0)
        self.x_values = [0]
        self.y_values = [0]

    def get_step(self):
        '''determine the direction and the distance of the step'''
        direction = choice([1, -1])
        distance = choice([0, 1, 2, 3, 4])
        step = direction * distance
        return step

    def fill_walk(self):
        '''generate all te points of random walk'''
        
        # keep walking, until the list reaches its predetermined size:
        while len(self.x_values) < self.num_points:

            x_step = self.get_step()
            y_step = self.get_step()
        
            # preclude not moving
            if x_step == 0 and y_step == 0:
                continue
            
            # re-adjust the location for next iteration
            next_x = self.x_values[-1] + x_step
            next_y = self.y_values[-1] + y_step

            self.x_values.append(next_x)
            self.y_values.append(next_y)