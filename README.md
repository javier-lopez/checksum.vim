[Checksum.vim](https://github.com/chilicuil/checksum.vim) is a global plugin to [cryptographically hash](https://en.wikipedia.org/wiki/Cryptographic_hash_function) files or strings.

Preview
-------

<p align="center">
  <img src="http://javier.io/assets/img/vim-checksum.gif"/><br>
</p>

Requirements
------------

* Vim 7.0+
* md5sum or openssl

Installation
------------

- [Vundle](https://github.com/chilicuil/vundle) way (recommended), add the following to your `$HOME/.vimrc` file:

        Bundle 'chilicuil/checksum.vim'

    And run inside of vim:

        :BundleInstall

- [NeoBundle](https://github.com/Shougo/neobundle.vim) way:

        NeoBundle 'chilicuil/checksum.vim'

    And run inside of vim:

        :NeoBundleInstall

- [Pathogen](https://github.com/tpope/vim-pathogen) way:

        $ git clone https://github.com/chilicuil/checksum.vim.git ~/.vim/bundle/checksum.vim

- **Manual** (simplest if you've never heard of vim plugin managers), download the zip file generated from github and extract it to `$HOME/.vim`

        $ mv checksum.vim*.zip $HOME/.vim
        $ cd $HOME/.vim && unzip checksum.vim*.zip

    Update the help tags from vim:

        :helpt ~/.vim/doc/

Usage
-----

:Checksum (or <kbd>\<Leader\>c</kbd>) to calculate the checksum of the current file, you may use it in visual mode to checksum only the selection.

By default checksum.vim uses <kbd>md5sum</kbd> to calculate a md5 checksum, however it can customized to use any hash algorithm

    let g:checksum_cmd = 'sha1sum'
    let g:checksum_cmd = 'openssl sha512 | awk "{print \$NF}"

See <kbd>:h checksum.txt</kbd> for more help.
