--Необходимо дополнить таблицу с поступлениями полем “состояние клиента”.
--Если платеж для клиента является первым, то состояние клиента должно быть “Новый”.
--Для всех остальных платежей данного клиента, состояние должно быть “Действующий”.

{{
     config(
        alias = 'payments',
        materialized='table'
    )
}}

with ranked_payments as (
    select id, client_id, payment_date,
           row_number() over (partition by client_id order by payment_date) as number_pay
    from {{ source('raw_data','payments')}}
)
select payments.*,
       case
           when ranked_payments.number_pay = 1 then 'Новый'
           else 'Действующий'
       end as client_status
from payments
join ranked_payments
    on payments.id = ranked_payments.id
