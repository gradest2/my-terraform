#!/bin/bash
apt-get -y update

#install docker
apt-get -y install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get -y update
apt-get install -y docker-ce docker-ce-cli containerd.io

#install mysql(https://hub.docker.com/_/mysql?tab=description)
docker pull mysql:8.0.28
docker run --name mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=zQ11^tda -d mysql:8.0.28
apt-get -y install mysql-client-core-8.0


#create database and table
cat <<EOF > /tmp/script.sql
  CREATE DATABASE lesson1;
  use lesson1;

  CREATE TABLE Persons (
      PersonID int,
      LastName varchar(255),
      City varchar(255)
  );

  CREATE TABLE logs (
      logrecord varchar(255)
  );

  INSERT INTO Persons (PersonID, LastName, City)
  VALUES (1,'Ivanov','Saint-Petersburg');
  INSERT INTO Persons (PersonID, LastName, City)
  VALUES (2,'Petrov','Saint-Petersburg');
  INSERT INTO Persons (PersonID, LastName, City)
  VALUES (3,'Astahov','AdvIT');

  INSERT INTO logs (logrecord)
  VALUES ('Create User1');
  INSERT INTO logs (logrecord)
  VALUES ('Create User2');
  INSERT INTO logs (logrecord)
  VALUES ('Create User3');
EOF

mysql --host=127.0.0.1 --port=3306 --user=root --password=zQ11^tda < /tmp/script.sql
rm -f /tmp/script.sql
