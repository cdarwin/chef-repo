#
# Cookbook Name:: cdarwin
# Recipe:: default
#
# Copyright 2012, Jason Thigpen
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

%w{git-core tmux vim-nox vim-rails pdksh htop}.each do |pkg|
  package pkg do
    action :install
  end
end

search(:users, 'id:cdarwin') do |u|
  home_dir = "/home/#{u['id']}"

  template "#{home_dir}/.ssh/id_rsa" do
    source "id_rsa.erb"
    owner  u['id']
    group  u['id']
    mode   0600
    variables :priv_key => u['priv_key']
  end

  template "#{home_dir}/.ssh/known_hosts" do
    source "known_hosts.erb"
    owner  u['id']
    group  u['id']
    mode   0644
    variables :known_hosts => u['known_hosts']
  end

  execute "put_dot_files_in_place" do
    cwd         "#{home_dir}/dot"
    user        u['id']
    group       u['id']
    environment ({'HOME' => "#{home_dir}"})
    command     "for i in .[a-zA-Z]* ; do [ ${i} != '.git' ] && cp -r ${i} ~/ ; done"
    action      :nothing
  end

  git "#{home_dir}/dot" do
    repository "git@github.com:cdarwin/dot.git"
    reference  "master"
    user       u['id']
    group      u['id']
    action     :sync
    notifies   :run, resources(:execute => "put_dot_files_in_place")
  end
end
