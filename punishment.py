def do_punishment(first_part, second_part, nb_lines):
    first_part = first_part.strip()
    second_part = second_part.strip()
    sentence = f"{first_part} {second_part}."
    return (sentence + "\n") * nb_lines if nb_lines > 0 else ""
