# clarity2smartweave_wasm
clarity to SmartWeave translator \
VERY EXPERIMENTAL. Can compile only hello world for now. WIP

## recommended software requirements

    # install nvm https://github.com/nvm-sh/nvm 
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
    source ~/.bashrc
    # node install
    nvm i 12
    npm i -g iced-coffee-script
    # we need clang-8
    apt-get install clang-8 lld-8

## how to use

    ./cli.coffee test.clar
    # see ./build/compiled.js for results
