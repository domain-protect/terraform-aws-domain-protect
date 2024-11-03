from time import sleep

from utils.utils_db import db_get_unfixed_vulnerability_found_date_time


def vulnerability_detected_in_time_period(domain, seconds):

    while seconds > 0:
        if db_get_unfixed_vulnerability_found_date_time(domain):
            print(f"{domain} vulnerability detected successfully")
            return True
        sleep(5)
        print(f"{seconds} seconds remaining")
        seconds -= 5
