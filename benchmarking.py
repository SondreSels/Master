import pygame
import math
from queue import PriorityQueue
import random
import time
from timeit import default_timer as timer

WIDTH = 800

queue_size = 256
VISUALIZE = True
# Number of robots
num_robots = 1
# Percentage of barriers
percentage = 0.5
# Wich algorithm to use
algorithm = 1



RED = (255, 0, 0)
GREEN = (0, 255, 0)
BLUE = (0, 255, 0)
YELLOW = (255, 255, 0)
WHITE = (255, 255, 255)
BLACK = (0, 0, 0)
PURPLE = (128, 0, 128)
ORANGE = (255, 165 ,0)
GREY = (128, 128, 128)
TURQUOISE = (64, 224, 208)

NORTH = 0
EAST = 1
SOUTH = 2
WEST = 3

ROWS = 256

acceleration = 100
deceleration = 1
top_speed = 100

def calculate_time_to_travel_distance(initial_speed, acceleration, distance):
    if acceleration == 0:
        # Avoid division by zero
        return distance / initial_speed * 1000

    # Calculate the discriminant
    discriminant = initial_speed**2 + 2 * acceleration * distance

    if discriminant >= 0:
        # Calculate time using the positive square root
        t_positive = (-initial_speed + math.sqrt(discriminant)) / acceleration
        return t_positive * 1000  # Convert to milliseconds
    else:
        # No real solutions (negative discriminant)
        return None

def move_duration(distance, move_params):
    distance_to_max_speed = move_params.max_speed**2 / (2 * move_params.acceleration)
    distance_from_max_speed = move_params.max_speed**2 / (2 * move_params.deceleration)

    if distance_to_max_speed + distance_from_max_speed <= distance:
        time_to_max_speed = move_params.max_speed / move_params.acceleration
        time_from_max_speed = move_params.max_speed / move_params.deceleration

        time_at_max_speed = (distance - (distance_to_max_speed + distance_from_max_speed)) / move_params.max_speed
        return int(1000.0 * (time_to_max_speed + time_at_max_speed + time_from_max_speed))

    acceleration_ratio = move_params.deceleration / (move_params.acceleration + move_params.deceleration)
    distance_during_acceleration = distance * acceleration_ratio

    top_speed = math.sqrt(2 * move_params.acceleration * distance_during_acceleration)

    duration_of_acceleration = top_speed / move_params.acceleration
    duration_of_deceleration = top_speed / move_params.deceleration

    return int(1000.0 * (duration_of_acceleration + duration_of_deceleration))

# Define the MoveParameters class to represent moveParams
class MoveParameters:
    def __init__(self, max_speed, acceleration, deceleration):
        self.max_speed = max_speed
        self.acceleration = acceleration
        self.deceleration = deceleration

def create_priority_queue():
	priority_queue = []
	return priority_queue


	
def push_and_sort_priority_queue(priority_queue, item):
	if len(priority_queue) >= queue_size:
		priority_queue.append(item)
		item[3].make_open()		
		priority_queue.sort(key = lambda x: x[0])
		temp = priority_queue.pop(-1)
		temp[3].reset()
	else:
		priority_queue.append(item)
		item[3].make_open()
		priority_queue.sort(key = lambda x: x[0])

def push_and_sort_priority_queue2(priority_queue, item):
	#append the item to the priority queue and sort it
	priority_queue.append(item)
	priority_queue.sort(key = lambda x: x[0])
	item[3].make_open()
	

def is_empty_priority_queue(priority_queue):
	return priority_queue == []



FullTrackShiftMS = 530

speed = 500

MoveTimesMS = [0, 500]
for i in range(2,ROWS + 1):
	if speed > top_speed:
		speed -= acceleration
	MoveTimesMS.append(MoveTimesMS[i-1] + speed)
	

class Robot:
	def __init__(self, row, col, width, total_rows, ID):
		self.row = row
		self.col = col
		self.x = row * width
		self.y = col * width
		self.color = RED
		self.path = []
		self.width = width
		self.total_rows = total_rows
		self.is_moving = False
		self.direction = -1
		self.speed = 0
		self.current_move_time = 0
		self.time_used = 500
		self.ID = ID

	def move_spot(self, grid):
		# grid[self.row][self.col].reset()
		# self.row = self.path[0][0]
		# self.col = self.path[0][1]
		# self.path.pop(0)
		# grid[self.row][self.col].make_robot()
		# pygame.draw.rect(WIN, self.color, (self.x, self.y, self.width, self.width))
		if self.path != []:
			#self.time_used += grid[self.path[0][0]][self.path[0][1]].speed
			# check if robot is moving in same direction
			# if self.direction == get_direction(grid[self.row][self.col], grid[self.path[0][0]][self.path[0][1]]):
			# 	# check if robot is at top speed
			# 	if self.speed > top_speed:
			# 		self.speed -= acceleration
			# else:
			# 	# robot is changing direction
			# 	self.current_move_time += FullTrackShiftMS
			# 	self.speed = 500
			if grid[self.path[0][0]][self.path[0][1]].blocked != []:
				for block in grid[self.path[0][0]][self.path[0][1]].blocked:
					if self.time_used > block[0]+500 and self.time_used < block[1]-500 and block[2] == self.ID:
						grid[self.row][self.col].reset()
						#Remove the blockage from the grid
						grid[self.path[0][0]][self.path[0][1]].blocked.remove(block)
						self.row = self.path[0][0]
						self.col = self.path[0][1]
						self.path.pop(0)
						grid[self.row][self.col].make_robot()
						
			
	def update_time(self, time):
		self.time_used = time
	
	def assign_path(self, path):
		self.path = path

	def get_pos(self):
		return self.row, self.col
	
	def get_direction(self):
		return self.direction
	
	def update_blockage(self, grid):
		time_used = 0
		for i in range(len(self.path)-1):
			prev_time_used = time_used
			speed = grid[self.path[i][0]][self.path[i][1]].speed
			if speed == 0:
				time_used += FullTrackShiftMS
			else:
				time_used +=  calculate_time_to_travel_distance(speed, acceleration, 1)
			grid[self.path[i][0]][self.path[i][1]].blocked.append([prev_time_used, time_used, self.ID])



	

class Spot:
	def __init__(self, row, col, width, total_rows):
		self.row = row
		self.col = col
		self.x = row * width
		self.y = col * width
		self.color = WHITE
		self.neighbors = []
		self.width = width
		self.total_rows = total_rows
		self.direction = -1
		self.blocked = []
		self.speed = 0

	def get_pos(self):
		return self.row, self.col

	def is_closed(self):
		return self.color == YELLOW

	def is_open(self):
		return self.color == GREEN

	def is_barrier(self):
		return (self.color == BLACK)

	def is_start(self):
		return self.color == ORANGE

	def is_end(self):
		return self.color == TURQUOISE

	def reset(self):
		self.color = WHITE

	def make_start(self):
		self.color = ORANGE

	def make_closed(self):
		self.color = YELLOW

	def make_open(self):
		self.color = GREEN

	def make_barrier(self):
		self.color = BLACK

	def make_end(self):
		self.color = TURQUOISE

	def make_path(self):
		self.color = PURPLE

	def make_robot(self):
		self.color = RED


	def update_neighbors(self, grid):
		self.neighbors = []
		if self.row < self.total_rows - 1 and not grid[self.row + 1][self.col].is_barrier(): # DOWN
			self.neighbors.append(grid[self.row + 1][self.col])

		if self.row > 0 and not grid[self.row - 1][self.col].is_barrier(): # UP
			self.neighbors.append(grid[self.row - 1][self.col])

		if self.col < self.total_rows - 1 and not grid[self.row][self.col + 1].is_barrier(): # RIGHT
			self.neighbors.append(grid[self.row][self.col + 1])

		if self.col > 0 and not grid[self.row][self.col - 1].is_barrier(): # LEFT
			self.neighbors.append(grid[self.row][self.col - 1])

	def __lt__(self, other):
		return False

def get_direction(current, neighbor):
	direction = -1
	if current.row == neighbor.row:
		# The neighbor is to the left or right
		if current.col < neighbor.col:
			direction = EAST
		else:
			direction = WEST
	else:
		# The neighbor is above or below
		if current.row < neighbor.row:
			direction = SOUTH
		else:
			direction = NORTH
	return direction

def h(p1, p2):
	x1, y1 = p1
	x2, y2 = p2
	x_diff = abs(x1 - x2)
	y_diff = abs(y1 - y2)
	d = 0
	d += move_duration(x_diff, MoveParameters(3.04638961546259, 0.78125, 0.78125))
	d += move_duration(y_diff, MoveParameters(3.04638961546259, 0.78125, 0.78125))
	if x1 != x2 and y1 != y2:
		d += FullTrackShiftMS
	return d

def h2(p1, p2):
	x1, y1 = p1
	x2, y2 = p2
	x_diff = abs(x1 - x2)
	y_diff = abs(y1 - y2)
	d = x_diff + y_diff
	if x_diff > 0 and y_diff > 0:
		d += 2
	return (d)

def reconstruct_path(came_from, current, robot, grid):
	robot_path = [current.get_pos()]
	while current in came_from:
		current = came_from.pop(current)
		current.make_path()
		robot_path.append(current.get_pos())
	robot.assign_path(robot_path)
	# print the speeds of the robot path



def algorithm(grid, start, end, robot):
	count = 0
	open_set_north = create_priority_queue()
	open_set_east = create_priority_queue()
	open_set_south = create_priority_queue()
	open_set_west = create_priority_queue()
	push_and_sort_priority_queue(open_set_north, (0, 0, count, start, -1))
	came_from = {}
	closed_set = set()
	blockings = {}
	g_scores = {}
	expansions = 0

	

	while not is_empty_priority_queue(open_set_north) or not is_empty_priority_queue(open_set_east) or not is_empty_priority_queue(open_set_south) or not is_empty_priority_queue(open_set_west):

		# Find the open set with the lowest f score
		if not is_empty_priority_queue(open_set_north):
			open_item_north = open_set_north[0]
		else:
			open_item_north = (100000, 100000, 100000, start, -1)
		if not is_empty_priority_queue(open_set_east):
			open_item_east = open_set_east[0]
		else:
			open_item_east = (100000, 100000, 100000, start, -1)
		if not is_empty_priority_queue(open_set_south):
			open_item_south = open_set_south[0]
		else:
			open_item_south = (100000, 100000, 100000, start, -1)
		if not is_empty_priority_queue(open_set_west):
			open_item_west = open_set_west[0]
		else:
			open_item_west = (100000, 100000, 100000, start, -1)
		if open_item_north[0] <= open_item_east[0] and open_item_north[0] <= open_item_south[0] and open_item_north[0] <= open_item_west[0]:
			open_item = open_item_north
			open_set_north.pop(0)
		elif open_item_east[0] <= open_item_north[0] and open_item_east[0] <= open_item_south[0] and open_item_east[0] <= open_item_west[0]:
			open_item = open_item_east
			open_set_east.pop(0)
		elif open_item_south[0] <= open_item_north[0] and open_item_south[0] <= open_item_east[0] and open_item_south[0] <= open_item_west[0]:
			open_item = open_item_south
			open_set_south.pop(0)
		else:
			open_item = open_item_west
			open_set_west.pop(0)
		current = open_item[3]
		if open_item[4] != -1:
			came_from[current] = open_item[4]
		expansions += 1
		# if current in closed_set:
		# 	continue
		
		closed_set.add(current)
		# Check where current came from
		direction = -1
		if current == start:
			direction = -1
		else:
			previous = came_from[current]
			if current.row == previous.row:
				# The neighbor is to the left or right
				if current.col < previous.col:
					direction = WEST
				else:
					direction = EAST
			else:
				# The neighbor is above or below
				if current.row < previous.row:
					direction = NORTH
				else:
					direction = SOUTH

		if current == end:
			print("Found path")
			print("Expansions: " + str(expansions))
			# print the open set
			reconstruct_path(came_from, end, robot, grid)
			end.make_end()
			return expansions
		#start_time = timer()
		for neighbor in current.neighbors:
			neighbor_direction = -1
			if current.row == neighbor.row:
				# The neighbor is to the left or right
				if current.col < neighbor.col:
					neighbor_direction = EAST
				else:
					neighbor_direction = WEST
			else:
				# The neighbor is above or below
				if current.row < neighbor.row:
					neighbor_direction = SOUTH
				else:
					neighbor_direction = NORTH
			Evaluate = True
			# Check if the neighbor is in the closed set
			if neighbor in closed_set:
				Evaluate = False
			if Evaluate:
				# Find the direction between the current node and the neighbor
				if neighbor_direction == direction or direction == -1:
					temp_g_score = open_item[1] + 1
				else:
					temp_g_score = open_item[1] + 2
				if neighbor not in g_scores or temp_g_score < g_scores[neighbor]:
					g_scores[neighbor] = temp_g_score
					f_score = temp_g_score + h2(neighbor.get_pos(), end.get_pos())
					count += 1
					#Put the neighbor in the correct open set
					if neighbor_direction == NORTH:
						push_and_sort_priority_queue(open_set_north, (f_score, temp_g_score, count, neighbor, current))
					elif neighbor_direction == EAST:
						push_and_sort_priority_queue(open_set_east, (f_score, temp_g_score, count, neighbor, current))
					elif neighbor_direction == SOUTH:
						push_and_sort_priority_queue(open_set_south, (f_score, temp_g_score, count, neighbor, current))
					else:
						push_and_sort_priority_queue(open_set_west, (f_score, temp_g_score, count, neighbor, current))
				
		
		# end_time = timer()
		# print("Time used: " + str(end_time - start_time))
	print("No path found")
	return 1000000


def make_grid(rows, width):
	grid = []
	gap = width // rows
	for i in range(rows):
		grid.append([])
		for j in range(rows):
			spot = Spot(i, j, gap, rows)
			grid[i].append(spot)

	return grid



def main(width):
    expansion_list = []
    count = 0
    while len(expansion_list) < 10000:
        grid = make_grid(ROWS, width)
    # make barriers
        for row in grid:
            for spot in row:
                if spot != grid[0][0] and spot != grid[ROWS-1][ROWS-1]:
                    if random.random() < percentage:
                        spot.make_barrier()

        Robots = []
        # make robots
        for i in range(num_robots):
            # row = random.randint(0, ROWS-1)
            # col = random.randint(0, ROWS-1)
            row = 0
            col = 0
            Robots.append(Robot(row, col, width, ROWS, i))
            grid[row][col].make_robot()
        
        # grid[250][255].make_barrier()
        # grid[255][250].make_barrier()
        orders = set()
        spot = grid[255][255]
        order = spot
        order.make_end()
        orders.add(order)
        run = True
        print(len(expansion_list))
        for row in grid:
            for spot in row:
                spot.update_neighbors(grid)
        expansion = algorithm(lambda: grid, grid[Robots[0].row][Robots[0].col], list(orders)[0], Robots[0])
        count += 1
        if expansion != 1000000:
            print("Count: " + str(count))
            break
            expansion_list.append(expansion)
	# Find the average number of expansions
    print("Average number of expansions: " + str(sum(expansion_list)/len(expansion_list)))
    print("Size of expansion list: " + str(len(expansion_list)))
    print("Blocking percentage: " + str(percentage))

    # for row in grid:
    #     for spot in row:
    #         spot.update_neighbors(grid)
    # algorithm(lambda: grid, grid[Robots[0].row][Robots[0].col], list(orders)[0], Robots[0])
        

main(WIDTH)