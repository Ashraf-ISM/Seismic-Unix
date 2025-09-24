#!/bin/bash

# Description: This script processes all .su files in the current directory 
# using the 'suswapbytes' command and creates corresponding output files 
# with a "-test" suffix. It displays progress updates for each file.

# Start of the script
echo "========================================================================================="
echo "🚀 Starting the suswapbytes processing for all .su files in the current directory!"
echo "========================================================================================="

# Loop through each .su file and process them
for sufile in *.su; do
    echo "🔄 Processing file: $sufile"
    
    # Execute suswapbytes and create the output file with the "-test" suffix
    suswapbytes < "$sufile" > "${sufile%.su}-test.su"
    
    if [ $? -eq 0 ]; then
        echo "✅ Successfully swapped and saved as: ${sufile%.su}-test.su"
    else
        echo "❌ Error processing $sufile. Please check the file and try again."
    fi
    echo "-----------------------------------------------------------------"
done

# End of the script
echo "🎉 All .su files have been processed successfully!"
echo "================================================================="

