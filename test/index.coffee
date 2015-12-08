_       = require 'lodash'
path    = require 'path'
config  = require 'config'
assert  = require 'power-assert'
Promise = require 'bluebird'
{API_KEY, API_SECRET, IMAGE_URL, ATTRIBUTE} = config.get 'FACE_PP'

describe 'FacePlusPlusClient', ->

  before ->
    FacePlusPlusClient = require path.resolve 'build', 'facePlusPlusClient'
    @client = new FacePlusPlusClient()
    @holder = {}
    @Constatns =
      NUM_MEMBER: 4
      TAG: 'ff_test'
      GROUP_NAME: 'TestUsers'
      PERSON_NAME: 'TestUser10'

  describe 'Save person data', ->

    ###
    1. グループの作成
    2. グループ情報の取得
    3. 顔検出
      1. 顔情報の取得
    4. 人物の作成
    5. 人物情報の取得
    6. identifyの訓練
    7. identifyの実行
    ###

    # it 'should create group named TestUsers', (done) ->
    #   params = group_name: @Constatns.GROUP_NAME, tag: @Constatns.TAG
    #   @client.get '/group/create', params
    #   .then (resultCreateGroup) =>
    #     assert resultCreateGroup.added_person is 0
    #     assert _.has resultCreateGroup, 'group_id'
    #     assert resultCreateGroup.group_name is @Constatns.GROUP_NAME
    #   .catch (err) ->
    #     assert err.status is 453
    #   .finally ->
    #     done()

    it 'should get correct group_info', (done) ->
      params = group_name: @ Constatns.GROUP_NAME
      @client.get '/group/get_info', params
      .then (resultGetGroupInfo) =>
        assert resultGetGroupInfo.group_name is @Constatns.GROUP_NAME
        assert resultGetGroupInfo.tag is @Constatns.TAG
      .catch (err) ->
        console.log err
        assert err.status is 400
      .finally ->
        done()

    # it 'should remove person', (done) ->
    #   personIdListStr = '154e59a9e61b5f4d6604b0108d57a5dd,d899a882de6e01c8e3b6667a9f636fa6,76346f99ce9f39580d8cad5856aa63e0,484ae7b99809d5f15de1d7ff6d31ec5d,e4c625f9f4524f8ec969ed14a21e52c3'
    #   params = person_id: personIdListStr
    #   @client.get '/person/delete', params
    #   .then (resultRemoveGroupPerson) =>
    #     assert resultRemoveGroupPerson.deleted is 5
    #     assert resultRemoveGroupPerson.success is true
    #   .catch (err) ->
    #     console.log err
    #     assert err.status is 400
    #   .finally ->
    #     done()

    # it 'should remove group person', (done) ->
    #   personIdListStr = '154e59a9e61b5f4d6604b0108d57a5dd,d899a882de6e01c8e3b6667a9f636fa6,76346f99ce9f39580d8cad5856aa63e0,484ae7b99809d5f15de1d7ff6d31ec5d,e4c625f9f4524f8ec969ed14a21e52c3'
    #   params = group_name: @Constatns.GROUP_NAME, person_id: personIdListStr
    #   @client.get '/group/remove_person', params
    #   .then (resultRemoveGroupPerson) =>
    #     assert resultRemoveGroupPerson.removed is 5
    #     assert resultRemoveGroupPerson.success is true
    #   .catch (err) ->
    #     console.log err
    #   .finally ->
    #     done()

    it 'should ', (done) ->
      params = url: IMAGE_URL, attribute: ATTRIBUTE
      @client.get '/detection/detect', params
      .then (result) =>
        assert result.face.length is @Constatns.NUM_MEMBER

        # 検出した顔IDがFace++APIのサーバーに保持されているか調査
        faceIdList = _.pluck result.face, 'face_id'
        faceIdListStr = faceIdList.join ','
        params = face_id: faceIdListStr
        @client.get '/info/get_face', params
      .then (resultGetFaceInfo) =>
        assert _.has resultGetFaceInfo, 'face_info'
        assert resultGetFaceInfo.face_info.length is @Constatns.NUM_MEMBER
        assert _.has resultGetFaceInfo.face_info[0], 'attribute'
        assert _.has resultGetFaceInfo.face_info[0], 'position'
        assert _.has resultGetFaceInfo.face_info[0], 'face_id'
        @holder.face_id_first = resultGetFaceInfo.face_info[0].face_id
        console.log '@holder.face_id_first = ', @holder
      .catch (err) ->
        console.log err
      .finally ->
        done()

    # it 'should create person named TestUser', (done) ->
    #   params = face_id: @holder.face_id_first, tag: @Constatns.TAG, person_name: @Constatns.PERSON_NAME, group_name: @Constatns.GROUP_NAME
    #   @client.get '/person/create', params
    #   .then (resultCreatePerson) =>
    #     assert resultCreatePerson.added_face is 1
    #     assert resultCreatePerson.added_group is 1
    #     assert resultCreatePerson.person_name is @Constatns.PERSON_NAME
    #   .catch (err) ->
    #     assert err.status is 453
    #   .finally ->
    #     done()

    it 'should get person_list ', (done) ->
      @client.get '/info/get_person_list'
      .then (resultTrainIdentify) =>
        assert _.has resultTrainIdentify, 'person'
      .catch (err) ->
        console.log err
      .finally ->
        done()

    it 'should trained identify', (done) ->
      params = group_name: @Constatns.GROUP_NAME
      @client.get '/train/identify', params
      .then (resultTrainIdentify) =>
        assert _.has resultTrainIdentify, 'session_id'
      .catch (err) ->
        console.log err
      .finally ->
        done()

    it 'should recognize identify', (done) ->
      params = url: IMAGE_URL, group_name: @Constatns.GROUP_NAME, key_face_id: @holder.face_id_first
      @client.get '/recognition/identify', params
      .then (resultRecognitionIdentify) =>
        assert _.has resultRecognitionIdentify, 'face'
        console.log resultRecognitionIdentify.face[0].candidate
        console.log resultRecognitionIdentify.face[1].candidate
      .catch (err) ->
        console.log err
        # assert err.status is 441
      .finally ->
        done()