def random_string(length=5):  # nosec
    import random
    import string

    return "".join(random.choices(string.ascii_lowercase + string.digits, k=length))
