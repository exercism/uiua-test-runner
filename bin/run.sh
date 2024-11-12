#!/usr/bin/env sh

# Synopsis:
# Run the test runner on a solution.

# Arguments:
# $1: exercise slug
# $2: path to solution folder
# $3: path to output directory

# Output:
# Writes the test results to a results.json file in the passed-in output directory.
# The test results are formatted according to the specifications at https://github.com/exercism/docs/blob/main/building/tooling/test-runners/interface.md

# Example:
# ./bin/run.sh two-fer path/to/solution/folder/ path/to/output/directory/

if [ $# -lt 3 ]; then
    echo "usage: ./bin/run.sh exercise-slug path/to/solution/folder/ path/to/output/directory/"
    exit 1
fi

slug="$1"
solution_dir=$(realpath "${2%/}")
output_dir=$(realpath "${3%/}")
results_file="${output_dir}/results.json"

mkdir -p "${output_dir}"

echo "${slug}: testing..."

test_output=$(uiua test "${solution_dir}/tests.ua")

if [ $? -eq 0 ]; then
    jq -n '{version: 1, status: "pass"}' > ${results_file}
else
    if printf "${test_output}" | grep -q -E "tests? (failed|passed)"; then
        status="fail"
    else
        status="error"
    fi

    jq -n --arg output "${test_output}" --arg status "${status}" '{version: 1, status: $status, message: $output}' > "${results_file}"
fi

echo "${slug}: done"
