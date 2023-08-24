'''
Write a solution to find the employees who earn more than their managers.

Return the result table in any order.

Employee
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
| salary      | int     |
| managerId   | int     |
+-------------+---------+
'''

# ATTEMPT 1
import pandas as pd

def find_employees(employee: pd.DataFrame) -> pd.DataFrame:
    # Given a DataFrame, return a DataFrame
    
    # managers = []
    # managers = employee['managerId'].dropna()
    # # print(managers)

    # https://sparkbyexamples.com/pandas/pandas-use-a-list-of-values-to-select-rows-from-dataframe/
    # print(employee[employee['id'].isin(managers)])

    # JOIN to create a 'managerSalary' column (Default name will be 'salary_y')
    # https://sparkbyexamples.com/pandas/pandas-left-join-explained-by-examples/
    # print(pd.merge(employee, employee, left_on='managerId', right_on='id', how='left'))
    result = pd.merge(employee, employee, left_on='managerId', right_on='id', how='left')
    
    # Filter on just those salaries greater than their manager's
    # print(result[result['salary_x'] > result['salary_y']])
    result = result[result['salary_x'] > result['salary_y']]
    
    # Rename the column
    # https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.rename.html
    result.rename(columns={'name_x': 'Employee'}, inplace=True)
    
    # Drop all columns except final one and return final DataFrame
    # https://stackoverflow.com/questions/45846189/how-to-delete-all-columns-in-dataframe-except-certain-ones
    # print(result.columns.difference(['Employee']))  # returns all columns NOT matching the arg(s) in .difference()
    result.drop(result.columns.difference(['Employee']), axis=1, inplace=True)
    
    return result


# ATTEMPT 2 (A bit slower?)
import pandas as pd

def find_employees(employee: pd.DataFrame) -> pd.DataFrame:
    # Given a DataFrame, return a DataFrame

    # JOIN to create a 'managerSalary' column (Default name will be 'salary_y')
    # https://sparkbyexamples.com/pandas/pandas-left-join-explained-by-examples/
    result = pd.merge(employee, employee, left_on='managerId', right_on='id', how='left')
    
    # Filter on just those salaries greater than their manager's and return just the name column
    result = pd.DataFrame(result[result['salary_x'] > result['salary_y']]['name_x'])
    
    # Rename the column and return
    # https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.rename.html
    return result.rename(columns={'name_x': 'Employee'})


# ATTEMPT 3 (less lines, return DataFrame from a DataFrame filter, not as a series)
import pandas as pd

def find_employees(employee: pd.DataFrame) -> pd.DataFrame:
    # Given a DataFrame, return a DataFrame

    # JOIN to create a 'managerSalary' column (Default name will be 'salary_y')
    # https://sparkbyexamples.com/pandas/pandas-left-join-explained-by-examples/
    result = pd.merge(employee, employee, left_on='managerId', right_on='id', how='left')
    
    # Filter on just those salaries greater than their manager's and return just the name column
    result = result[result['salary_x'] > result['salary_y']]

    # Return just the name column as a DataFrame, rename it, and return
    # https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.rename.html
    # https://stackoverflow.com/questions/16782323/keep-selected-column-as-dataframe-instead-of-series
    return result.loc[:, ['name_x']].rename(columns={'name_x': 'Employee'})
