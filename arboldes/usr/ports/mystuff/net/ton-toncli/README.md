Port of TON tools to be used with toncli (<[https://github.com/ton-blockchain/ton](https://github.com/SpyCheese/ton)>) to adJ/OpenBSD.

# 1. INSTALL

It is easier if you install a precompiled version:
* adJ 7.2 
  ```
   PKG_PATH=http://adj.pasosdejesus.org/pub/AprendiendoDeJesus/7.2-extra/ doas \
     pkg_add -r -D unsigned -D installed ton-toncli
  ```
  
# 2. COMPILE

To compile the package from this port on an adJ/OpenBSD that already has `/usr/ports` infrastructure (see <https://www.openbsd.org/faq/ports/ports.html>), copy the content of this directory to `/usr/ports/mystuff/net/ton-toncli` and run from it
```
make
```
to install the package you built:
```
make install
```

# 3. USAGE

We wrote an article on how to use this package and `toncli` to test a simple smart contract, it is available at
<https://medium.com/@vladimirtmara/developing-and-testing-a-simple-smart-contract-with-toncli-de96ad0a6f5c>.

# 4. FUNCTIONALITY

These tools are fully functional to test smart contracts in FunC with `toncli`, the author used them in the contests of FunC held during 2022 and he had good results.

# 5. DONATIONS

You can donate with TONCoin by sending to the address EQDKO7XwFbfRuAxX-5vs8oT_U7LG1hUyJLl-VnruqWRVdldW
