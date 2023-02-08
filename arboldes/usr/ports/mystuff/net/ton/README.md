Port for adJ/OpenBSD of the tools for the Blockchain TON - The Open Network (<https://github.com/ton-blockchain/ton>) 

# 1. INSTALL

It will be easier if you install a precompiled version:
* adJ 7.1 <http://adj.pasosdejesus.org/pub/AprendiendoDeJesus/7.1p1-amd64/paquetes/ton-20220802.tgz>
* adJ 7.2 <http://adj.pasosdejesus.org/pub/AprendiendoDeJesus/7.2-amd64/paquetes/ton-20230109.tgz>


# 2. BUILD

To compile the package from this port on an adJ/OpenBSD that already has `/usr/ports` infrastructure (see <https://www.openbsd.org/faq/ports/ports.html>), copy the content of this directory to `/usr/ports/mystuff/net/ton` and run from it
```
make
```
if you want to install the package you built:
```
make install
```

# 3. USAGE

After installing the package you will have:
* TVM Assembly language library located in `/usr/local/lib/fift`
* Multiple contracts in `/usr/local/share/ton/smartcont`
* `fift` to execute instructions on the TON virtual machine and debug and to create binaries for that virtual machine from sources in fift assembly language.
* `func` to compile to fift assembly language from sources in higher level language FunC.
* `lite-client` to connect to a TON network and interact with validators.
* `tonlib-cli` Use of the tonlib library from the terminal, which allows operations with wallet(s).
* `validator-engine` and `validator-engine-console` to operate a validator node

# 4. FUNCTIONALITY

If you want to develop a smartcontract we suggest you to use the package `ton-toncli` that is like this one but based on a modified TVM with more debuggin instructions and usable with toncli. See <https://github.com/pasosdeJesus/adJ/edit/main/arboldes/usr/ports/mystuff/net/ton-toncli/README.md>

## 4.1 `lite-client`
To try lite-client in mainnet run:

```
curl -o global.config.json https://ton-blockchain.github.io/global.config.json
lite-client -C global.config.json
```

once it works you can check most recent block with:

```
last
```
See more commands with `help` and exit with `quit`.

# 4.2 `func`

Try it to compile the smart contract of a standard wallet with

```
func -o w3.fif -SPA /usr/local/share/ton/smartcont/stdlib.fc /usr/local/share/ton/smartcont/wallet3-code.fc
```
This will generate the file `w3.fif` in fift assembler.

# 4.3 `fift`

Before running fift be sure to run:
```
export FIFTPATH=/usr/local/lib/fift/:/usr/local/share/ton/smartcont/
```
or better add that to your `~/.profile` or `~/.zshrc.local` or equivalent.

If you created `w3.fif` with `func` as described before, you can run:
```
fift -s w3.fif 
```
However to generate a boc file (binary representation of a cell) you should edit `w3.fif` and add at the end the line
```
boc>B "w3.cell" B>file
```

By running again
```
fift -s w3.fif 
```
It will generate the binary file `w3.cell` with the smart contract ready for the TVM.


# 4.4 `validator-node`

We are porting `mytonctrl` to adJ/OpenBSD and had succes with some nodes (see branch `adJ` of <https://github.com/vtamara/mytonctrl/tree/adJ>). 
In 2022 we had success testing mining (when it was available in the TON blockchain):

[![asciicast](https://asciinema.org/a/dh8yxO2NTqQGqnNOfhN4cVTKq.png)](https://asciinema.org/a/dh8yxO2NTqQGqnNOfhN4cVTKq)

# 5. DONATIONS

You can donate with TONCoin by sending to the address EQDKO7XwFbfRuAxX-5vs8oT_U7LG1hUyJLl-VnruqWRVdldW
