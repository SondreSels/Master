import matplotlib.pyplot as plt
import time

# start position
start = (2, 2)
end = (32, 32)

# Function to read coordinates from the file
def read_coordinates(file_path):
    with open(file_path, 'r') as file:
        coordinates = [line.strip() for line in file]
    return coordinates

# Function to plot coordinates on a grid
def plot_coordinates(coordinates, coordinates2):
    fig, ax = plt.subplots()
    ax.set_xlim(-10, 40)
    ax.set_ylim(-10, 40)
    ax.add_patch(plt.Rectangle(start, 1, 1, color='green'))
    ax.add_patch(plt.Rectangle(end, 1, 1, color='red'))
    plt.draw()

    for coord in coordinates:
        x_binary = coord[:8]
        y_binary = coord[8:]
        x_decimal = int(x_binary, 2)
        y_decimal = int(y_binary, 2)

        # If the coordinate is the start or end position, skip plotting it
        if (x_decimal, y_decimal) == start or (x_decimal, y_decimal) == end:
            continue

        ax.add_patch(plt.Rectangle((x_decimal, y_decimal), 1, 1, color='blue'))
        plt.draw()
        plt.pause(0.01)  # Adjust the pause time as needed
        time.sleep(0.01)
    
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
