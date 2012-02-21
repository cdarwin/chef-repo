#
# Cookbook Name:: 9base
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

%w{ curl build-essential }.each do |pkg|
  package pkg do
    action :install
  end
end

execute "install_9base" do
  creates "/usr/local/plan9"
  cwd "/tmp/9base-6"
  command "make install clean"
  action :nothing
end

execute "get_9base" do
  creates "/tmp/9base-6"
  cwd "/tmp"
  command "curl http://dl.suckless.org/tools/9base-6.tar.gz | tar xzf -"
  action :run
  notifies :run, resources(:execute => "install_9base")
end
