def clean_list(items):
    if not items:
        return []
    if not any(item.strip() == 'milk' for item in items):
        items.append('milk')
    result = []
    for i, item in enumerate(items, start=1):
        result.append(f"{i}/ {item.strip().capitalize()}")
    return result
