/*
Created by:			Anthony Loya
Created on:			17 June 2022
Last updated by:	John Hopson
Last updated on:	26 July 2022

Description: These are the queries necessary to retrieve FRAX data 
			 from Dune Analytics (https://dune.com/queries) to 
			 replicate the CSV files we used during our
			 investigation.
*/

--FRAX contracts
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

--FRAX logs
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
		AND block_time < '2022-06-01'
ORDER BY 3 DESC;

--FRAX transactions
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
		AND block_time < '2022-06-01'
ORDER BY 4 DESC;
