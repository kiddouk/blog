---
layout: post_with_disqus
title: A tale of privacy (part 1)
author: SEBASTIEN REQUIEM
---

<p class="intro">Due to the recent events regarding global spying and government not being totally honest regarding the activities against its own citizens, I have decided to reclaim my privacy. And here is how it goes ...</p>

Reclaiming your privacy is a strong statement and should not be taken lightly. It has some immediate impact on how one should think. It forces you to re-consider many choices made a long time ago. I've always been an advocate for open source software and really enjoy each speech from Richard Stallman. I believe that this gives you a certain sense of control over what your computer can do to compromise your privacy.

However, I have no need for being 100% anonymous when I use my computer, but I really want to reduce my footprint as much as I can.

## Step 1: Configuring your browsers. ##

My browser of choice is [chromium](http://www.chromium.org/), the non branded and non auto-updating version of Chrome Browser from google. Of course, this browser will never see me logging in any Google related service. Not even the start page (or any login required service). This means that I can't enjoy the bookmark synchronisation between different machines, neither the plugins sync. Moreover, I use [DoNotTrackMe](http://abine.com/donottrackme/), a nice little extension that prevent a lot of companies to track my steps on the internet. I wish that this extension was open source though. It is not, at the moment.

For the websites that requires a login and password, I have a second browser (I use firefox). This prevent any cookie leaking in case DontTrackMe doesn't do a proper job somewhere. It is not perfect but that is the best way I found. On Chromium, I also de-activated javascript. This is where it hurts. Many features are disabled and many websites are broken. We rely A LOT on javascript but that's probably the price to pay for me being able to just browse the internet anonymously.

## Step 2: Using TOR and search no more ##

Once this was done, I have decided to use TOR for as many requests as possible. Since I use two different browser, this is quite easy. All my traffic from Chromium is redirected to TOR (well, polipo in front of TOR for some good HTTP headers sanatizing). This brings three things, a certain anonymity, a slower connection and the fact that you get rejected from google 60% of the time. This is a big pain for me here. You either get rejected from google or need to enter a captcha if you're lucky. This slows things a lot. This comes TOR network being abused by attackers. Google tries to protect itself and assimilate you with the "attackers". But TOR is offering me a lot of good stuff like data encryption and frequent IP change. It's a win for my privacy.

## Step 3: Communication ##

I've always loved XMPP and decided to keep on using it, with one modification. I use OTR. AdiumX supports it with a plugin. The only thing is that my family leaves far away (Australia and France) and Skype has always been practical to have voice calls. Recently I heard about Silent Circle who provide a service called [Silent Phone](https://silentcircle.com/web/silent-phone/). It is not open source either. If one of you have some good input here, I would be happy.

That's about it for now. Two big pain here. Google denies most of my searches when I use TOR. Also, no open source project supports Voice (over XMPP with encryption and authentication) with a reasonable quality. Let's see what Part 2 will bring.
