/*
Created by:			Anthony Loya
Created on:			17 June 2022
Last updated by:	John Hopson
Last updated on:	26 July 2022

Description: These are the queries necessary to retrieve FXS data 
			 from Dune Analytics (https://dune.com/queries) to 
			 replicate the CSV files we used during our
			 investigation.
*/

--FXS contracts
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
WHERE	"address" = '\x3432B6A60D23Ca0dFCa7761B7ab56459D9C964D0'	--FXS
ORDER BY 5 DESC;

--FXS logs
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
WHERE	"contract_address" = '\x3432B6A60D23Ca0dFCa7761B7ab56459D9C964D0'	--FXS
		AND block_time >= '2020-12-01'
		AND block_time < '2022-07-01'
ORDER BY 3 DESC;

--FXS traces
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
WHERE	"address" = '\x3432B6A60D23Ca0dFCa7761B7ab56459D9C964D0'	--FXS
		AND block_time >= '2020-12-01'
		AND block_time < '2022-07-01'
ORDER BY 4 DESC;

--FXS transactions
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
WHERE	"to" = '\x3432B6A60D23Ca0dFCa7761B7ab56459D9C964D0'		--FXS
		AND block_time >= '2020-12-01'
		AND block_time < '2022-07-01'
ORDER BY 4 DESC;

--FXS prices
SELECT	minute AS "date_time"
		,price
		,contract_address
		,symbol
FROM	prices.usd
WHERE	SYMBOL = 'FXS'
		AND minute >= '2020-12-01'
		AND minute < '2022-07-01'
ORDER BY 1 DESC;
