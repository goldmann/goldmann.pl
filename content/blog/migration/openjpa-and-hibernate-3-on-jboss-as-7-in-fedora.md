---
title: "OpenJPA and Hibernate 3 on JBoss AS in Fedora"
author: "Marek Goldmann"
date: 2012-08-22
tags: [ fedora, rpm, java, jboss_as ]
---

With the upcoming new release of the [JBoss AS](http://www.jboss.org/as7) package in Fedora you'll be able to use both the [Hibernate](http://www.hibernate.org/) 3 and [OpenJPA](http://openjpa.apache.org/) JPA providers. The reason why I'm enabling this for you is that we still don't have Hibernate 4 packaged, which is a pity since Hibernate 4 is the default JPA provider in JBoss AS 7. **If you want to help us** with it, please consider [reviewing the Gradle package](https://bugzilla.redhat.com/show_bug.cgi?id=809950).

## Sample application

I crafted a small application that shows how to use the two new providers. The full source code is available [from my GitHub account](https://github.com/goldmann/jboss-as-hibernate3-openjpa). This application uses JSF and CDI in addition to JPA. And yes, I use **both** JPA providers at the same time.

### Configuration files

Let's take a look at the `persistence.xml` file, since this is the most important part of the application.

    <?xml version="1.0" encoding="UTF-8"?>
    <persistence version="2.0"
                 xmlns="http://java.sun.com/xml/ns/persistence" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                 xsi:schemaLocation="
            http://java.sun.com/xml/ns/persistence
            http://java.sun.com/xml/ns/persistence/persistence_2_0.xsd">
        <persistence-unit name="hibernate3PU">
            <jta-data-source>java:jboss/datasources/ExampleDS</jta-data-source>
            <properties>
                <property name="hibernate.hbm2ddl.auto" value="create-drop"/>
                <property name="hibernate.show_sql" value="true"/>
                <property name="jboss.as.jpa.providerModule" value="org.hibernate:3"/>
            </properties>
        </persistence-unit>
        <persistence-unit name="openjpaPU">
            <provider>org.apache.openjpa.persistence.PersistenceProviderImpl</provider>
            <jta-data-source>java:jboss/datasources/ExampleDS</jta-data-source>
            <properties>
                <property name="jboss.as.jpa.providerModule" value="org.apache.openjpa"/>
                <property name="jboss.as.jpa.adapterModule" value="org.jboss.as.jpa.openjpa"/>
                <property name="jboss.as.jpa.adapterClass"
                          value="org.jboss.as.jpa.openjpa.OpenJPAPersistenceProviderAdaptor"/>
                <property name="openjpa.Log" value="DefaultLevel=WARN, Runtime=INFO, Tool=INFO, SQL=TRACE"/>
            </properties>
        </persistence-unit>
    </persistence>

As you can see I create *two* persistence units. Both use the `ExampleDS` datasource shipped with JBoss AS (it's an in-memory H2 database).

Please examine the `jboss.as.jpa.*` properties carefully. They tell JBoss AS which provider you want to use and how it should initialized.

#### Hibernate 3 Persistence Unit

Since Hibernate 3 is initially configured in JBoss AS 7 the only thing you need to provide is the `jboss.as.jpa.providerModule` property. Simple.

#### OpenJPA Persistence Unit

With OpenJPA it is a bit different. Besides the `providerModule` we need to additionally configure the `adapterModule` and `adapterClass` properties. This will be not necessary after the next stable JBoss AS 7 release. But we'll need to do this until then.

#### Other stuff

Additionally I enabled logging of the SQL statement execution, just for clarity.

The [`import.sql`](https://github.com/goldmann/jboss-as-hibernate3-openjpa/blob/master/src/main/resources/import.sql) file contains some sample data to populate the database on application startup. It's a Hibernate feature and will be used in our case by the Hibernate 3 provider only.

### Model

The only entity class in this application is the [`Chair`](https://github.com/goldmann/jboss-as-hibernate3-openjpa/blob/master/src/main/java/pl/goldmann/as7/model/Chair.java) class. It's simple, and not worth discussing here.

<div class="alert alert-info"><h4>Entity enhancement in OpenJPA</h4>OpenJPA requires <a href="http://openjpa.apache.org/entity-enhancement.html">entity enhancement</a>. There are several ways to do this. For this application <a href="https://github.com/goldmann/jboss-as-hibernate3-openjpa/blob/master/pom.xml#L171">I use</a> the <a href="http://openjpa.apache.org/enhancement-with-maven.html"><code>openjpa-maven-plugin</code></a>.</div>

<img style="float:right; border: 1px solid #eee; padding: 5px; margin-left: 5px;" alt="Hibernate 3 in action" title="Hibernate 3 in action" src="/images/hibernate3-jpa-application.png" />

### CDI beans

There are two CDI beans for interacting with the view and two for getting data from the database using different providers. This application **uses only one database**, so data entered with one provider will be accessible from the other one. Here you can see the power of JPA, where there is only one entity configured and it works across different providers. Nice!

The [`Hibernate3Bean.java`](https://github.com/goldmann/jboss-as-hibernate3-openjpa/blob/master/src/main/java/pl/goldmann/as7/bean/impl/Hibernate3Bean.java) and [`OpenJPABean.java`](https://github.com/goldmann/jboss-as-hibernate3-openjpa/blob/master/src/main/java/pl/goldmann/as7/bean/impl/OpenJPABean.java) files are almost the same - the only difference is in the injection of specific [`Database`](https://github.com/goldmann/jboss-as-hibernate3-openjpa/blob/master/src/main/java/pl/goldmann/as7/jpa/Database.java) interface implementations.

### View

The view is written in JSF. It's very simple to understand, so go [straight to the code](https://github.com/goldmann/jboss-as-hibernate3-openjpa/tree/master/src/main/webapp).

## Conclusion

It's easy to use Hibernate 3 and OpenJPA with JBoss AS 7. It's even easier with the [`jboss-as`](https://apps.fedoraproject.org/packages/jboss-as) package provided with Fedora. The [upstream tarball](http://www.jboss.org/jbossas/downloads) requires some manual work to get it running, in [Fedora](https://fedoraproject.org/) you get it _for free_.

 <div class="alert alert-info"><h4>Available in next jboss-as package update</h4>Please note that both Hibernate 3 and OpenJPA providers will be available **with the next** `jboss-as` package update, version **7.1.1-7**.</div>

If you have any issues ask in the comments or [report a bug directly](https://bugzilla.redhat.com/enter_bug.cgi?product=Fedora&component=jboss-as).

### Update 24.08.2012

The `jboss-as-7.1.1-7` package was submitted as an update for [Fedora 17](https://admin.fedoraproject.org/updates/jboss-as-7.1.1-7.fc17) and [Fedora 18](https://admin.fedoraproject.org/updates/jboss-as-7.1.1-7.fc18), please test it and bump the karma. This kind of feedback is **very important**.
