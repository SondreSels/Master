def position_to_integer(x, y):
    # Convert x and y to 8-bit binary strings
    binary_x = format(x, '08b')
    binary_y = format(y, '08b')

    # Concatenate binary strings
    binary_position = binary_x + binary_y

    # Convert binary string to integer
    integer_position = int(binary_position, 2)

    return integer_position

# Example usage:
x_coordinate = 64
y_coordinate = 51

result = position_to_integer(x_coordinate, y_coordinate)
print("Integer position:", result)
