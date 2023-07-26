CREATE USER 'teamone'@'%' IDENTIFIED BY 'bdse30teamone';
GRANT ALL PRIVILEGES ON *.* TO 'teamone'@'%';
FLUSH PRIVILEGES;


DROP USER 'teamone'@'%';

