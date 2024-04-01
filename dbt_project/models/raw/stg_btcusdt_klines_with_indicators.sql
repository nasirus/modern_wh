{{ config(materialized='view') }}

with

source as (
    select
       [time]
      ,[low]
      ,[high]
      ,[Open]
      ,[Close]
      ,[volume]
    from {{ source('raw', 'btcusdt_klines_with_indicators') }}
    )
select * from source
