
with base as (

    select * 
    from {{ ref('stg_intercom__contact_tag_history_tmp') }}

),

fields as (

    select
    /*
    The below macro is used to generate the correct SQL for package staging models. It takes a list of columns 
    that are expected/needed (staging_columns from dbt_salesforce_source/models/tmp/) and compares it with columns 
    in the source (source_columns from dbt_salesforce_source/macros/).
    For more information refer to our dbt_fivetran_utils documentation (https://github.com/fivetran/dbt_fivetran_utils.git).
    */
    
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_intercom__contact_tag_history_tmp')),
                staging_columns=get_contact_tag_history_columns()
            )
        }}
        
    from base
),

final as (
    
    select 
        contact_id,
        contact_updated_at,
        tag_id
        
    from fields
)

select * 
from final