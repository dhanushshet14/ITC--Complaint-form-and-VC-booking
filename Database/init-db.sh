#!/bin/bash

SQLCMD=/opt/mssql-tools18/bin/sqlcmd

start_sqlserver() {
    echo "Starting SQL Server..."
    /opt/mssql/bin/sqlservr &
    SQLSERVER_PID=$!
}

wait_for_sqlserver() {
    echo "Waiting for SQL Server to be ready..."
    for i in {1..180}; do
        $SQLCMD -S localhost -U sa -P "$SA_PASSWORD" -C -Q "SELECT 1" -b -o /dev/null 2>/dev/null
        if [ $? -eq 0 ]; then
            echo "SQL Server is ready."
            return 0
        fi
        sleep 5
    done
    echo "ERROR: SQL Server failed to start within timeout."
    return 1
}

run_sql_file() {
    local file=$1
    echo "Running: $file"
    $SQLCMD -S localhost -U sa -P "$SA_PASSWORD" -C -i "$file" -b
    if [ $? -ne 0 ]; then
        echo "ERROR: Failed to execute $file"
        exit 1
    fi
    echo "Completed: $file"
}

start_sqlserver
wait_for_sqlserver

run_sql_file /init/01_schema.sql
echo "Schema creation complete."

run_sql_file /init/02_stored_procedures.sql
echo "Stored procedures complete."

run_sql_file /init/03_seed_data.sql
echo "Seed data complete."

run_sql_file /init/04_employee_database.sql
echo "Employee database complete."

echo "============================================"
echo "  ITC CMS Database initialization complete!"
echo "============================================"

wait $SQLSERVER_PID
