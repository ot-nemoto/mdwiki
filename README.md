 # mdwiki

- [Summary](#section1)
- [Dependencies](#section2)
- [Getting Started](#section3)
- [Directory structure for Contents](#section4)
- [Database Backup and Restore](#section5)

## <a name="section1">Summary

Simple wiki to write in markdown

## <a name="section2">Dependencies

- ruby >= 2.2.2
- gem >= 2.4.5
- rails >= 4.2.3

## <a name="section3">Getting Started
1. Download

        git clone https://github.com/nemonium/mdwiki.git

2. Gem package install

        cd mdwiki
        bundle install --path vendor/bundle

3. Run

        bundle exec rails s -e production

## <a name=section4">Directory structure for Contents

~~~
${WIKI_HOME}/tmp
`-- pages
    |-- HOME
    |-- summary.yml
    |-- 0
    |   |-- 00000000000000000000000000000000
    |   |-- ...
    |   `-- 0fffffffffffffffffffffffffffffff
    |-- ...
    `-- f
        |-- ...
        `-- ffffffffffffffffffffffffffffffff
~~~

## <a name="section5">Databese Backup and Restore

- Backup

        cd ${WIKI_HOME}
        tar -zcvf backup.tar.gz tmp/pages

- Restore

        cd ${WIKI_HOME}
        tar -zxvf backup.tar.gz -C .
