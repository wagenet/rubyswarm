# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed [or created alongside the db with db:setup].
#
# Examples:
#
#   cities = City.create[[{ :name => 'Chicago' }, { :name => 'Copenhagen' }]]
#   Mayor.create[:name => 'Daley', :city => cities.first]

data = [
  ['Firefox 2.0',         'gecko',        '^1.8.1',         true, false, true, false, false, false],
  ['Firefox 3.0',         'gecko',        '^1.9.0',         true, false, true, true, false, false],
  ['Firefox 3.5',         'gecko',        '^1.9.1[0-9.]*$', true, false, true, true, false, false],
  ['Firefox 3.6',         'gecko',        '^1.9.2[0-9.]*$', true, true, true, true, false, false],
  ['Firefox 4.0',         'gecko',        '^2.0.',          true, true, true, true, false, false],
  ['Safari 3.1',          'webkit',       '^525.19',        true, false, true, false, false, false],
  ['Safari 3.2',          'webkit',       '^525.2',         true, false, true, false, false, false],
  ['Safari 4.0',          'webkit',       '^531.',          true, true, true, true, false, false],
  ['Safari 5.0',          'webkit',       '^533.',          true, true, true, true, false, false],
  ['webOS Browser 1.4',   'webos',        '^1.4',           true, true, false, false, false, true],
  ['Mobile Safari 2.2.1', 'mobilewebkit', '^525',           true, false, false, false, false, true],
  ['Mobile Safari 3.1.3', 'mobilewebkit', '^528',           true, false, false, false, false, true],
  ['Mobile Safari 3.2',   'mobilewebkit', '^531',           true, true, false, false, false, true],
  ['Mobile Safari 4.0.x', 'mobilewebkit', '^532',           true, true, false, false, false, true],
  ['Mobile Safari 4.2.x', 'mobilewebkit', '^533',           true, true, false, false, true, true],
  ['Android 1.5/1.6',     'android',      '^528.5',         true, false, false, false, false, true],
  ['Android 2.1',         'android',      '^530.17',        true, true, false, false, false, true],
  ['Android 2.2',         'android',      '^533.',          true, true, false, false, false, true],
  ['S60 3.2',             's60',          '^3.2$',          true, false, false, false, false, true],
  ['S60 5.0',             's60',          '^5.0$',          true, true, false, false, false, true],
  ['Opera Mobile 10.0',   'operamobile',  '^2.4.18$',       true, true, false, false, false, true],
  ['Fennec 1.1b1',        'fennec',       '^1.1b1',         true, false, false, false, true, true],
  ['Windows Mobile 6.5',  'winmo',        '^6.',            true, false, false, false, false, true],
  ['Windows Mobile 7',    'winmo',        '^7.',            true, true, false, false, false, true],
  ['Blackberry 4.6',      'blackberry',   '^4.6',           true, false, false, false, false, true],
  ['Blackberry 4.7',      'blackberry',   '^4.7',           true, false, false, false, false, true],
  ['Blackberry 5',        'blackberry',   '^5.0',           true, true, false, false, false, true],
  ['Internet Explorer 6', 'msie',         '^6.',            true, false, true, true, false, false],
  ['Internet Explorer 7', 'msie',         '^7.',            true, false, true, true, false, false],
  ['Internet Explorer 8', 'msie',         '^8.',            true, true, true, true, false, false],
  ['Opera 9.6',           'presto',       '^2.1',           true, false, true, false, false, false],
  ['Opera 10.20',         'presto',       '^2.2.15$',       true, false, true, false, false, false],
  ['Opera 10.5x',         'presto',       '^2.5.',          true, true, true, false, false, false],
  ['Opera 10.6x',         'presto',       '^2.6.',          true, true, true, false, false, false],
  ['Chrome',              'chrome',       '.*',             true, true, true, true, false, false]
]

data.each do |d|
  Useragent.create(:name => d[0], :engine => d[1], :version => d[2], :active => d[3], :current => d[4],
                   :popular => d[5], :gbs => d[6], :beta => d[7], :mobile => d[8])
end
