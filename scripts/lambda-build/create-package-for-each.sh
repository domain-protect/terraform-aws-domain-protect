#!/bin/bash

echo "Executing create_package.sh..."

# Check Python version matches runtime
python_minor_version="$(python3 --version)"
python_version="${python_minor_version%.*}"
prefix="Python "
local_version="${python_version#$prefix}"
runtime_prefix="python"
lambda_version="${runtime#$runtime_prefix}"

if [ "$lambda_version" != "$local_version" ]; then
  echo "Error: local Python version does not match Lambda Python runtime"
  echo "Local Python version: $local_version"
  echo "Lambda Python version: $lambda_version"
  exit 1
fi

function_list=${function_names//:/ }

for i in $function_list
do
  dir_name=lambda_dist_pkg_$i/
  mkdir -p $path_cwd/build/$dir_name

  # Create and activate virtual environment...
  virtualenv -p $runtime $path_cwd/build/env_$i
  source $path_cwd/build/env_$i/bin/activate

  # Installing python dependencies...
  FILE=$path_cwd/lambda_code/$i/requirements.txt

  if [ -f "$FILE" ]; then
    echo "Installing dependencies..."
    echo "From: requirements.txt file exists..."
    pip install -r "$FILE"
  else
    echo "Error: requirements.txt does not exist!"
  fi

  # Deactivate virtual environment...
  deactivate

  # Create deployment package...
  echo "Creating deployment package..."
  cp -r $path_cwd/build/env_$i/lib/$runtime/site-packages/. $path_cwd/build/$dir_name
  cp $path_cwd/lambda_code/$i/$i.py $path_cwd/build/$dir_name
  cp -r $path_cwd/utils $path_cwd/build/$dir_name

# Removing virtual environment folder...
echo "Removing virtual environment folder..."
rm -rf $path_cwd/build/env_$i

done

echo "Finished script execution!"
