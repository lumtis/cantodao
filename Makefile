.DEFAULT_GOAL := none

.PHONY: none
none:
	$(error Please specify a target)

# For local scripts, use:
# export PRIVATE_KEY=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

.PHONY: deploy-factory-dry
deploy-factory-dry:
	forge script script/DAOFactory.s.sol:DAOFactoryScript

.PHONY: deploy-factory-local
deploy-factory-local:
	forge script script/DAOFactory.s.sol:DAOFactoryScript -f http://0.0.0.0:8545 --chain-id 1337 --broadcast

.PHONY: deploy-factory-cantotest
deploy-factory-cantotest:
	forge script script/DAOFactory.s.sol:DAOFactoryScript --rpc-url https://canto-testnet.plexnode.wtf --chain-id 740 --broadcast

.PHONY: deploy-dao-local
deploy-dao-local:
	forge script script/DeployDao.s.sol:DeployDao -f http://0.0.0.0:8545 --chain-id 1337 --broadcast

.PHONY: deploy-note-local
deploy-note-local:
	forge script script/DeployNote.s.sol:DeployNote -f http://0.0.0.0:8545 --chain-id 1337 --broadcast

.PHONY: deploy-note-cantotest
deploy-note-cantotest:
	forge script script/DeployNote.s.sol:DeployNote -f https://eth.plexnode.wtf/ --chain-id 740 --broadcast

.PHONY: transfer-tokens-local
transfer-tokens-local:
	forge script script/local/TransferTokens.s.sol:TransferTokens -f http://0.0.0.0:8545 --chain-id 1337 --broadcast


.PHONY: network
network:
	anvil --chain-id 1337

.PHONY: mine
mine:
	number=1 ; while [[ $$number -le 500 ]] ; do \
        cast rpc evm_mine ; \
        ((number = number + 1)) ; \
    done

.PHONY: build
build:
	forge build

.PHONY: test
test:
	forge test

.PHONY: clean
clean:
	rm -rf out

.PHONY: types
types:
	npx typechain --target ethers-v5 \
	out/DAOFactory.sol/DAOFactory.json \
	out/DAOGovernor.sol/DAOGovernor.json \
	out/DAOToken.sol/DAOToken.json \
	out/DAOProposer.sol/DAOProposer.json \
	out/Turnstile.sol/Turnstile.json
