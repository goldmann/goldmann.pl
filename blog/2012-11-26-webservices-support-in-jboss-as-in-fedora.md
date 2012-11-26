---
title: "Webservices support in JBoss AS in Fedora"
author: "Marek Goldmann"
layout: blog
timestamp: 2012-11-26t14:15:00.10+01:00
tags: [ fedora, java, jboss_as ]
---

<div class="alert alert-info"><h4>Version info</h4>New features mentioned in this post are available in <code>jboss-as-7.1.1-11</code> or newer.</div>

Until now the webservices support was not available in the [Fedora](http://fedoraproject.org/) packaged JBoss AS. The main issue was the lack of [CXF stack](http://cxf.apache.org/) in Fedora. It took some time to make it available in an RPMified version since CXF is a pretty big project, with many submodules and a pretty nice dependency tree.

Currently in Fedora we have JBoss AS available in version `7.1.1.Final` which requires CXF `2.4.6`. This is a pretty old release. I decided to **upgrade the CXF stack** to the latest available release from the `2.6.x` series. This triggered updating the `jbossws-*` stack to newer versions than shipped with JBoss AS `7.1.1.Final`. I did some tests and it seems that the components integrate with JBoss AS seamlessly. Either case please test your application with the new stack and [report any bugs](https://bugzilla.redhat.com/enter_bug.cgi?product=Fedora&component=jboss-as).

### Sample application

To ensure the webservices integration works as expected I [created a small application](https://github.com/goldmann/jboss-as-webservices).

<pre>
package pl.goldmann.as7.ws;

import javax.jws.WebMethod;
import javax.jws.WebService;

@WebService
public interface Calculator {

  @WebMethod
  public float add(float a, float b);

  @WebMethod
  public float sub(float a, float b);

  @WebMethod
  public float multiply(float a, float b);

  @WebMethod
  public float divide(float a, float b);
}
</pre>

As you can see the webservice is a **very simple calculator** with four basic operations. You can build the application by executing `mvn package`. I used the `jboss-cli` command to deploy the application to JBoss AS:

<pre>
[standalone@localhost:9999 /] deploy /home/goldmann/tmp/webservices.war
</pre>

And here is the JBoss AS log:

<pre>
13:26:07,705 INFO  [org.jboss.as.server.deployment] (MSC service thread 1-7) JBAS015876: Starting deployment of "webservices.war"
13:26:08,749 INFO  [org.jboss.ws.cxf.metadata] (MSC service thread 1-2) JBWS024061: Adding service endpoint metadata: id=CalculatorWS
 address=http://jboss-as:8080/webservices
 implementor=pl.goldmann.as7.ws.CalculatorWS
 invoker=org.jboss.wsf.stack.cxf.JBossWSInvoker
 serviceName={http://ws.as7.goldmann.pl/}CalculatorWS
 portName={http://ws.as7.goldmann.pl/}CalculatorWSPort
 wsdlLocation=null
 mtomEnabled=false
13:26:09,597 INFO  [org.apache.cxf.service.factory.ReflectionServiceFactoryBean] (MSC service thread 1-2) Creating Service {http://ws.as7.goldmann.pl/}CalculatorWS from class pl.goldmann.as7.ws.Calculator
13:26:11,458 INFO  [org.apache.cxf.endpoint.ServerImpl] (MSC service thread 1-2) Setting the server's publish address to be http://jboss-as:8080/webservices
13:26:11,781 INFO  [org.jboss.ws.cxf.deployment] (MSC service thread 1-2) JBWS024074: WSDL published to: file:/var/lib/jboss-as/standalone/data/wsdl/webservices.war/CalculatorWS.wsdl
13:26:11,793 INFO  [org.jboss.as.webservices] (MSC service thread 1-4) JBAS015539: Starting service jboss.ws.port-component-link
13:26:11,824 INFO  [org.jboss.as.webservices] (MSC service thread 1-6) JBAS015539: Starting service jboss.ws.endpoint."webservices.war".CalculatorWS
13:26:11,899 INFO  [org.jboss.ws.common.management] (MSC service thread 1-6) JBWS022050: Endpoint registered: jboss.ws:context=webservices,endpoint=CalculatorWS
13:26:12,335 INFO  [org.jboss.web] (MSC service thread 1-3) JBAS018210: Registering web context: /webservices
13:26:12,548 INFO  [org.jboss.as.server] (management-handler-thread - 1) JBAS018559: Deployed "webservices.war"
</pre>

You can see the [WSDL](http://en.wikipedia.org/wiki/Web_Services_Description_Language) by pointing your browser to [http://jboss-as:8080/webservices?wsdl](http://jboss-as:8080/webservices?wsdl).

<div class="alert alert-info"><h4>Hostname</h4>The example applications use <code>jboss-as</code> as the hostname. You may want to edit the <code>/etc/hosts</code> file and add an entry to map this hostname to a valid IP address.</div>

### Testing the webservice

<a class="picture" href="/images/soapui_calculator.png" title="Sample calls to websevice using SoapUI"><img style="float:right; border: 1px solid #eee; padding: 5px; margin-left: 5px; width: 50%;" alt="Sample calls to websevice using SoapUI" src="/images/soapui_calculator.png" /></a>

To test the service I prepared a simple [standalone client](https://github.com/goldmann/jboss-as-webservices-client). You can build it by running `mvn package`. To start the client just execute:

    java -jar target/webservices-client-1.0.jar

and observe the output. It should be similar to [what I got](https://gist.github.com/81ad7a7b3b4d2d510ebf).

Additionally I ran some basic tests with [SoapUI](http://www.soapui.org/). I was able to create a webservice from WSDL and run some sample requests. You can see the result <a class="picture" href="/images/soapui_calculator.png" title="Sample calls to websevice using SoapUI">on the screenshot</a>.

### Summary

As you can see the webservice stack in JBoss AS in Fedora works! Of course all you saw above are basic tests. If you have something more fancy, go for it and [let me know](/socially/) how it went.

<script type="text/javascript">
    $('.picture').colorbox();
</script>
