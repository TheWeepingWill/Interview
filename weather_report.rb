#!/usr/bin/env ruby
  require "net/http"

    ip = Net::HTTP.get(URI("https://ip-fast.com/api/ip/?format=json&location=True"))
    puts ip



