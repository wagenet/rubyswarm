# CONFIGURE

# The location of the TestSwarm that you're going to run against.

@swarm = "http://localhost:3000"

# Your authorization token.
@auth_token = "Q7j7T4UMvZMzpISwCwAY"

# The number of commits to search back through
@num = 1

# The maximum number of times you want the tests to be run.
@max_runs = 5

# The directory in which the checkouts will occur.
@base_dir = "/Users/peterwagenet/Programming/Ruby/RubySwarm/sc_tests/frameworks/sproutcore"

# The name of the job that will be submitted
# (pick a descriptive, but short, name to make it easy to search)
# Note: The string {REV} will be replaced with the current
#       commit number/hash.
@job_name = "SproutCore Commit"
@job_url = "<a href=\"http://github.com/sproutcore/sproutcore/commit/{FREV}\">{REV}</a>"

# The browsers you wish to run against. Options include:
#  - "all" all available browsers.
#  - "popular" the most popular browser (99%+ of all browsers in use)
#  - "current" the current release of all the major browsers
#  - "gbs" the browsers currently supported in Yahoo's Graded Browser Support
#  - "beta" upcoming alpha/beta of popular browsers
#  - "mobile" the current releases of mobile browsers
#  - "popularbeta" the most popular browser and their upcoming releases
#  - "popularbetamobile" the most popular browser and their upcoming releases and mobile browsers
@browsers = "popularbetamobile"

# All the suites that you wish to run within this job
# (can be any number of suites)

## insert static suite list here
@suites = {};

# Comment these out if you wish to define a custom set of @suites above
## REPLACE local
# @suite = "http://swarm.jquery.org/git/jquery/{REV}";
@suite = "http://localhost:3000/sproutcore"

@build_suites = lambda do
  Dir.glob("#{@base_dir}/frameworks/*/tests").each do |f|
    if f =~ /([^\/]+)\/tests/
      @suites[$1] = "#{@suite}/#{$1}/en/{FREV}/tests.html"
    end
  end
end

########### NO NEED TO CONFIGURE BELOW HERE ############

require 'cgi'
require 'json'

DEBUG = true

unless File.exists?(@base_dir)
  raise "Problem locating source"
end

puts "chdir #{@base_dir}" if DEBUG
Dir.chdir @base_dir

cmd = "git log -#{@num} --reverse --pretty='format:%H'"
puts cmd if $DEBUG
revs = `#{cmd}`.split("\n")
done = File.exists?("#{@base_dir}/done.txt") ? `cat #{@base_dir}/done.txt`.split("\n") : []

def clean_rev(str, rev, frev)
  str.to_s.gsub('{REV}', rev).gsub('{FREV}', frev)
end

for frev in revs
	rev = frev[0..6]

	unless done.include?(rev)
		puts "New revision: #{rev}" if DEBUG

		@build_suites.call if @build_suites

		props = {
			"max"        => @max_runs,
			"name"       => @job_name,
			"browsers"   => @browsers,
      "revision"   => frev,
      "url"        => @job_url
    }
    props.each{|k,v| props[k] = clean_rev(v, rev, frev) }

    props["suites"] = {}
    for name, path in @suites.sort
      props["suites"][clean_rev(name, rev, frev)] = clean_rev(path, rev, frev)
		end

    params = {
      'auth_token' => @auth_token,
      'job' => props
    }

    cmd = %[curl -i -X POST -H "Content-Type:application/json" -H "Accept:application/json" -w %{http_code} -d '#{params.to_json}' #{@swarm}/jobs.json]
		puts cmd if DEBUG

    results = `#{cmd}`
    code = -1

    if results =~ /^(.*)(\d{3})$/m
      results = $1
      code = $2

      puts "Results: #{results}" if DEBUG
      puts "Code: #{code}" if DEBUG
    end

    if code.to_i == 201
		  done << rev
		else
		  puts "Job not submitted properly"
    end
	else
		puts "Old revision: #{rev}" if DEBUG
  end
end

puts "Saving completed revisions" if DEBUG

File.open("#{@base_dir}/done.txt", 'w') do |f|
  for key in done
	  f.puts key
  end
end
