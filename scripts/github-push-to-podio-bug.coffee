
Podio = require('podio-coffee').Podio
github = require('octonode')
request = require('request')

module.exports = (robot) ->
 robot.router.post "/bug/create", (req, res) ->
  console.log req.body
  success_cb = (data) -> return true
  error_cb = (data) -> return false

  if req.body.type == "hook.verify"
    podio_api = new Podio
    data =
      code:
        req.body.code
    console.log data
    podio_api.verify_hook req.body.hook_id, data, success_cb, error_cb

  if req.body.type = "item.create"
    podio_api = new PodioIssue(res)
    podio_api.update_bug_number req.body.item_id, success_cb, error_cb

  res.end "Ok"

 robot.router.post "/github/push", (req, res) ->
  podio_api = new PodioIssue(res)
  fixes_pattern = ///
   fix(es)?\spodio(/)?#[0-9]+
  ///gi
  refs_pattern = ///
   reference(s)?\spodio(/)?#[0-9]+
  ///gi
  item_pattern = ///
   podio(/)?#([0-9]+)
  ///i
  changelog_pattern = ///
   changelog:\s*(.*)
  ///gi
  changelog_message = ///
   changelog:\s*(.*)
  ///i


  success_cb = (data) -> res.end "success"
  if req.body.ref != 'refs/heads/develop'
    res.end "I dont like that."
    return true
  clg = new Changelog process.env.GITHUB_LOGIN, process.env.GITHUB_PASSWORD, 'gameisland/Backend'
  index = 0
  for commit in req.body.commits
    fixes = commit.message.match(fixes_pattern)
    references = commit.message.match(refs_pattern)
    changelogs = commit.message.match(changelog_pattern)
    if fixes?
      for fix in fixes
        console.log fix
        [match_elem, slash, item_id] = fix.match(item_pattern)
        request.post "http://git.io", {form:{url: commit.url}}, (e, r, body) ->
          c_url = if r.statusCode isnt 201 or e then commit.url else r.headers.location
          clg.add "* fixes podio##{item_id} [#{commit.id.substring(0, 6)}](#{c_url}) - #{commit.author.name}\n"
          index += 1
          podio_api.solve_issue item_id, c_url, success_cb, ->
            console.log "Error while processing GitHub Push"
    else
     if references?
      for ref in references
        [match_elem, slash, item_id] = ref.match(item_pattern)
        request.post "http://git.io", {form:{url: commit.url}}, (e, r, body) ->
          c_url = if r.statusCode isnt 201 or e then commit.url else r.headers.location
          index += 1
          podio_api.comment_issue item_id, c_url, success_cb, ->
            console.log "Error while processing GitHub Push"
     else
      if changelogs?
       for change in changelogs
        [match_elem, change_msg] = change.match(changelog_message)
        request.post "http://git.io", {form:{url: commit.url}}, (e, r, body) ->
          c_url = if r.statusCode isnt 201 or e then commit.url else r.headers.location
          clg.add "* Change: #{change_msg} [#{commit.id.substring(0, 6)}](#{c_url}) - #{commit.author.name}\n"
          index += 1
      else
       index += 1

  i = setInterval () ->
    console.log index
    if index == req.body.commits.length
      clearInterval(i)
      clg.update()
      res.end "Success"
  , 1000


class Changelog
  constructor: (@gh_login, @gh_password, @repo) ->
    console.log @repo
    @client = github.client({username: @gh_login, password: @gh_password})
    @ghrepo = @client.repo(@repo)
    @lines = ''
    @

  add: (line) ->
    @lines = @lines + line

  update: () ->
    console.log @lines.length
    if (@lines.length == 0)
      return false
    console.log "Getting the ref"
    @_get_ref 'heads/develop'

  _get_ref: (ref) ->
    @ghrepo.ref ref, (err, body) =>
      console.log err
      return err if err
      @parent = body.object.sha
      @_get_commit body.object.sha

  _get_commit: (sha) ->
    @ghrepo.commit sha, (err, body) =>
      console.log err
      return err if err
      @_get_tree body.commit.tree.sha

  _get_tree: (sha) ->
    @ghrepo.tree sha, (err, body) =>
      console.log err
      return err if err
      @base_tree_sha = sha
      @_get_blob(node.sha) for node in body.tree when node.path == 'CHANGELOG.md'

  _get_blob: (sha) ->
    console.log "Get Blob"
    @ghrepo.blob sha, (err, body) =>
      console.log err
      return err if err
      data = new Buffer(body.content, 'base64').toString('utf8')
      data = @lines + data
      @_create_blob(data)

  _create_blob: (content) ->
    console.log "Creating Blob"
    @ghrepo.create_blob content, 'utf-8', (err, body) =>
       return err if err
       @_update_tree(body.sha)

  _update_tree: (sha) ->
    console.log "Updating tree"
    @ghrepo.create_tree {base_tree: @base_tree_sha, tree: [{path: 'CHANGELOG.md', mode: 100644, type: 'blob', sha: sha}]}, (err, body) =>
       return err if err
       @_create_commit body.sha

  _create_commit: (sha) ->
    @ghrepo.create_commit "Update Changelog", sha, [@parent], (err, body) =>
       return err if err
       @_update_ref body.sha

  _update_ref: (sha) ->
    @ghrepo.update_reference 'heads/develop', sha, (err, body) =>
      return err if err
      return true


class PodioIssue
  constructor: (@client_res) ->

  comment_issue: (item_id, commit_url, success_cb, error_cb) ->
    podio_api = new Podio()

    data =
      value: "Referenced in commit : " + commit_url
    podio_api.comment item_id, data, success_cb, error

  update_bug_number: (item_id, success_cb, error_cb) ->
    podio_api = new Podio()
    data =
      fields:
        bug_number:
          item_id
    podio_api.update_item item_id, data, success_cb, error_cb

  solve_issue: (item_id, commit_url, success_cb, error_cb) ->
    podio_api = new Podio()
    data =
      fields:
        status:
          "Fixed"


    comment_cb = (data) =>
      data =
        value: "Fixed in commit : " + commit_url
      podio_api.comment item_id, data, success_cb, error_cb

    podio_api.update_item item_id, data, comment_cb, error_cb

