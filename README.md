# build flutter site:
flutter build web

# move files to ic
sh web_flutter_2_ic.sh

# Deploy to IC
dfx deploy --network ic

# site:
https://gmjta-dqaaa-aaaai-qbfla-cai.ic0.app/#/

# Deploy contracts
truffle deploy --network bsc