INSERT INTO public.frax_logs(
    log_id 
    ,block_time 
    ,contract_address 
    ,log_data 
    ,logs_index 
    ,topic1 
    ,topic2 
    ,topic3 
    ,topic4 
    ,tx_hash 
    ,tx_index 
)
VALUES(
    %s 
    ,%s 
    ,%s 
    ,%s 
    ,%s 
    ,%s 
    ,%s 
    ,%s 
    ,%s 
    ,%s 
    ,%s 
)