def remember_the_apple(shopping_list):
    """Add 'apple' to the shopping list if not present and list is non-empty."""
    if not shopping_list:
        return shopping_list
    if 'apple' not in shopping_list:
        shopping_list.append('apple')
    return shopping_list
