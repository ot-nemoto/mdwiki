- [Summary](#section1)
- [Dependencies](#section2)
- [Getting Started](#section3)

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

4. Boot

        rails s

5. Login

- Email

    admin@example.com

- Password

    administrator
