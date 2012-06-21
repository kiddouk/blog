
Podio = require('podio-coffee').Podio

module.exports = (robot) ->
 robot.router.post "/github/push", (req, res) ->
  podio_api = new PodioIssue(res)
  fixes_pattern = ///
   fix(es)?\spodio(/)?#[0-9]+
  ///gi
  ref_pattern = ///
   reference(s)?\spodio(/)?#[0-9]+
  ///gi
   item_pattern = ///
   podio(/)?#([0-9]+)
  ///i


  success_cb = (data) -> res.end "success"

  for commit in req.body.commits
    fixes = commit.message.match(fixes_pattern)
    references = commit.message.match(ref_pattern)
    if fixes?
      for fix in fixes
        [match_elem, slash, item_id] = fix.match(item_pattern)
        podio_api.solve_issue(item_id, commit.url, success_cb, ->
          res.end "Error"
          console.log "Error while processing GitHub Push")
    if references?
      for ref in references
        [match_elem, slash, item_id] = ref.match(item_pattern)
        podio_api.comment_issue(item_id, commit.url, success_cb, ->
          res.end "Error"
          console.log "Error while processing GitHub Push")
 


class PodioIssue
  constructor: (@client_res) ->

  comment_issue: (item_id, commit_url, success_cb, error_cb) ->
    podio_api = new Podio()

    data =
      value: "Referenced in commit : " + commit_url
    podio_api.comment item_id, data, success_cb, error_cb

  solve_issue: (item_id, commit_url, success_cb, error_cb) ->
    podio_api = new Podio()
    data =
      fields:
        status:
          "fixed"


    comment_cb = (data) =>
      data =
        value: "Fixed in commit : " + commit_url
      podio_api.comment item_id, data, success_cb, error_cb

    podio_api.update_item item_id, data, comment_cb, error_cb

