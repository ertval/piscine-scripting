def clean_list(items):
    if not items:
        return []
    has_exact_milk = False
    has_stripped_milk = False
    cleaned = []
    for item in items:
        if item == 'milk':
            has_exact_milk = True
            cleaned.append(item)
        elif item.strip() == 'milk':
            has_stripped_milk = True
        else:
            cleaned.append(item)
    if not has_exact_milk and not has_stripped_milk:
        cleaned.append('milk')
    result = []
    for i, item in enumerate(cleaned, start=1):
        result.append(f"{i}/ {item.strip().capitalize()}")
    return result
