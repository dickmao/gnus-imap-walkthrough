[![CircleCI](https://circleci.com/gh/dickmao/gnus-imap-walkthrough/tree/master.svg?style=svg)](https://circleci.com/gh/dickmao/gnus-imap-walkthrough/tree/master)

<a href="https://youtu.be/DMpZtC98F_M"><img src=thumbnail.png width="350" height="197" alt="Replacing Thunderbird With Gnus"/></a>

# See Your Gmail in a Docker Container
Begin by turning on "Less secure app access" from Gmail's settings.

Clone this repo, and `make run`.  To avoid a potential "mail-strom", the container configuration limits the initial download to 1000 messages and filters out attachments exceeding 100kB.

# Now Do It Without Docker
Make a quick study of [build.sh](https://github.com/dickmao/gnus-imap-walkthrough/blob/master/build.sh).  The prescribed setup is neither secure (!) nor feature complete, but should serve as a solid baseline.  I can offer some guarantees against bitrot as I periodically [run the build](https://circleci.com/gh/dickmao/gnus-imap-walkthrough) on a CircleCI Ubuntu image.

# Gnus, a Tough Sell
> Its [sic] 2019, the only thing you should be using is notmuch.
>
> &mdash; <cite>Uncited redditor</cite>

> I use Gnus, and am currently subscribed to 95 mailing lists. It really makes almost any number of lists manageable, because I can temporarily unsubscribe, set "levels" to view only certain lists at a time, organize them into "topics", apply automatic filtering and adaptive scoring to drop messages it knows I don't care about, etc., etc. It's a pretty huge investment, learning-wise, but it's the most capable tool for the job that I know of.
>
> &mdash; <cite>John Wiegley, Emacs Maintainer</cite>

### Marketing Does Matter
Marketing matters, even in the decidedly unglamorous context of
last-century text editors.  When I first heard about "Doom Emacs" I admit I was intrigued.  Turns out the Doom project has nothing to do with the cataclysmic end of days or the pioneering FPS of the 90s (this despite Doom's shameless ripping off of the game's splash graphic).  Similarly, Spacemacs's "intergalactic" theming and its accessorizing with a fancy website, logo, and "cool merch" have done wonders for its brand.

Can such proverbial lipstick be applied to the porcine Gnus?  Prettification runs a tad counter to Gnus's spartan, no-nonsense ethos (this despite a frivolous, mealy-mouthed user manual).  It'd take a lot of work, the cosmetic nature of which is best done by millennials.  And putting my finger to the wind, no one under 35 has heard of, much less cares about, Gnus.

Marketing aside, the 800-pound gorilla menacing potential users though isn't a homely appearance but soul-withering useability.  No one wants to debug their email, and assimilating Gnus without firing up edebug at least once is like learning a manual gearbox without stalling.  If you can manage either, you should fill your bathtub and gingerly step in to see if indeed you're the second coming.

### Impervious to Documentation
The current search results for "how to gnus gmail" are sparse and unauthoritative.  At the time of writing, the lead result is an [unstructured braindump](https://github.com/redguardtoo/mastering-emacs-in-one-year-guide/blob/master/gnus-guide-en.org) whose github star count is less indicative of actual usage than fervent solidarity amongst the author's countrymen ([996.icu](https://github.com/996icu/996.ICU) ring a bell?).  My main criticism is the guide's complete glossing over the hardest part, which is not Gnus's notoriously arcane UX, but how to string together systemd, mbsync, and possibly dovecot.  Also clear as mud is accommodating multiple addresses within the same imap service be it GMail or NetEase.

### Two-timing
Using Gnus just for say RSS and keeping mu4e for GMail betrays an irreconcilable lack of faith.  Like Scientology, Gnus urges giving of yourself wholly and unconditionally.  Unlike Scientology though, Gnus won't demand the same of your wallet.  As fierce a Gnus evangelist as am I, I'd rather the two-timers kick Gnus to the curb and monogamously commit to mu4e.

But the parents of millennials were more likely to have taken their kids to see "The Lion King" than "Reality Bites."  So millennials have been inured at an early age of "a la carte" preferences and inclusion.  Two-timing is *de rigueur* particularly amongst org-mode devotees, a good number of whom only use emacs for task management and demur to a modern IDE for coding.  There is even a [well known elisp blogger](https://nullprogram.com) who uses vi as his primary editor.

The vi editor, I'll make an exception for.  It's the proverbial dagger in your boot when a barren container environment disarms you of your broadsword.  Employing multiple text editors generally though is akin to carrying both an IPhone and Android, and using the latter for one or two Android-only apps.  Or, more colorfully, it's like a busker slinging two guitars, who plays the Fender for his entire set, but unsheathes the Gibson in case the crowd requests "Stairway to Heaven."  Or the samurai who laboriously carries two swords, one for combat, and the other for the less frequent task of *seppuku*.  Many would argue he leave the *wakizashi* at home, if only to make it less convenient to off himself, a temptation hard to resist when one's honor blade is so close at hand.

I get that an adjustable wrench is less optimal than a fixed wrench of just the right size, but tooling analogies in the physical world do not hold in the virtual where everything including your tooling is malleable.  Aside: I glitch when a coder is classified an "engineer."  That relatively recent label would seem obtuse twenty years ago.  Traditionally, engineers require an empirical understanding of physical phenomena, and your garden-variety coder never took fluid or thermo.

### I only run a single emacs now
With non-blocking fetch in Gnus version 5.14, I am proud to say I can finally join my fellow *gnusers* who have always run Gnus in the same emacs instance as their other work.  Until this point having Gnus's fetch cycle obstructing other activities was too disruptive for my taste.  Not having two emacsen cluttering my desktop is sparking the joy off its cover.

### And Your Point Is...
Given all the handwringing and self-doubt, why Gnus at all then?  Mail programs are good at filtering out messages you've already read.  Now imagine you could get the same "unreads" view for all your news sources.  Your antediluvian copy of "Netscape Messenger" can do that but how often do you fire up Windows 95 these days?

Gnus replaces the "leaderboard" view of websites with this far more useful "unreads" view.  That alone, if you ask me, is worth the price of admission.  But the abstraction applies to both reading and writing.  Gnus lets you post to websites in the same way you'd post to Usenet or "post" to an email thread.  Once a "backend" gets written for a message source (most likely http-based in the current REST landscape), Gnus deftly fills a slot for it amongst all your other "subscriptions" be they inboxes, mailing lists, RSS feeds, subreddits, Hacker News, Twitter, or Discourse forum topics.

The popular elfeed package runs circles around Gnus in search and retrieval speed, but elfeed is limited by the serial, unthreaded presentation of the RSS protocol.  Disparate stories and comments are interleaved in a time-ordered but largely incoherent queue.  Moreover, RSS doesn't let you respond, that is, elfeed can only provide a link to the original story in the browser.  In your Hulk-like rage to punish the flamebait, you might already have reverted to Bruce Banner by the time you've context switched to the browser.  On the other hand, being served an anemic HTML5 textbox to pen your immortal diatribe could reignite your gamma-ray fueled fury, so jumping back and forth between emacs and the browser isn't all bad.  My recommendation remains editing directly in emacs.

There's a greater, less obvious motivation at play though. **Gnus is a forcing function that makes you a better emacs user.**  Why do you struggle with emacs when vscode does everything correctly out of the box?  Because you're sanguinely aware that given enough time (but not as much time as vim or vscode would require), you can bend emacs to do anything including [brewing your coffee](https://youtu.be/y0LEW7a0LoQ).  And the more tasks you make it do, the cleaner and faster your elisp-fu becomes in making it do others.  Why not bring that powerful feedback loop to bear on that most essential of human activities, reading and writing messages from and to other people?
