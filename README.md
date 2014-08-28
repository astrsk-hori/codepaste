codepaste
=========

コードやログなどを貼り付けて共有する。markdownとハイライトが使える
社内等の使い捨てgistのようなもの

## install

```
bundle install --path vendor/bundle
```

edit config/database.yml

create database

```
bundle exec rake db:migrate
bundle exec rake db:seed
```

```
rails s
```

初期ユーザ「admin@example.com」
初期パスワード「adminadmin」

最初にログインしたらパスワードを変更してください。
