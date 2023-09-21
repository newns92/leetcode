/*
Amber's conglomerate corporation just acquired some new companies. Each of the companies follows this hierarchy:
    Founder --> Lead Manager --> Senior Manager --> Manager --> Employee

Given the table schemas below, write a query to print the company_code, founder name, total number of lead managers, 
    total number of senior managers, total number of managers, and total number of employees. 

Order your output by ascending company_code.

Note:
- The tables may contain duplicate records.
- The company_code is string, so the sorting should not be numeric. 
    - For example, if the company_codes are C_1, C_2, and C_10, then the ascending company_codes will be C_1, C_10, and C_2

The following tables contain company data:
- Company: The company_code is the code of the company and founder is the founder of the company.
- Lead_Manager: The lead_manager_code is the code of the lead manager, and the company_code is the code of the working company.
- Senior_Manager: The senior_manager_code is the code of the senior manager, the lead_manager_code is the code of its lead manager, 
    and the company_code is the code of the working company.
- Manager: The manager_code is the code of the manager, the senior_manager_code is the code of its senior manager, 
    the lead_manager_code is the code of its lead manager, and the company_code is the code of the working company.
- Employee: The employee_code is the code of the employee, the manager_code is the code of its manager, 
    the senior_manager_code is the code of its senior manager, the lead_manager_code is the code of its lead manager, 
    and the company_code is the code of the working company. 
*/


SELECT
    company.company_code,
    company.founder,
    COUNT(DISTINCT lead_manager.lead_manager_code),
    COUNT(DISTINCT senior_manager.senior_manager_code),
    COUNT(DISTINCT manager.manager_code),
    COUNT(DISTINCT employee.employee_code)
FROM company
LEFT JOIN lead_manager ON
    company.company_code = lead_manager.company_code
LEFT JOIN senior_manager ON
    company.company_code = senior_manager.company_code
LEFT JOIN manager ON
    company.company_code = manager.company_code
LEFT JOIN employee ON
    company.company_code = employee.company_code      
GROUP BY
    company.company_code,
    company.founder
ORDER BY company.company_code ASC
;