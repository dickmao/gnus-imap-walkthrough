# See Your Gmail in a Docker Container
Begin by turning on "Less secure app access" from Gmail's settings.

Clone this repo, and `make run`.  To avoid a potential "mail-strom", the container configuration limits the number of messages to 1000 and filters out attachments exceeding 100kB.

# Avoid Docker
When you are ready to cut over to a proper Gnus setup, study [build.sh](https://github.com/dickmao/gnus-imap-walkthrough/blob/master/build.sh).  It is neither secure (!) nor feature complete, but should serve as a solid baseline.  I can offer some guarantees against bitrot as I actually [execute the steps](https://circleci.com/gh/dickmao/gnus-imap-walkthrough) on a CircleCI Ubuntu image.

# Why I use Gnus
> Its [sic] 2019, the only thing you should be using is notmuch.
>
> &mdash; <cite>Uncited redditor</cite>

The monolithicity of Gnus's unified messaging concept is a double-edged sword.  Configuration is vastly more difficult relative to small command-line clients such as mu4e and notmuch, but I can track all my Usenet, [Reddit](https://github.com/dickmao/nnreddit), and mailing list activity from a single dashboard.  Power users such as the [maintainer of emacs](https://www.reddit.com/r/emacs/comments/54ox9p/how_do_work_with_mailing_lists/d84rz9e?utm_source=share&utm_medium=web2x) also swear by emacs's built-in mail module.

If your occupation does not currently involve an elisp hacking component, Gnus is not for you.  Eventually something will break, and you may need to set a breakpoint to figure out what changed.
