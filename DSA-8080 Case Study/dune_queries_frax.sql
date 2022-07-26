/*
Created by:			John Hopson
Created on:			20 June 2022
Last updated on:	26 July 2022

Description: These are the queries necessary to retrieve FRAX data 
			 from Dune Analytics (https://dune.com/queries) to 
			 replicate the CSV files we used during our
			 investigation.
*/

--FRAX contracts ✓
SELECT	abi
		,address
		,base
		,code
		,created_at
		,dynamic
		,factory
		,id
		,name
		,namespace
		,updated_at
FROM	ethereum.contracts
WHERE	"address" = '\x853d955aCEf822Db058eb8505911ED77F175b99e'	--FRAX
ORDER BY 5 DESC;

--FRAX logs ✓
SELECT	block_hash
		,block_number
		,block_time
		,contract_address
		,data
		,index
		,"topic1"
		,"topic2"
		,"topic3"
		,"topic4"
		,tx_hash
		,tx_index
FROM	ethereum.logs
WHERE	"contract_address" = '\x853d955aCEf822Db058eb8505911ED77F175b99e'	--FRAX
		AND block_time >= '2020-12-01'
		AND block_time < '2022-07-01'
ORDER BY 3 DESC;

--FRAX traces ???
SELECT	address
		,block_hash
		,block_number
		,block_time
		,call_type
		,code
		,error
		,"from"
		,gas
		,gas_used
		,input
		,output
		,refund_address
		,sub_traces
		,success
		,"to"
		,trace_address
		,tx_hash
		,tx_index
		,tx_success
		,type
		,value
FROM	ethereum.traces
WHERE	"address" = '\x853d955aCEf822Db058eb8505911ED77F175b99e'	--FRAX
		AND block_time >= '2020-12-01'
		AND block_time < '2022-07-01'
ORDER BY 4 DESC;

--FRAX transactions ✓
SELECT	access_list
		,block_hash
		,block_number
		,block_time
		,data
		,"from"
		,gas_limit
		,gas_price
		,gas_used
		,hash
		,index
		,max_fee_per_gas
		,max_priority_fee_per_gas
		,nonce
		,priority_fee_per_gas
		,success
		,"to"
		,type
		,value
FROM	ethereum.transactions
WHERE	"to" = '\x853d955aCEf822Db058eb8505911ED77F175b99e'		--FRAX
		AND block_time >= '2020-12-01'
		AND block_time < '2022-07-01'
ORDER BY 4 DESC;

--FRAX prices ✓
SELECT	minute AS "date_time"
		,price
		,contract_address
		,symbol
FROM	prices.usd
WHERE	SYMBOL = 'FRAX'
		AND minute >= '2020-12-01'
		AND minute < '2022-07-01'
ORDER BY 1 DESC;
