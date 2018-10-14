---
title: "Configuring polkit in Fedora 18 to access virt-manager"
author: "Marek Goldmann"
date: 2012-12-03
tags: [ fedora ]
---

<a class="picture" href="/images/polkit_virt-manager.png" title="virt-manager authentication"><img style="float:right; border: 1px solid #eee; padding: 5px; margin-left: 5px; width: 50%;" alt="virt-manager authentication" src="/images/polkit_virt-manager.png" /></a>

In [Fedora](https://fedoraproject.org/) when you run [`virt-manager`](http://virt-manager.org/) you'll be asked for your password. Since I use this tool a lot I would like to have a password-less virt-manager.

Thank [Jebus](http://en.wikipedia.org/wiki/Jebus) we have [polkit](http://en.wikipedia.org/wiki/Polkit) where we can define authentication rules. There was a [handy rule available written by Rich](http://www.outsidaz.org/blog/2010/10/15/configuring-policykit-access-to-virt-manager/), but it stopped to work with the release of Fedora 18 because polkit changed completely the language used in rules files. Since `polkit-0.106` the **new rules files are written in JavaScript**. Yes, JavaScript. More info about the choice you can find on [David's blog post](http://davidz25.blogspot.com/2012/06/authorization-rules-in-polkit.html).

To access `virt-manager` without entering password, just a create a file named `/etc/polkit-1/rules.d/80-libvirt-manage.rules` (or similar) with following content:

<pre>
polkit.addRule(function(action, subject) {
  if (action.id == "org.libvirt.unix.manage" && subject.local && subject.active && subject.isInGroup("wheel")) {
      return polkit.Result.YES;
  }
});
</pre>

Remember to add your user to the `wheel` group:

    usermod -a -G wheel goldmann

That's all, enjoy!

<script type="text/javascript">
    $('.picture').colorbox();
</script>
