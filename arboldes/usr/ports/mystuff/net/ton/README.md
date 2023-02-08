Port of TON tools (<https://github.com/ton-blockchain/ton>) to adJ/OpenBSD.

# INSTALL

It will be easier if you install a precompiled version:
* adJ 7.1 <http://adj.pasosdejesus.org/pub/AprendiendoDeJesus/7.1p1-amd64/paquetes/ton-20220802.tgz>
* adJ 7.2 <http://adj.pasosdejesus.org/pub/AprendiendoDeJesus/7.2-amd64/paquetes/ton-20230109.tgz>


# BUILD

To compile the package from this port on an adJ/OpenBSD that already has `/usr/ports` infrastructure (see <https://www.openbsd.org/faq/ports/ports.html>), copy the content of this directory to `/usr/ports/mystuff/net/ton` and run from it
```
make
```

# USAGE

After installing the package you will have:
* TVM Assembly language library located in `/usr/local/lib/fift`
* Multiple contracts in `/usr/local/share/ton/smartcont`
* `fift` to execute instructions on the TON virtual machine and debug and to create binaries for that virtual machine from sources in fift assembly language.
* `func` to compile to fift assembly language from sources in higher level language FunC.
* `lite-client` to connect to a TON network and interact with validators.
* `tonlib-cli` Use of the tonlib library from the terminal, which allows operations with wallet(s).
* `validator-engine` and `validator-engine-console` to operate a validator node

# FUNCTIONALITY

If you want to develop a smartcontract we suggest you to use the package `ton-toncli` that is like this one but based on a modified TVM with more debuggin instructions and usable with toncli. See <https://github.com/pasosdeJesus/adJ/edit/main/arboldes/usr/ports/mystuff/net/ton-toncli/README.md>

Besides to normal functionality of fift and func as compilers, with this port we have tested succesfully:
* `lite-client` to query testnet and mainnet.  We even could test mining when it was available in 2022.
* We have run testing nodes with the ongoing port of `mytonctrl` to adJ/OpenBSD (see branch `adJ` of <https://github.com/vtamara/mytonctrl/tree/adJ>)

# DONATIONS

You can donate with TONCoin by sending to the address EQDKO7XwFbfRuAxX-5vs8oT_U7LG1hUyJLl-VnruqWRVdldW
