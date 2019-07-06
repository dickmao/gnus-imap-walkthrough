> Its [sic] 2019, the only thing you should be using is notmuch.
>
> &mdash; <cite>Uncited redditor</cite>
# gnus-imap-walkthrough
Provably set up Gnus for IMAP accounts from scratch.

The monolithicity of Gnus's unified messaging concept is a double-edged sword.  Configuration is vastly more difficult relative to small command-line clients such as mu4e and notmuch, but I can track all my Usenet, [Reddit](https://github.com/dickmao/nnreddit), and mailing list activity from a single dashboard.  Power users such as the [maintainer of emacs](https://www.reddit.com/r/emacs/comments/54ox9p/how_do_work_with_mailing_lists/d84rz9e?utm_source=share&utm_medium=web2x) also swear by emacs's built-in mail module.

If your occupation does not currently involve an elisp hacking component, Gnus is not for you.  Eventually something will break, and you may need to set a breakpoint to figure out what changed.

The setup demonstrated here is modelled after [gongzhitaao/GnusSolution](https://github.com/gongzhitaao/GnusSolution).  It is neither secure (!) nor feature complete, but should serve as a solid baseline.  I've also copied some configuration from <https://wiki.archlinux.org/index.php/Isync> and <https://github.com/jwiegley/dot-emacs>.

This repo aims to do one better by actually executing the steps on a CircleCI Ubuntu image.

Begin by turning on "Less secure app access" from Gmail's settings (or by disabling whatever  upstream setting that might block imap logins).  Then clone this repo, and study [build.sh](https://github.com/dickmao/gnus-imap-walkthrough/blob/master/build.sh) to piece it all together.

