--На основе таблицы с поступлениями, необходимо найти платежи с максимальными суммами
-- всех клиентов которые заплатили в январе 2023 года.
--Результат должен быть представлен в виде таблицы со следующими полями:
---	Название клиента
---	Дата когда пришел максимальный платеж
---	Сумма максимального поступления
{{
     config(
        alias = 'Zadanie_1',
        materialized='table'
    )
}}
select
    one_date.client_name,
    group_data.payment_date,
    max(group_data.value) as value
from {{ source('raw_data','payments')}} as group_data
join {{ source('raw_data','payments')}} as one_date
	on group_data.client_id = one_date.client_id
where group_data.payment_date
    between '2023-01-01' AND '2023-01-31'
group by one_date.client_name, group_data.payment_date