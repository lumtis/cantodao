.PHONY: deploy-factory-local deploy-factory-dry deploy-factory-cantotest deploy-dao-local deploy-note-local network build test types
.DEFAULT_GOAL := none

# For local scripts, use:
# export PRIVATE_KEY=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

none:
	$(error Please specify a target)

deploy-factory-dry:
	forge script script/DAOFactory.s.sol:DAOFactoryScript

deploy-factory-local:
	forge script script/DAOFactory.s.sol:DAOFactoryScript -f http://0.0.0.0:8545 --chain-id 1337 --broadcast

deploy-factory-cantotest:
	forge script script/DAOFactory.s.sol:DAOFactoryScript -f https://eth.plexnode.wtf/ --chain-id 740 --broadcast

deploy-dao-local:
	forge script script/DeployDao.s.sol:DeployDao -f http://0.0.0.0:8545 --chain-id 1337 --broadcast

deploy-note-local:
	forge script script/DeployNote.s.sol:DeployNote -f http://0.0.0.0:8545 --chain-id 1337 --broadcast

network:
	anvil --chain-id 1337

build:
	forge build

test:
	forge test

clean:
	rm -rf out

types:
	npx typechain --target ethers-v5 \
	out/DAOFactory.sol/DAOFactory.json \
	out/DAOGovernor.sol/DAOGovernor.json \
	out/DAOToken.sol/DAOToken.json \
	out/DAOProposer.sol/DAOProposer.json
