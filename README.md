# oldies.nvim

Navigate your `oldfiles` without losing your mind.

## Motivation

At times, it's useful to navigate backwards through your file history, but
`oldfiles` is a bit difficult to use, especially because navigating between
files continuously adds items back to the top of `oldfiles`. This plugin allows
you to easily navigate backwards and forwards through the list of `oldfiles`.

## Installation

Install with your favorite package manager (e.g.
[lazy.nvim](https://github.com/folke/lazy.nvim)).

```lua
{
  "mskelton/oldies.nvim",
}
```

## Usage

```lua
require('oldies').prev()
require('oldies').next()
```
