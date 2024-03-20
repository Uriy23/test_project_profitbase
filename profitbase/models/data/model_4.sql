--Необходимо сформировать таблицу в которой будет отражено сколько поступило денег в каждом месяце
--и как росла общая выручка с учетом предыдущих месяцев.

{{
     config(
        alias = 'zadanie_4',
        materialized='table'
    )
}}

with monthly_revenue as (
    select
        date_trunc('month', payment_date) as period,
        sum(value) as revenue_by_month
    from {{ source('raw_data','payments')}}
    group by date_trunc('month', payment_date)
    order by period
),
cumulative_revenue as (
    select
        period,
        revenue_by_month,
        sum(revenue_by_month) over (order by period) as revenue_cumulative
    from monthly_revenue
)
select
  case
    when month(period) = 1 then concat('январь ', toString(year(period)))
    when month(period) = 2 then concat('февраль ', toString(year(period)))
    when month(period) = 3 then concat('март ', toString(year(period)))
    when month(period) = 4 then concat('апрель ', toString(year(period)))
    when month(period) = 5 then concat('май ', toString(year(period)))
    when month(period) = 6 then concat('июнь ', toString(year(period)))
    when month(period) = 7 then concat('июль ', toString(year(period)))
    when month(period) = 8 then concat('август ', toString(year(period)))
    when month(period) = 9 then concat('сентябрь ', toString(year(period)))
    when month(period) = 10 then concat('октябрь ', toString(year(period)))
    when month(period) = 11 then concat('ноябрь ', toString(year(period)))
    when month(period) = 12 then concat('декабрь ', toString(year(period)))
  end as period,
  revenue_by_month,
  revenue_cumulative
from cumulative_revenue