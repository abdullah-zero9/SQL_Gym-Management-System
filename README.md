# SQL Gym Management System Database

This repository contains the SQL database script for a Gym Management System. The database script is designed to support the functionality of a gym management software. It includes both Data Definition Language (DDL) and Data Manipulation Language (DML) statements to create and manage the database.

## Overview

The Gym Management System database is built to efficiently manage gym-related information. It provides a structured framework for tracking members, trainers, workouts, equipment, payments, and more. The database is designed using normalized tables to ensure data integrity and optimal performance.

## Database Structure

The database consists of several key tables, each serving a specific purpose:

- **Members**: Stores information about gym members, including member ID, name, contact details, and membership status.
- **Trainers**: Contains details about trainers, such as trainer ID, name, specialization, and contact information.
- **Workouts**: Records data on different workouts available at the gym, including workout ID, type, duration, and difficulty level.
- **Membership Plans**: Contains details about various membership plans, including plan ID, name, description, and pricing.
- **Attendance**: Logs member attendance for specific workouts on particular dates.
- **Payments**: Records payment transactions, including member ID, payment date, amount, and payment method.

## SQL Scripts

The SQL script provided in this repository includes various parts:

- **Part01: Create A Database**: Checks for the existence of the database and creates it with specified attributes.

- **Part02: Create Tables with Column Definitions**: Defines tables with appropriate columns, primary keys, foreign keys, and constraints. Tables include those for members, trainers, equipment suppliers, gym owners, and more.

- **Part03: Alter, Drop, and Modify Tables & Columns**: Contains statements for altering and modifying table structures, adding columns with default constraints, and dropping columns.

- **Part04: Create Clustered & NonClustered Indexes**: Demonstrates the creation of clustered and non-clustered indexes to optimize data retrieval.

- **Part05: Create Sequence & Alter Sequence**: Defines a sequence for generating unique numbers and demonstrates how to alter sequence properties.

- **Part06: Create A View & Alter View**: Defines views for querying data from multiple tables and provides examples of altering views.

- **Part07: Create Stored Procedure & Alter Stored Procedure**: Defines stored procedures for inserting, updating, and deleting data, along with examples of altering stored procedures.

- **Part08: Create Functions (Scalar, Simple Table Valued, Multi-statement Table Valued) & Alter Function**: Defines scalar and table-valued functions, along with examples of altering functions.

- **Part09: Create Triggers (For/After Trigger)**: Defines triggers for various purposes, such as updating data in related tables when payments are made or memberships are updated.

- **Part10: Create Trigger (Instead of Trigger)**: Demonstrates the creation of an "instead of" trigger on a view for custom data manipulation.


## Usage

To use this SQL script:

1. Execute the script in your preferred SQL Server management tool. Make sure you have appropriate permissions to create databases and objects.

2. Customize the script as needed to match your specific gym management system requirements.

3. Integrate the database with your Gym Management System software by updating the connection string to point to the newly created database.

## Contributing

Contributions and improvements to the database structure or scripts are welcome. Feel free to submit pull requests or open issues if you have suggestions or encounter any problems.

## License

This project is provided under the MIT License. You are free to use, modify, and distribute the SQL database script as per the terms of the license. Please refer to the [LICENSE](LICENSE) file for details.
