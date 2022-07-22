"""
Author: Joseph Yi
Date: 06/27/2022
Description: Python module to Drop Tables from 
"""
# Import dependencies
import psycopg2
import sys
import subprocess
import pandas as pd


# Pip install fast_map module for concurrent processes w/ subprocesses
subprocess.check_call([sys.executable, '-m','pip','install','fast_map'])

# Import fast-map after pip install
from fast_map import fast_map

class ConnectPost(object):
    """
    Connect to Postgres.
    """
    def create_connection(user:str, pw:str):
        """
        | Function to create connection to Postgres.
        
        Arguments:
        :param: user: Username for database.
        :param: pw: Password for database.
            
        returns: Connection.
        """
        return psycopg2.connect(database="casestdysu22t04",
                                host="pgsql.dsa.lan",
                                user=user, 
                                password=pw)
    
# ---------------------------------------------------------------
class DropTable(object):
    """
    Drop Tables object.
    """
    @staticmethod
    def drop_table_sql(table_name:str):
        """
        | Function to create Drop Table SQL.
        
        Arguments:
        :param: table_name: Table Name.
        
        returns: SQL statement.
        """
        
        return f"""
        DROP TABLE IF EXISTS {table_name};
        """

    @staticmethod
    def drop_execution(user:str, pw:str, sql:str) -> None:
        """
        | Function to Drop Tables.
        
        Arguments:
        :param: user: Username for database.
        :param: pw: Password for database.
        :param: sql: SQL statement.
        
        returns: None.
        """   
        # Create connection
        connection = ConnectPost.create_connection(user, pw)
        cursor = connection.cursor()
        
        # Execute Drop SQL
        cursor.execute(sql)
        connection.commit()
        
        # Close Connection
        if(connection):
            cursor.close()
            connection.close()
            print("PostgreSQL connection is closed")
            
        del user, pw
            
        return "Drop sequence complete."

# ---------------------------------------------------------------
class RunSchema(object):
    """
    Run Schema SQL to create tables.
    """
    @staticmethod
    def run_schema(user:str, pw:str, schema_location:str):
        """
        | Function to Run Schema SQL.
        
        Arguments:
        :param: user: Username for database.
        :param: pw: Password for database.
        :param: schema_location: Schema location.
        
        returns: None.
        """
        # Read Schema File In
        sql = open(schema_location, 'r').read()

        # Create connection
        connection = ConnectPost.create_connection(user, pw)
        cursor = connection.cursor()
        
        # Execute Drop SQL
        cursor.execute(sql)
        connection.commit()
        
        # Close Connection
        if(connection):
            cursor.close()
            connection.close()
            print("PostgreSQL connection is closed")
            
        del user, pw
            
        return "Tables Created."

# ---------------------------------------------------------------
# Create Object for insert
class PostInsert(object):
    """
    Object to insert data into Postgres Tables.
    """
    @staticmethod
    def clean_data(data:dict) -> list:
        """
        | Function to help clean up data through the ETL pipeline.
        
        Converts a Pandas DataFrame into a list of tuples.
        
        returns: A list.
        """
        
        # Convert NANs to None
        data = data.where(pd.notnull(data),None)
        
        # Convert data into list of tuples for data insert
        return list(data.itertuples(name=None, index=False))
    
    def insert_data(parameters:None):
        """
        | Function to insert data into Postgres.
        
        Arguments:
        :param 0: data: Data to be inserted into tables.
        :param 1: insert_sql: Insert statement for tables.
        :param 2: start_position: Starting position for DataFrame.
        :param 3: batch_size: Integer value to increment data loads.
        :param 4: user: Username.
        :param 5: pw: Password to database.
        """
        # Increment data
        data = parameters[0][parameters[2]:parameters[2]+parameters[3]]
        
        # Create connection
        connection = ConnectPost.create_connection(parameters[4], parameters[5])
        cursor = connection.cursor()
        
        # Clean up data
        data_list = PostInsert.clean_data(data)
        
        # Execute Insert SQL
        cursor.executemany(parameters[1], data_list)
        connection.commit()
        
        # Close Connection
        if(connection):
            cursor.close()
            connection.close()
            print("PostgreSQL connection is closed")
            
        return "Insert complete."

    # ----------- Start of Fast-Map ----------------------------
    def fast_insert_data(data, insert_sql, batch_size, user, pw):
        """
        | Function to fast-map insert data into Postgres.
        
        Arguments:
        :param: data: Data to be inserted into tables.
        :param: insert_sql: Insert statement for tables.
        :param: batch_size: Integer value to increment data loads.
        :param: user: Username.
        :param: pw: Password to database.
        """
        # Get lenght of data to create batching parameters
        data_length = len(data)
        
        print(f"Length of Data: {data_length}")
        
        number_of_skips = range(0, data_length, batch_size)
        
        # Default to 25 threads to prevent any throttling
        [i for i in fast_map(PostInsert.insert_data, [(data, insert_sql, skip_n, batch_size, user, pw) 
                                                      for skip_n in number_of_skips], threads_limit=25)]