# domain-protect Cloudflare manual scans
scans Cloudflare to detect:
* Subdomain NS delegations vulnerable to takeover
* Subdomains pointing to missing storage buckets
* Vulnerable CNAME records

## Python setup
* optionally create and activate a virtual environment
```
python -m venv .venv
source .venv/bin/activate
```
* install dependencies
```
pip install -r manual_scans/cloudflare/requirements.txt
```
* set PYTHONPATH to import modules
* identify your current path from the root of the domain-protect directory
```
$ pwd
/Users/paul/src/github.com/ovotech/domain-protect
```
* set PYTHONPATH environment variable
```
$ export PYTHONPATH="${PYTHONPATH}:/Users/paul/src/github.com/domain-protect/terraform-aws-domain-protect"
```
* or as a single command from the root dir
```
export PYTHONPATH=${PYTHONPATH}:$(pwd)
```
* run manual scans from root of domain-protect folder

## Set credentials
* In the Cloudflare console, My Profile, API Tokens, create an API Key
* Set as environment variables on your laptop
```
$ export CLOUDFLARE_API_KEY: "xxxxxxxxxxxxxxxxxx"
$ export CLOUDFLARE_EMAIL: "me@example.com
```

## subdomain NS delegations
<img src="../../docs/assets/images/cf/cf-ns.png" width="400">

```
python manual_scans/cloudflare/cf_ns.py
```

## subdomains pointing to missing storage buckets
<img src="../../docs/assets/images/cf/cf-storage.png" width="400">

```
python manual_scans/cloudflare/cf_storage.py
```

## vulnerable CNAMEs
<img src="../../docs/assets/images/cf/cf-cname.png" width="400">

```
python manual_scans/cloudflare/cf_cname.py
```

[back to README](../../README.md)
