[![CircleCI](https://circleci.com/gh/dickmao/gnus-imap-walkthrough/tree/master.svg?style=svg)](https://circleci.com/gh/dickmao/gnus-imap-walkthrough/tree/master)

.. image:: screenshot.png

# See Your Gmail in a Docker Container
Begin by turning on "Less secure app access" from Gmail's settings.

Clone this repo, and `make run`.  To avoid a potential "mail-strom", the container configuration limits the initial download to 1000 messages and filters out attachments exceeding 100kB.

# Now Do It Without Docker
If you got the above working, chances are you're either underwhelmed by or perversely drawn to Gnus's spartan and counterintuitive interface.

Perhaps like many emacs users you're an obsessive tinkerer and minimalist who's [read this](https://www.reddit.com/r/emacs/comments/54ox9p/how_do_work_with_mailing_lists/d84rz9e?utm_source=share&utm_medium=web2x) and prefers built-in modules and driving stick.

If so, make a quick study of [build.sh](https://github.com/dickmao/gnus-imap-walkthrough/blob/master/build.sh).  The prescribed setup is neither secure (!) nor feature complete, but should serve as a solid baseline.  I can offer some guarantees against bitrot as I periodically [run the build](https://circleci.com/gh/dickmao/gnus-imap-walkthrough) on a CircleCI Ubuntu image.

# Why I Use Gnus
> Its [sic] 2019, the only thing you should be using is notmuch.
>
> &mdash; <cite>Uncited redditor</cite>

Can you track all your Usenet, [Reddit](https://github.com/dickmao/nnreddit), RSS, and mailing list activity from a single dashboard?  If so, please let me know in an [Issue](https://github.com/dickmao/gnus-imap-walkthrough/issues)!  I also tire of Gnus's peculiarities although at this point I may be too far invested.
