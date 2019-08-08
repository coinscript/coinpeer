# Coinpeer

**The project is in the early stages of development.**

A p2p peer connects to bitcoinSV node.

# how to use

```
$ iex -s mix
iex> Coinpeer.mount
```

## Join scaling test network.

```
iex> Coinpeer.mount(network: :stn)
```

# TODOs

- [x] send/receive p2p message
- [ ] message parsing
- [ ] get transactions