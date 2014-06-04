- [Summary](#section1)
- [Dependencies](#section2)
- [Getting Started](#section3)
- [Initial Account](#section4)
- [Database Backup and Restore](#section5)

# <a name="section1">Summary

Simple wiki to write in markdown

# <a name="section2">Dependencies

- ruby >= 1.9.3-p448
- gem >= 1.8.23
- rails >= 4.0.1

# <a name="section3">Getting Started
1. Download

        git clone https://github.com/nemonium/mdwiki.git

2. Gem package install

        cd mdwiki
        bundle install

3. Setup database (If you use MySQL)

    /etc/my.cnf

        character-set-server=utf8
        max_allowed_packet=128M

    ---

        mysql> create user 'mdwiki'@'localhost' identified by 'passwd';
        mysql> grant all on *.* to 'mdwiki'@'localhost';

    ---

        rake db:setup RAILS_ENV=production

4. Configuration

    config/enviroments/production.rb

          config.action_mailer.default_url_options = { :host => 'https://localhost:3000' }
          config.action_mailer.delivery_method = :smtp
          config.action_mailer.default :charset => "utf-8"
          config.action_mailer.perform_deliveries = true
          config.action_mailer.smtp_settings = {
            :address => 'example.com',
            :port => 587,
            :authentication => :plain,
            :user_name => 'info@example.com',
            :password => 'password',
            :domain => 'example.com',
            :enable_starttls_auto => false
          }

5. Boot

        rails s -e production

# <a name="section4">Initial Account

|Email            |Password     |
|-----------------|-------------|
|admin@example.com|administrator|

*After creating the user, please delete this user.*

# <a name="section5">Databese Backup and Restore

- Backup

        mysqldump -umdwiki -ppasswd mdwiki_development > mdwiki_production.sql

- Restore

        mysql -umdwiki -ppasswd mdwiki_production < mdwiki_production.sql
