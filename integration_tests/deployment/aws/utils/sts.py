import logging
import os

from utils.utils_aws import create_session
from utils.utils_aws import generate_temporary_credentials


def assume_test_role(account, region_override="None"):
    project = os.environ["PROJECT"]
    test_role_name = os.environ["TEST_ROLE_NAME"]
    external_id = os.environ["EXTERNAL_ID"]

    try:
        assumed_role_object = generate_temporary_credentials(account, test_role_name, external_id, project)

        credentials = assumed_role_object["Credentials"]

        return create_session(credentials, region_override)

    except Exception:
        logging.exception("ERROR: Failed to assume " + test_role_name + " role in AWS account " + account)

        return None
