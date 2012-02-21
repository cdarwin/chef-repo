#
# Cookbook Name:: swerc
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

include_recipe "lighttpd::mod_cgi"
include_recipe "9base"

execute "get_discount" do
  cwd "/tmp"
  command <<-COMMAND
    curl http://www.pell.portland.or.us/~orc/Code/discount/discount-2.1.3.tar.bz2 | tar xjf -
    cd discount*
    ./configure.sh --prefix=/usr
    make
    make install
  COMMAND
end

execute "get_swerc" do
  cwd    "/srv"
  command "curl http://hg.suckless.org/swerc/archive/tip.tar.gz | tar xzf - ; mv swerc* swerc"
  action :nothing
end

execute "include_swerc_config" do
  command "echo 'include \"/etc/lighttpd/sites.conf\"' >> /etc/lighttpd/lighttpd.conf"
  action :nothing
end

directory "/var/www/sites" do
  owner "cdarwin"
end

git "/var/www/sites" do
  repository "git@github.com:cdarwin/sites.git"
  action :sync
  user   "cdarwin"
end

cookbook_file "/etc/lighttpd/sites.conf" do
  source "sites.conf"
  mode   0644
  #notifies :restart, "service[lighttpd]", :immediately
end
