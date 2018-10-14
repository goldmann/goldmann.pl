---
title: "Generate a database schema with OpenJPA and Hibernate on JBoss AS 7"
author: "Marek Goldmann"
date: 2012-08-24
tags: [ fedora, java, jboss_as ]
---

When you develop an application, sometimes you want to run it quickly and test it manually. Sometimes you want to execute some integration tests that require database access. In all of these cases you need a working database. Thanks to JPA providers we can generate the database schema based on the entity definitions. Let's quickly look at two of them: [Hibernate](http://www.hibernate.org/) and [OpenJPA](http://openjpa.apache.org/).

## Hibernate configuration

I'm sure you have used [Hibernate](http://www.hibernate.org/) before. Did you know that it has a nice feature that generates the schema in the database at application startup? You can additionally place any [SQL](http://en.wikipedia.org/wiki/SQL) statements you want to execute after the creation of the schema into file called `import.sql`.

To enable the schema generation in Hibernate add the following property to `persistence.xml`:

    <property name="hibernate.hbm2ddl.auto" value="create-drop"/>

It works perfectly in JBoss AS 7.

The value `create-drop` means that the database schema will be created at application deploy time and removed when you undeploy it. There are other possible values like `validate`, `update` and `create`.

**By default**, Hibernate will search for the `import.sql` file in the root of the classpath of the produced archive. For a WAR file, it is located at `WEB-INF/classes/import.sql`, but if you generate a regular JAR just place the `import.sql` in the root of the file.

If you want to change the location of the file use `hibernate.hbm2ddl.import_files`. As the property name suggests, you can specify more than one file.

Read more about the Hibernate properties you can use in the [Miscellaneous Properties table located in the Hibernate documentation](http://docs.jboss.org/hibernate/orm/4.1/manual/en-US/html/ch03.html#configuration-optional).

## OpenJPA configuration

OpenJPA includes a similar feature. You can generate the schema by [using the provided MappingTool](http://openjpa.apache.org/builds/2.2.0/apache-openjpa/docs/ref_guide_mapping.html#ref_guide_mapping_mappingtool). [MappingTool](http://openjpa.apache.org/builds/2.2.0/apidocs/org/apache/openjpa/jdbc/meta/MappingTool.html) allows you to run the generation even from a command line. In our case, the more interesting feature is running it at application deploy time so that we automatically get a working schema in our database.

To make it work at runtime we need to add a `openjpa.jdbc.SynchronizeMappings` property to `persistence.xml`:

    <property name="openjpa.jdbc.SynchronizeMappings" value="buildSchema"/>

Additionally we **need to list all the classes** for which we want to generate the schema in our persistence unit so that OpenJPA knows about these classes at startup. Just use the `<class/>` marker, for example:

    <class>pl.goldmann.as7.model.Chair</class>

In JBoss AS 7 we need to **force the initialization** of the OpenJPA persistence unit that generates the schema at deployment time to actually trigger the schema generation. It's very simple, just add another property:

    <property name="openjpa.InitializeEagerly" value="true"/>

I'm not sure if OpenJPA has a built-in feature to execute SQL statements after schema generation like Hibernate. If you know how to do it, please **speak up**.

And that's it. It's a simple to implement but handy feature.
