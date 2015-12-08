faceplusplus-test
======

Operation verification of Faece++ API.

> <a href="http://www.faceplusplus.com/api-overview/" target="_blank">Api overview | API Docs | Face++</a>

## ハマったポイント

#### `/person/craete`でgroup_nameを指定して人物を登録したい。

先に`/group/create`で`group`を作成しておかないとダメ。

## Done

- [x] /detection/detect
- [x] /train/identify
- [x] /recognition/identify
- [x] /person/create
- [x] /person/delete
- [x] /person/get_info
- [x] /group/create
- [x] /group/delete
- [x] /group/add_person
- [x] /group/get_info
- [x] /info/get_person_list
- [x] /info/get_group_list
