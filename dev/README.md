Learn You a _Haskell_ for Great Good!
=====================================

_by Miran Lipovača._

This is the makefile from [pvorb's copy](https://github.com/pvorb/learn-you-a-haskell) of “Learn You a Haskell for Great Good!”, the prettiest
book for learning Haskell that I know of. I obtained this copy by using
[Pandoc](http://johnmacfarlane.net/pandoc/).

You can read the book [online](http://learnyouahaskell.com/chapters) or [buy a copy](http://nostarch.com/lyah.htm).

What is this repo for?
----------------------

With the help of this repo, you can make your own ebook version of the book.
Make sure you have Pandoc installed and pdflatex (for making the pdf) and then 
use 'make all', 'make epubs' or 'make pdfs' depending on what you want.
The output will be written to a directory called 'out'

The Makefile
------------

Makefiles are an elegant way to organize complex build commands (for pdf, epub, etc) into one unified Makefile, which you can call with `make epub`.

I might try to integrate this in the BASC eBookGenerator.

License
-------

This book is licensed under an [Attribution-NonCommercial-ShareAlike 3.0
Unported (CC BY-NC-SA 3.0)](http://creativecommons.org/licenses/by-nc-sa/3.0/)
license.
