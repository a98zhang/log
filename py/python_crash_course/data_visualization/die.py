from random import randint

class Die():
    '''a class that represents a die'''

    def __init__(self, num_sides=6):
        '''default number of sides of a die'''
        self.num_sides = num_sides

    def roll(self):
        '''return a random value'''
        return randint(1, self.num_sides)

        