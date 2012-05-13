---
title: "HP Smart Array E200i performance"
author: "Marek Goldmann"
layout: blog
timestamp: 2012-05-13t15:18:00.10+02:00
tags: [ hardware ]
---

I have at home a pretty nice server: [HP ML350 G5](http://h18004.www1.hp.com/products/quickspecs/12475_na/12475_na.HTML). My model has one Quad-Core Intel Xeon Processor X5355 (2.66 GHz), 8 GB of RAM and 4x 250 GB SATA II, 2.5'', 5.4k disk drives.

I have this HW for over three years now, but never really tried to do anything besides installing an operating system and [grinding some boxes](http://boxgrinder.org/). Recently I decided to run some quick tests to see the actual performance of the disks.

The machine has an built-in array controller: [HP Smart Array E200i with 128MB BBWC](http://h18000.www1.hp.com/products/quickspecs/DS_00055/DS_00055.PDF) [pdf, 149KB]. There are a lot of resources on the web saying that this is a *piece of crap*. This wasn't very optimistic.

The E200i controller supports following, basic RAID versions: 0, 1+0, 5.

The reason I started searching for possible speed improvements was the (subjective) feeling that the disks are simply slow. I tried every RAID level, but wasn't satisfied even with 0. I haven't had any good numbers at that time though.

So I booted [CentOS](http://centos.org/) 6 LiveCD and started the [Disk Utility](http://en.wikipedia.org/wiki/Palimpsest_Disk_Utility) and run the read-write benchmarks. The results are below.

<div class="alert alert-info">
All presented RAID logical disks were created using default settings and included all 4 disks for each level.
</div>

<a rel="without" class="picture" href="/images/raid/raid0.png" title="Default RAID 0"><img style="width: 30%;" alt="RAID 0 without DWC" src="/images/raid/raid0.png" /></a>
<a rel="without" class="picture" href="/images/raid/raid10.png" title="Default RAID 1+0"><img style="width: 30%;" alt="RAID 1+0 without DWC" src="/images/raid/raid10.png" /></a>
<a rel="without" class="picture" href="/images/raid/raid5.png" title="Default RAID 5"><img style="width: 30%;" alt="RAID 5 without DWC" src="/images/raid/raid5.png" /></a>

Uh. Ah... I knew the performance wasn't great but I wasn't expecting such horrible write performance. I'm pretty happy with read performance though. Remember: these are 2.5'' 5.4k disks, so nothing very fancy.

I started to crawl the web for solutions for this problem. I found ACU. HP's **[Array Configuration Utility](http://h18004.www1.hp.com/products/servers/proliantstorage/software-management/acumatrix/index.html)** provides an easy way to view and change the configuration of the arrays. I didn't bother myself with the gui version, I used CLI, which works just fine. You can download it from [here](http://h20000.www2.hp.com/bizsupport/TechSupport/DriverDownload.jsp?prodNameId=468781&lang=en&cc=us&prodTypeId=18964&prodSeriesId=468780&taskId=135). I installed it on the running LiveCD and started to poke around. HP ships a nice [manual for using ACU](http://h20000.www2.hp.com/bizsupport/TechSupport/CoreRedirect.jsp?redirectReason=DocIndexPDF&prodSeriesId=468780&targetPage=http%3A%2F%2Fbizsupport1.austin.hp.com%2Fbc%2Fdocs%2Fsupport%2FSupportManual%2Fc00729544%2Fc00729544.pdf) [pdf, 1.8MB].

To list the status of the array controller, just run the CLI: `hpacucli` and execute the `ctrl slot="0" show` command, like this:

<pre>
[root@livecd ~]# hpacucli
HP Array Configuration Utility CLI 9.0-24.0
Detecting Controllers...Done.
Type "help" for a list of supported commands.
Type "exit" to close the console.

=> ctrl slot="0" show

Smart Array E200i in Slot 0 (Embedded)
   Bus Interface: PCI
   Slot: 0
   Cache Serial Number: P9A3A0B9SWM13U
   RAID 6 (ADG) Status: Disabled
   Controller Status: OK
   Hardware Revision: A
   Firmware Version: 1.82
   Rebuild Priority: Medium
   Expand Priority: Medium
   Surface Scan Delay: 15 secs
   Surface Scan Mode: Idle
   Post Prompt Timeout: 0 secs
   Cache Board Present: True
   Cache Status: OK
   Accelerator Ratio: 50% Read / 50% Write
   Drive Write Cache: Disabled
   Total Cache Size: 128 MB
   Total Cache Memory Available: 96 MB
   No-Battery Write Cache: Disabled
   Cache Backup Power Source: Batteries
   Battery/Capacitor Count: 1
   Battery/Capacitor Status: OK
   SATA NCQ Supported: False
</pre>

After quick look at the output we can see this line:

<pre>
Drive Write Cache: Disabled
</pre>

I found on the web that enabling DWC and setting it to 100% read and 0% write ratio improves the peroformance significantly. I changed the values using these commands:

<pre>
=> ctrl slot=0 modify cacheratio=100/0
=> ctrl slot=0 modify dwc=enable

Warning: Without the proper safety precautions, use of write cache on physical
         drives could cause data loss in the event of power failure. To ensure
         data is properly protected, use redundant power supplies and
         Uninterruptible Power Supplies. Also, if you have multiple storage
         enclosures, all data should be mirrored across them. Use of this
         feature is not recommended unless these precautions are followed.
         Continue? (y/n) y
</pre>

Results are quite interesting!

<a rel="with" class="picture" href="/images/raid/raid0dwc.png" title="Default RAID 0 with DWC enabled"><img style="width: 30%;" alt="RAID 0 with DWC" src="/images/raid/raid0dwc.png" /></a>
<a rel="with" class="picture" href="/images/raid/raid10dwc.png" title="Default RAID 1+0 with DWC enabled"><img style="width: 30%;" alt="RAID 1+0 with DWC" src="/images/raid/raid10dwc.png" /></a>
<a rel="with" class="picture" href="/images/raid/raid5dwc.png" title="Default RAID 5 with DWC enabled"><img style="width: 30%;" alt="RAID 5 with DWC" src="/images/raid/raid5dwc.png" /></a>

Afterwards I experimented with the cache ratio but the settings 100% / 0% seems to be the best.

When ratio was set to, for example 50% / 50% (default value) the performance was better than with DWC disabled, but not as good as with 100% / 0%. At least for my tests. Maybe a specific usage of the disks will require different settings.

<script type="text/javascript">
    $('.picture').colorbox();
</script>

<div class="alert alert-block">
<h4 class="alert-heading">Warning!</h4>
HP itself <a href="http://h20000.www2.hp.com/bizsupport/TechSupport/Document.jsp?objectID=c01149818&lang=en&cc=us&taskId=101&prodSeriesId=1121586&prodTypeId=15351">doesn't recommend</a> enabling DWC for mission-critical systems and for systems without proper power infrastructure (redundancy, UPS, etc) because in case of a power outage it may destroy your data. Ouch.
</div>

Assuming we have proper power backup (I have an [APC Smart-UPS](http://www.apc.com/products/resource/include/techspec_index.cfm?base_sku=SUA1000I) connected to the box) we can go ahead and get some performance.
