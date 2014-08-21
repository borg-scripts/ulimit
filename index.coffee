_ = require 'lodash'
module.exports = ->
  # required or else `su` won't load /etc/security/limits*
  # some ubuntu aws ami don't have it enabled by default
  @then @template, [__dirname, 'templates', 'default', 'pam.d_su'],
    to: '/etc/pam.d/su'
    owner: 'root'
    group: 'root'
    sudo: true
    mode: '0644'

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
