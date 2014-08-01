_ = require 'lodash'
module.exports = ->
  @then (cb) =>
    @each @server.ulimit?.users, cb, ([name, user], next) =>
      @template [__dirname, 'templates', 'default', 'limits.conf'],
        to: "/etc/security/limits.d/#{name}_limits.conf"
        owner: 'root'
        group: 'root'
        sudo: true
        mode: '0644'
        variables: _.assign user, ulimit_user: name
        next
