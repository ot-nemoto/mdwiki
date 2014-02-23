- [Summary](#section1)
- [Dependencies](#section2)
- [Getting Started](#section3)
- [Backup](#section4)
- [Restore](#section5)

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

3. Configure

        cp config/users.yml.example config/users.yml

    ---

    *Password hashing*

        irb
        > require 'digest/sha2'
        > s = 'password'  # <= password
        > puts Digest::SHA256.hexdigest(s)
        5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8

4. Boot

        rails s

# <a name="section4">Backup

1. Backup for mdwiki data

        cd ${RAILS_ROOT}
        tar -zcf mdwiki-backup-`date +%Y%m%d`.tar.gz config/users.yml public/images/* db/wiki/*

# <a name="section5">Restore

1. Stopping mdwiki

2. Create a backup of the latest for mdwiki data

        cd ${RAILS_ROOT}
        tar -zcf mdwiki-backup-`date +%Y%m%d`.tar.gz config/users.yml public/images/* db/wiki/*

3. Delete the existing data, if necessary

        rm -rf config/users.yml public/images/* db/wiki/*

4. Restore for mdwiki data

        tar -zxf mdwiki-backup-XXXXXXXX.tar.gz

5. Starting mdwiki
