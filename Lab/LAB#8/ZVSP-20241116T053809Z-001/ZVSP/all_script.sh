#!/bin/bash

# Ensure the script exits on error
set -e

# Function to print a formatted header for each step
print_header() {
  local message=$1
  local length=${#message}
  local border=$(printf '%*s' $((length + 8)) | tr ' ' '-')
  echo
  echo "$border"
  echo "   $message   "
  echo "$border"
  echo
}

# Function to execute a script, log its status, and take a break
run_script() {
  local script_name=$1
  print_header "Running $script_name..."
  if bash "$script_name"; then
    echo "[SUCCESS] $script_name completed."
  else
    echo "[ERROR] $script_name failed."
    exit 1
  fi
  echo "Taking a 10-second break before the next script..."
  sleep 10
}

# Start the execution process
print_header "Starting the VSP Data Processing Workflow"

# List of scripts to run
scripts=(
  "0_2_utl_Display_ZVSP_RAW.sh"
  "1_FBAutoPick.sh"
  "0_3_utl_CheckBPFandAmpRecovery.sh"
  "0_4_utl_FrequencyAnalysis.sh"
  "2_preprocessing.sh"
  "3_Separation.sh"
  "0_5_utl_CheckAutoCorrelation.sh"
  "4_ApplyPEFDecon.sh"
  "5_CorridorStack.sh"
)

# Loop through and execute each script
for script in "${scripts[@]}"; do
  run_script "$script"
done

# Final message
print_header "All Scripts Executed Successfully!"

