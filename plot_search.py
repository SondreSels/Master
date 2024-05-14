import matplotlib.pyplot as plt
import time

# start position
start = (20, 20)
end = (64, 64)

def integer_to_position(integer_position):
    # Convert integer to binary string
    binary_position = format(integer_position, '016b')  # 16 bits total (8 bits for x, 8 bits for y)

    # Extract x and y binary strings
    binary_x = binary_position[:8]
    binary_y = binary_position[8:]

    # Convert binary strings to integers
    x_coordinate = int(binary_x, 2)
    y_coordinate = int(binary_y, 2)

    return x_coordinate, y_coordinate

# list of integers 
integers = [8214, 4640]

# Function to read coordinates from the file
def read_coordinates(file_path):
    with open(file_path, 'r') as file:
        coordinates = [line.strip() for line in file]
    return coordinates

# Function to plot coordinates on a grid
def plot_coordinates(coordinates, coordinates2):
    fig, ax = plt.subplots()
    ax.set_xlim(-10, 75)
    ax.set_ylim(-10, 75)
    ax.add_patch(plt.Rectangle(start, 1, 1, color='green'))
    ax.add_patch(plt.Rectangle(end, 1, 1, color='red'))

    # plot the integers
    for integer in integers:
        x, y = integer_to_position(integer)
        ax.add_patch(plt.Rectangle((x, y), 1, 1, color='black'))
        
    plt.draw()
    used = []
    for coord in coordinates:
        x_binary = coord[:8]
        y_binary = coord[8:]
        x_decimal = int(x_binary, 2)
        y_decimal = int(y_binary, 2)

        # If the coordinate is the start or end position, skip plotting it
        if (x_decimal, y_decimal) == start or (x_decimal, y_decimal) == end:
            continue
        # if the coordinate is already used, toggle the color
        if (x_decimal, y_decimal) in used:
            ax.add_patch(plt.Rectangle((x_decimal, y_decimal), 1, 1, color='orange'))
            used.remove((x_decimal, y_decimal))
        else:
            ax.add_patch(plt.Rectangle((x_decimal, y_decimal), 1, 1, color='blue'))
            used.append((x_decimal, y_decimal))
        
        plt.draw()
        plt.pause(0.0001)  # Adjust the pause time as needed
        time.sleep(0.0001)
    
    for coord in coordinates2:
        x_binary = coord[:8]
        y_binary = coord[8:]
        x_decimal = int(x_binary, 2)
        y_decimal = int(y_binary, 2)

        # If the coordinate is the start or end position, skip plotting it
        if (x_decimal, y_decimal) == start or (x_decimal, y_decimal) == end:
            continue

        ax.add_patch(plt.Rectangle((x_decimal, y_decimal), 1, 1, color='purple'))
        plt.draw()
        plt.pause(0.05)

    plt.grid(True)
    plt.xlabel('X Coordinate')
    plt.ylabel('Y Coordinate')
    plt.title('Grid Plot of Coordinates')
    plt.show()

# File path to pos.txt
file_path = 'pos.txt'
file_path2 = 'came_from.txt'

# Read coordinates from the file
coordinates = read_coordinates(file_path)
coordinates2 = read_coordinates(file_path2)

# Plot the coordinates on a grid one by one
plot_coordinates(coordinates, coordinates2)
