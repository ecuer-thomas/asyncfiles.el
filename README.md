# Asyncfiles.el


### Require

`async.el` is needed for background operations.
* https://github.com/jwiegley/emacs-async
* http://stable.melpa.org/#/async

### Features

The main goal is to avoid UI blocking when loading/saving files on slow filesystems.
Not really tested with _trampmode_, but at first sight, it seems to work.

`background-save-buffer` : save current buffer in a separate process


`background-load-file` : open a file un a new buffer, delaying IOs in a separate process.
When it's ready, switch current active buffer to this one.


### Bindings

Current bindings:

* `M-s M-f` : background-load-file
* `M-s M-s` : background-save-buffer

