def day_from_number(day_number):
    """Convert day number (1-7) to day name. Returns None for invalid input."""
    number_to_day = {
        1: 'Monday',
        2: 'Tuesday',
        3: 'Wednesday',
        4: 'Thursday',
        5: 'Friday',
        6: 'Saturday',
        7: 'Sunday',
    }
    return number_to_day.get(day_number)


def day_to_number(day):
    """Convert day name to day number (1-7). Returns None for invalid input."""
    day_to_number_map = {
        'Monday': 1,
        'Tuesday': 2,
        'Wednesday': 3,
        'Thursday': 4,
        'Friday': 5,
        'Saturday': 6,
        'Sunday': 7,
    }
    return day_to_number_map.get(day)
