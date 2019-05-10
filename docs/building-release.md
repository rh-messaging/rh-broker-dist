Building the release from downstream repo
-----------------------------------------

Building the distro from Productised source
-------------------------------------------


###Running an example

1.  Download the binary distribution and unzip it

2.  Navigate in a shell to the example you want to run

3.  Execute maven but enable the profiles for all the repositories needed, see [Setting Up Maven Repos](Setting-Up-Maven-Repos()).

    >mvn verify -Pamq7.3.0,earlyaccess,redhat-ga


Setting Up Maven Repos
----------------------

###Setting Up Offline Maven Repo

Every release is shipped with an offline rmaven repository that can be used to build the source and run the examples.
To use it follow these instructions

1.  Download the maven repo and unzip it inro a directory somewhere

2.  Add a profile to your maven settings.xml to point to the unzipped repo, for instance
  

    <profile>
       <id>amq7.3.0</id>
       <repositories>
         <repository>
           <id>repository</id>
           <url>file:///home/../maven-repository</url>
           <releases>
             <enabled>true</enabled>
           </releases>
           <snapshots>
             <enabled>false</enabled>
           </snapshots>
         </repository>
       </repositories>
       <pluginRepositories>
         <pluginRepository>
           <id>repository</id>
           <url>file:///home/../maven-repository</url>
           <releases>
             <enabled>true</enabled>
           </releases>
           <snapshots>
             <enabled>false</enabled>
           </snapshots>
         </pluginRepository>
       </pluginRepositories>
     </profile>

###Setting Up Early Access Repo

1.  Add the following to your maven settings.xml


    <profile>
        <id>earlyaccess</id>
        <repositories>
            <repository>
                <id>earlyaccess</id>
                <url>http://maven.repository.redhat.com/earlyaccess/all/</url>
                <releases>
                    <enabled>true</enabled>
                </releases>
                <snapshots>
                    <enabled>true</enabled>
                </snapshots>
            </repository>
        </repositories>
        <pluginRepositories>
            <pluginRepository>
                <id>jboss-earlyaccess-repository</id>
                <url>http://maven.repository.redhat.com/earlyaccess/all/</url>
                <releases>
                    <enabled>true</enabled>
                </releases>
                <snapshots>
                    <enabled>true</enabled>
                </snapshots>
            </pluginRepository>
        </pluginRepositories>
    </profile>
    
###Setting Up GA Repo

1.  Add the following to your maven settings.xml


    <profile>
	     <id>redhat-ga</id>
	     <repositories>
	       <repository>
		 <id>redhat-ga</id>
		 <name>redhat-ga</name>
		 <url>https://maven.repository.redhat.com/ga</url>
	       </repository>
	     </repositories>
		<pluginRepositories>
            <pluginRepository>
                <id>redhat-ga</id>
                <url>https://maven.repository.redhat.com/ga</url>
                <releases>
                    <enabled>true</enabled>
                </releases>
                <snapshots>
                    <enabled>true</enabled>
                </snapshots>
            </pluginRepository>
        </pluginRepositories>
    </profile>