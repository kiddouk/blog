#
#
# github url : repos/show/:user/:repo/tags
# syntax : show( me ) all bugs from <tag> to <tag>

module.exports = (robot) ->
  github = require("githubot")(robot)
  robot.respond /show (me )all bugs in ([a-z]+) from ([a-z0-9-.]+) to ([a-z0-9-.]+)/i, (msg) ->
    repo = msg.match[2]
    user = "GameIsland"
    tags_url = "https://github.com/api/v2/json/repos/show/#{user}/#{repo}/tags"
    tag1 = msg.match[3]
    tag2 = msg.match[4]
    github.get tags_url, (tags) ->
      if tags.length == 0 or !tags.tags.hasOwnProperty tag1 or !tags.tags.hasOwnProperty tag2
        msg.send "Sorry my friend but I could'nt find the required tags"
      else
       # Now get the commits
       diff_url = "/repos/#{user}/#{repo}/compare/#{tags.tags[tag1]}...#{tags.tags[tag2]}"
       podio_bug_pattern = ///
        fix(es)?\spodio(/)?#([0-9]+)
       ///

       github.get diff_url, (data) ->
         for commit in data.commits
           match = commit.commit.message.match(podio_bug_pattern)
           if match?
                podio_bug_id = match[3]
                msg.send "Fixes Podio : https://football.podio.com/development/item/#{podio_bug_id}"



