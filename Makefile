.PHONY: deploy-factory-local deploy-factory-dry deploy-factory-cantotest build test
.DEFAULT_GOAL := none

none:
	$(error Please specify a target)

deploy-factory-dry:
	forge script script/DAOFactory.s.sol:DAOFactoryScript

deploy-factory-local:
	export PRIVATE_KEY=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
	forge script script/DAOFactory.s.sol:DAOFactoryScript -f http://0.0.0.0:8545 --chain-id 31337 --broadcast

deploy-factory-cantotest:
	forge script script/DAOFactory.s.sol:DAOFactoryScript -f https://eth.plexnode.wtf/ --chain-id 740 --broadcast

build:
	forge build

test:
	forge test