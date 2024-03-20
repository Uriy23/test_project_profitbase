--Определить сколько принес каждый отдел

{{
     config(
        alias = 'Zadanie_2',
        materialized='table'
    )
}}

select
    coalesce(manager_departments.department, 'Отдел не определен') AS department,
    sum(payments.value) as sum
from {{ source('raw_data','payments')}} as payments
left join {{ source('raw_data','manager_departments')}} as manager_departments
    on replace(payments.manager_email, '.', '') = replace(manager_departments.email, '.', '')
group by coalesce(manager_departments.department, 'Отдел не определен')
