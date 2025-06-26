#!/bin/bash

# --- Parameter Configuration ---
alias_name="$1" # Short name to identify the DB connection
type_db="${2:-postgres}"
host="${3:-localhost}"
port="${4:-5432}"
user="${5:-your_user}" # Make sure to change this if not provided

echo "🚀 Starting Bitwarden item creation for DB '$alias_name'..."

# --- Argument Validation ---
if [ -z "$alias_name" ]; then
  echo "❌ Usage: $(basename "$0") <alias> [type] [host] [port] [user] [database]"
  echo "       <alias>: Short name to identify the DB connection (e.g., 'production-erp')"
  echo "       [type]: Database type (e.g., 'postgres', 'mysql', 'mssql'). Default: postgres"
  echo "       [host]: Database host. Default: localhost"
  echo "       [port]: Database port. Default: 5432"
  echo "       [user]: Database user. Default: your_user"
  echo "       [database]: Database name. Default: your_database"
  echo "   The password will be prompted interactively."
  exit 1
fi

# Determine the database name. If not provided as an argument, use a default or derive from alias.
# For simplicity, if argument $6 is not provided (which used to be pass), we assume it's the database.
# If $7 is provided, it's explicitly the database.
if [ -n "$6" ]; then
    database="$6" # User provided database as the 6th argument
    # If 7th arg is provided, it's the database, 6th is the user. Re-assign user for clarity.
    if [ -n "$7" ]; then
        user="$6"
        database="$7"
    fi
else
    # If 6th arg is not provided, then database will be default or needs to be prompted if no default.
    database="your_database" # Default database name if not provided
fi


# --- Prompt for password securely ---
read -s -p "Enter password for database user '$user': " pass
echo # Add a newline after the password prompt


# --- Prepare temporary JSON file ---
tmpfile="/tmp/bw-db-item-${alias_name}.json"

# Ensure the temporary file is deleted on exit, even if errors occur
trap 'rm -f "$tmpfile"' EXIT

# Generate JSON for the Bitwarden item
cat <<EOF > "$tmpfile"
{
  "type": 1,
  "name": "DB-${alias_name}",
  "login": {
    "username": "$user",
    "password": "$pass",
    "uris": [
      {
        "uri": "$host",
        "match": null
      }
    ]
  },
  "fields": [
    { "name": "Database Name", "value": "$database", "type": 0 },
    { "name": "Port",          "value": "$port",     "type": 0 },
    { "name": "DB Type",       "value": "$type_db",  "type": 0 }
  ]
}
EOF

echo "📝 JSON generated in $tmpfile"

# --- JSON Validation ---
if ! jq empty "$tmpfile" 2>/dev/null; then
  echo "❌ Error: Generated JSON is invalid. Please check the syntax."
  cat "$tmpfile" # Show invalid JSON for debugging
  exit 1
fi
echo "✅ JSON validated successfully."

# --- Bitwarden Session Verification ---
if [ -z "$BW_SESSION" ]; then
  echo "❌ Error: BW_SESSION environment variable is not defined."
  echo "   Please unlock your Bitwarden vault in your terminal and export the session:"
  echo "   export BW_SESSION=$(bw unlock --raw)"
  exit 1
fi
echo "🔑 Bitwarden session detected."

# --- JSON Encoding ---
ENCODED_JSON=$(bw encode < "$tmpfile")
if [ $? -ne 0 ]; then
  echo "❌ Error: JSON encoding failed with bw encode."
  exit 1
fi
echo "📦 JSON encoded successfully."

# --- Create item in Bitwarden ---
echo "⚙️ Creating item in Bitwarden..."
# Pass ENCODED_JSON as a positional argument
bw_output=$(echo "$ENCODED_JSON" | bw create item --session "$BW_SESSION" 2>&1)

if [ $? -eq 0 ]; then
  echo "🎉 Item 'DB-${alias_name}' created successfully in Bitwarden."
  echo "Item details created:"
  echo "$bw_output" | jq . # Format Bitwarden's JSON output
else
  echo "❌ Error creating item in Bitwarden."
  echo "Error message from Bitwarden CLI:"
  echo "$bw_output"
  exit 1
fi

echo "✨ Script finished."
