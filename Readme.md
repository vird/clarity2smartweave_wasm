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
    
    # we need clang-8 and git
    
    # For ubuntu 20.04
    apt-get update
    apt-get install clang-8 lld-8 git
    # fix missing wasm-ld binary
    ln -s /usr/bin/wasm-ld-8 /usr/bin/wasm-ld

## how to install

    git clone https://github.com/vird/clarity2smartweave_wasm
    cd clarity2smartweave_wasm
    npm i

## how to use

    ./cli.coffee test.clar
    # see ./build/compiled.js for results

## how to test proper execution

    # for some reason node@12 does't like `export async function handle`, so I use `this.handle = async function`
    # enable this behaviour with --fix-export
    ./cli.coffee test.clar --fix-export
    ./manual3.coffee
    # expected output
    # { state: {}, result: 1 }

# Development stuff

    # run tests
    npm test

# Checklist/roadmap
Note some points are duplicated. Reason: ast4gen has lot of stuff and it's a reasonable checklist for turing-complete stuff (clarity is not, but whatever) \
Also I plan make superset of clarity for 2 purposes:
  * put all smartweave stuff in non-standard endpoints (so you can write in clarity whatever you want for arweave, because patching generated C or WASM is much more painful)
  * turing-complete (why not?)

| Feature                                   | Implemented                    | Tested                         |
| -------------                             | -------------                  | -------------                  |
| **Clarity API**                           | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;**operations**                | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;+ - * /           | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;mod pow           | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;to-int to-uint    | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;< > <= >=         | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;and or xor not    | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;is-eq             | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
|                                           |                                |                                |
| &nbsp;&nbsp;**define**                    | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;define-constant   | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;define-private    | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;define-public     | <ul><li>- [x] for function &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;define-read-only  | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;define-data-var   | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;define-fungible-token     | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;define-non-fungible-token | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
|                                           |                                |                                |
| &nbsp;&nbsp;**stmt/control flow**         | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;let               | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;begin             | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;if                | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;match             | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;asserts!          | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
|                                           |                                |                                |
| &nbsp;&nbsp;**type-related**              | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;ok                | <ul><li>- [x] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;try!              | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;default-to        | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> | 
| &nbsp;&nbsp;&nbsp;&nbsp;is-ok is-none is-err is-some  | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;true/false        | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;none              | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;response          | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;err               | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
|                                           |                                |                                |
| &nbsp;&nbsp;**list/buffer**               | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;len               | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;as-max-len?       | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;concat            | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;map               | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;fold              | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;filter            | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;append            | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
|                                           |                                |                                |
| &nbsp;&nbsp;**map**                       | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;define-map        | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;map-get           | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;map-set!          | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;map-insert!       | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;map-delete!       | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
|                                           |                                |                                |
| &nbsp;&nbsp;**trait**                     | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;define-trait      | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;use-trait         | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;impl-trait        | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
|                                           |                                |                                |
| &nbsp;&nbsp;**unwrap**                    | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;unwrap            | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;unwrap-err        | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;unwrap-panic      | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;unwrap-err-panic  | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
|                                           |                                |                                |
| &nbsp;&nbsp;**crypto**                    | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;hash160           | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;sha256            | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;sha512            | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;sha256            | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;keccak256         | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
|                                           |                                |                                |
| &nbsp;&nbsp;**block/tx related**          | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;ft-get-balance    | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;nft-get-owner?    | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;ft-transfer?      | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;nft-transfer?     | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;nft-mint?         | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;ft-mint?          | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;stx-get-balance   | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;stx-transfer?     | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;stx-burn?         | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;at-block          | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;get-block-info?   | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
|                                           |                                |                                |
| &nbsp;&nbsp;**IO state**                  | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;var-get           | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;var-set           | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
|                                           |                                |                                |
| &nbsp;&nbsp;**IO contract**               | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;contract-call?    | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;tx-sender         | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;contract-caller   | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;block-height      | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;as-contract       | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;contract-of       | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
|                                           |                                |                                |
| &nbsp;&nbsp;**IO misc**                   | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;print             | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
|                                           |                                |                                |
| &nbsp;&nbsp;**unknown**                   | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;transfer-to-recipient!  | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;transfer-from?          | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;append-item             | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
|                                           |                                |                                |
| **SmartWeave API sync**                   | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;SmartWeave.transaction        | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;SmartWeave.block              | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
|                                           |                                |                                |
| **SmartWeave API async?**                 | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;SmartWeave.arweave.crypto     | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;SmartWeave.arweave.utils      | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;SmartWeave.arweave.ar         | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;SmartWeave.arweave.wallets    | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;SmartWeave.contracts          | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |

ast4gen perspective checklist

| Feature                                   | Implemented                    | Tested                         |
| -------------                             | -------------                  | -------------                  |
|                                           |                                |                                |
| **expr AST**                              | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;ast.Un_op                     | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;ast.Bin_op                    | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;+ - * /           | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;mod pow           | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;< > <= >=         | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;and or xor not    | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;&nbsp;&nbsp;== !=             | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;ast.Const                     | <ul><li>- [ ] partial&nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;ast.Var                       | <ul><li>- [ ] only for args&nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
|                                           |                                |                                |
| **stmt AST**                              | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;ast.Fn_decl                   | <ul><li>- [x] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;ast.Ret                       | <ul><li>- [x] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;ast.Fn_call                   | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;ast.Var_decl (global, define-read-only)   | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;ast.Var_decl (local, let)     | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
|                                           |                                |                                |
| **stmt AST control flow**                 | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;ast.If                        | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
|                                           |                                |                                |
| **Types**                                 | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;bool                          | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;string (arg+ret)              | <ul><li>- [ ] ret only&nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;principal                     | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;list                          | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;tuple                         | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;int as i64                    | <ul><li>- [x] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;uint as u64                   | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;int/uint as i128/u128         | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;buffer                        | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;optional                      | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
| &nbsp;&nbsp;response ok-type err-type     | <ul><li>- [ ] &nbsp;</li></ul> | <ul><li>- [ ] &nbsp;</li></ul> |
|                                           |                                |                                |
